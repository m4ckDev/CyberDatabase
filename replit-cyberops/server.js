import express from 'express';
import pg from 'pg';
import path from 'path';
import { fileURLToPath } from 'url';

const { Pool } = pg;
const app = express();
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

app.use(express.json({ limit: '2mb' }));
app.use(express.static(path.join(__dirname, 'public')));

const pool = process.env.DATABASE_URL
  ? new Pool({ connectionString: process.env.DATABASE_URL, ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false })
  : null;

const memory = {
  labs: [
    { id: 1, name: 'Metasploitable2', platform: 'Home Lab', target: '10.10.10.0/24', status: 'Active', scope: 'Owned lab only', notes: 'Practice enumeration and service validation.' }
  ],
  findings: [],
  commands: []
};

async function initDb() {
  if (!pool) return;
  await pool.query(`
    CREATE TABLE IF NOT EXISTS labs (
      id SERIAL PRIMARY KEY,
      name TEXT NOT NULL,
      platform TEXT,
      target TEXT,
      status TEXT DEFAULT 'Active',
      scope TEXT NOT NULL,
      notes TEXT,
      created_at TIMESTAMPTZ DEFAULT NOW()
    );
    CREATE TABLE IF NOT EXISTS findings (
      id SERIAL PRIMARY KEY,
      lab_id INTEGER REFERENCES labs(id) ON DELETE CASCADE,
      title TEXT NOT NULL,
      severity TEXT DEFAULT 'Info',
      evidence TEXT,
      remediation TEXT,
      status TEXT DEFAULT 'Open',
      created_at TIMESTAMPTZ DEFAULT NOW()
    );
    CREATE TABLE IF NOT EXISTS commands (
      id SERIAL PRIMARY KEY,
      lab_id INTEGER REFERENCES labs(id) ON DELETE CASCADE,
      tool TEXT,
      command TEXT NOT NULL,
      result TEXT,
      created_at TIMESTAMPTZ DEFAULT NOW()
    );
  `);
}

app.get('/api/health', (_req, res) => res.json({ ok: true, database: Boolean(pool) }));

app.get('/api/dashboard', async (_req, res) => {
  if (!pool) {
    return res.json({ labs: memory.labs, findings: memory.findings, commands: memory.commands });
  }
  const [labs, findings, commands] = await Promise.all([
    pool.query('SELECT * FROM labs ORDER BY created_at DESC'),
    pool.query('SELECT * FROM findings ORDER BY created_at DESC'),
    pool.query('SELECT * FROM commands ORDER BY created_at DESC LIMIT 50')
  ]);
  res.json({ labs: labs.rows, findings: findings.rows, commands: commands.rows });
});

app.post('/api/labs', async (req, res) => {
  const { name, platform = '', target = '', status = 'Active', scope, notes = '' } = req.body;
  if (!name || !scope) return res.status(400).json({ error: 'Lab name and authorized scope are required.' });
  if (!pool) {
    const lab = { id: Date.now(), name, platform, target, status, scope, notes };
    memory.labs.unshift(lab);
    return res.status(201).json(lab);
  }
  const result = await pool.query(
    'INSERT INTO labs (name, platform, target, status, scope, notes) VALUES ($1,$2,$3,$4,$5,$6) RETURNING *',
    [name, platform, target, status, scope, notes]
  );
  res.status(201).json(result.rows[0]);
});

app.post('/api/findings', async (req, res) => {
  const { lab_id = null, title, severity = 'Info', evidence = '', remediation = '', status = 'Open' } = req.body;
  if (!title) return res.status(400).json({ error: 'Finding title is required.' });
  if (!pool) {
    const finding = { id: Date.now(), lab_id, title, severity, evidence, remediation, status };
    memory.findings.unshift(finding);
    return res.status(201).json(finding);
  }
  const result = await pool.query(
    'INSERT INTO findings (lab_id, title, severity, evidence, remediation, status) VALUES ($1,$2,$3,$4,$5,$6) RETURNING *',
    [lab_id, title, severity, evidence, remediation, status]
  );
  res.status(201).json(result.rows[0]);
});

app.post('/api/commands', async (req, res) => {
  const { lab_id = null, tool = '', command, result = '' } = req.body;
  if (!command) return res.status(400).json({ error: 'Command is required.' });
  if (!pool) {
    const entry = { id: Date.now(), lab_id, tool, command, result };
    memory.commands.unshift(entry);
    return res.status(201).json(entry);
  }
  const dbResult = await pool.query(
    'INSERT INTO commands (lab_id, tool, command, result) VALUES ($1,$2,$3,$4) RETURNING *',
    [lab_id, tool, command, result]
  );
  res.status(201).json(dbResult.rows[0]);
});

app.get('*', (_req, res) => res.sendFile(path.join(__dirname, 'public', 'index.html')));

const port = process.env.PORT || 3000;
initDb()
  .then(() => app.listen(port, '0.0.0.0', () => console.log(`m4ckDev CyberOps running on port ${port}`)))
  .catch((error) => {
    console.error('Database initialization failed:', error);
    process.exit(1);
  });
