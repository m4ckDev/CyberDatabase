import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';

const app = express();
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const PORT = process.env.PORT || 3000;
const INGEST_TOKEN = process.env.INGEST_TOKEN || 'change-me';

app.use(express.json({ limit: '256kb' }));
app.use(express.static(path.join(__dirname, 'public')));

const MAX_LOGS = 1000;
const state = {
  host: null,
  latest: null,
  history: [],
  devices: new Map(),
  alerts: [],
  logs: []
};

function nowIso() {
  return new Date().toISOString();
}

function pushLog(type, message, data = {}) {
  state.logs.unshift({ id: crypto.randomUUID(), time: nowIso(), type, message, data });
  if (state.logs.length > MAX_LOGS) state.logs.length = MAX_LOGS;
}

function pushAlert(level, title, message) {
  const key = `${level}:${title}:${message}`;
  if (state.alerts[0]?.key === key) return;
  state.alerts.unshift({ id: crypto.randomUUID(), key, time: nowIso(), level, title, message });
  if (state.alerts.length > 100) state.alerts.length = 100;
}

app.post('/api/ingest', (req, res) => {
  const auth = req.get('authorization') || '';
  if (auth !== `Bearer ${INGEST_TOKEN}`) return res.status(401).json({ error: 'unauthorized' });

  const p = req.body || {};
  if (!p.host || !p.sample) return res.status(400).json({ error: 'host and sample required' });

  state.host = p.host;
  state.latest = { ...p.sample, receivedAt: nowIso() };
  state.history.push(state.latest);
  if (state.history.length > 120) state.history.shift();

  for (const d of p.devices || []) {
    const id = d.mac || d.ip || d.name;
    if (!id) continue;
    const prev = state.devices.get(id) || {};
    state.devices.set(id, {
      ...prev,
      ...d,
      id,
      firstSeen: prev.firstSeen || nowIso(),
      lastSeen: nowIso()
    });
  }

  if (p.sample.downloadMbps > 250) pushAlert('info', 'High download activity', `${p.sample.downloadMbps.toFixed(1)} Mbps observed`);
  if (p.sample.uploadMbps > 80) pushAlert('warning', 'High upload activity', `${p.sample.uploadMbps.toFixed(1)} Mbps observed`);
  if (p.sample.connectionCount > 500) pushAlert('warning', 'Connection surge', `${p.sample.connectionCount} active connections observed`);

  pushLog('sample', 'Network sample received', {
    downloadMbps: p.sample.downloadMbps,
    uploadMbps: p.sample.uploadMbps,
    connections: p.sample.connectionCount
  });

  res.json({ ok: true });
});

app.get('/api/state', (req, res) => {
  res.json({
    host: state.host,
    latest: state.latest,
    history: state.history,
    devices: [...state.devices.values()].sort((a, b) => String(b.lastSeen).localeCompare(String(a.lastSeen))),
    alerts: state.alerts,
    logs: state.logs.slice(0, 250)
  });
});

app.delete('/api/logs', (req, res) => {
  state.logs = [];
  res.json({ ok: true });
});

app.get('/health', (_req, res) => res.json({ ok: true, service: 'wifi-sentinel' }));

app.listen(PORT, '0.0.0.0', () => {
  console.log(`WiFi Sentinel running on port ${PORT}`);
});
