import { useEffect, useMemo, useState } from 'react'
import { AlertTriangle, CheckCircle2, ClipboardList, Database, FileText, Shield, Timer, UserRound } from 'lucide-react'

const API_BASE = import.meta.env.VITE_API_BASE || 'http://localhost:8000'
const severityOptions = ['Low', 'Medium', 'High', 'Critical']

function severityClass(severity) {
  return `severity severity-${severity?.toLowerCase()}`
}

function App() {
  const [alerts, setAlerts] = useState([])
  const [selectedId, setSelectedId] = useState(null)
  const [selectedAlert, setSelectedAlert] = useState(null)
  const [completedCases, setCompletedCases] = useState([])
  const [capstone, setCapstone] = useState(null)
  const [filter, setFilter] = useState('Open')
  const [selectedSeverity, setSelectedSeverity] = useState('Medium')
  const [selectedSteps, setSelectedSteps] = useState([])
  const [selectedReportItems, setSelectedReportItems] = useState([])
  const [note, setNote] = useState('')
  const [timelineEntry, setTimelineEntry] = useState('')
  const [evidenceName, setEvidenceName] = useState('')
  const [lastScore, setLastScore] = useState(null)

  async function loadAlerts() {
    const res = await fetch(`${API_BASE}/alerts${filter ? `?status=${filter}` : ''}`)
    const data = await res.json()
    setAlerts(data)
    if (!selectedId && data.length > 0) setSelectedId(data[0].id)
  }

  async function loadCompleted() {
    const res = await fetch(`${API_BASE}/cases/completed`)
    setCompletedCases(await res.json())
  }

  async function loadCapstone() {
    const res = await fetch(`${API_BASE}/capstone`)
    setCapstone(await res.json())
  }

  async function loadSelected(id) {
    if (!id) return
    const res = await fetch(`${API_BASE}/alerts/${id}`)
    const data = await res.json()
    setSelectedAlert(data)
    setSelectedSeverity(data.selected_severity || data.severity || 'Medium')
    setSelectedSteps(data.selected_steps || [])
    setSelectedReportItems(data.selected_report_items || [])
    setLastScore(null)
  }

  useEffect(() => {
    loadAlerts()
    loadCompleted()
    loadCapstone()
  }, [filter])

  useEffect(() => {
    loadSelected(selectedId)
  }, [selectedId])

  const stats = useMemo(() => {
    const open = alerts.filter(a => a.status === 'Open').length
    const completed = completedCases.length
    const avg = completedCases.length
      ? Math.round(completedCases.reduce((acc, c) => acc + Number(c.score || 0), 0) / completedCases.length)
      : 0
    return { open, completed, avg }
  }, [alerts, completedCases])

  function toggleItem(item, list, setter) {
    if (list.includes(item)) setter(list.filter(i => i !== item))
    else setter([...list, item])
  }

  async function addNote() {
    if (!note.trim() || !selectedAlert) return
    await fetch(`${API_BASE}/alerts/${selectedAlert.id}/notes`, {
      method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ note })
    })
    setNote('')
    await loadSelected(selectedAlert.id)
  }

  async function addTimeline() {
    if (!timelineEntry.trim() || !selectedAlert) return
    await fetch(`${API_BASE}/alerts/${selectedAlert.id}/timeline`, {
      method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ entry: timelineEntry })
    })
    setTimelineEntry('')
    await loadSelected(selectedAlert.id)
  }

  async function addEvidence() {
    if (!evidenceName.trim() || !selectedAlert) return
    await fetch(`${API_BASE}/alerts/${selectedAlert.id}/evidence`, {
      method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ name: evidenceName, description: 'Analyst-added placeholder evidence' })
    })
    setEvidenceName('')
    await loadSelected(selectedAlert.id)
  }

  async function submitTriage() {
    if (!selectedAlert) return
    const res = await fetch(`${API_BASE}/alerts/${selectedAlert.id}/triage`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        selected_severity: selectedSeverity,
        selected_steps: selectedSteps,
        selected_report_items: selectedReportItems,
        notes: note.trim() ? [note.trim()] : []
      })
    })
    const data = await res.json()
    setLastScore(data)
    setNote('')
    await loadAlerts()
    await loadCompleted()
    await loadSelected(selectedAlert.id)
  }

  async function resetSimulator() {
    await fetch(`${API_BASE}/reset`, { method: 'POST' })
    setSelectedId(null)
    await loadAlerts()
    await loadCompleted()
    await loadCapstone()
  }

  return (
    <main className="shell">
      <section className="hero">
        <div>
          <p className="eyebrow">LOCAL DEFENSIVE TRAINING LAB</p>
          <h1>SOC Analyst Simulator</h1>
          <p className="hero-copy">Triage alerts, investigate simulated telemetry, build timelines, attach evidence placeholders, and score your analyst decisions.</p>
        </div>
        <div className="hero-card">
          <Shield size={34} />
          <strong>Defensive-only</strong>
          <span>No exploit code. No malware. No phishing kits. Simulated data only.</span>
        </div>
      </section>

      <section className="stats-grid">
        <Stat icon={<AlertTriangle />} label="Visible Alerts" value={alerts.length} />
        <Stat icon={<CheckCircle2 />} label="Completed Cases" value={stats.completed} />
        <Stat icon={<Timer />} label="Average Score" value={`${stats.avg}%`} />
        <Stat icon={<Database />} label="Capstone Alerts" value={capstone?.alerts?.length || 0} />
      </section>

      <section className="workspace">
        <aside className="queue panel">
          <div className="panel-header">
            <h2>Alert Queue</h2>
            <select value={filter} onChange={e => setFilter(e.target.value)}>
              <option value="Open">Open</option>
              <option value="Completed">Completed</option>
              <option value="">All</option>
            </select>
          </div>
          <div className="queue-list">
            {alerts.map(alert => (
              <button key={alert.id} className={`alert-row ${selectedId === alert.id ? 'active' : ''}`} onClick={() => setSelectedId(alert.id)}>
                <span className="alert-id">{alert.id}</span>
                <strong>{alert.title}</strong>
                <span>{alert.asset} · {alert.user}</span>
                <span className={severityClass(alert.severity)}>{alert.severity}</span>
              </button>
            ))}
          </div>
        </aside>

        <section className="detail panel">
          {!selectedAlert ? (
            <div className="empty">Select an alert to begin.</div>
          ) : (
            <>
              <div className="detail-header">
                <div>
                  <p className="alert-id">{selectedAlert.id}</p>
                  <h2>{selectedAlert.title}</h2>
                  <p>{selectedAlert.summary}</p>
                </div>
                <span className={severityClass(selectedAlert.severity)}>{selectedAlert.severity}</span>
              </div>

              <div className="meta-grid">
                <Meta icon={<ClipboardList />} label="Category" value={selectedAlert.category} />
                <Meta icon={<Database />} label="Source" value={selectedAlert.source} />
                <Meta icon={<UserRound />} label="User" value={selectedAlert.user} />
                <Meta icon={<Timer />} label="Timestamp" value={selectedAlert.timestamp} />
              </div>

              <div className="section-block">
                <h3>Alert Details</h3>
                <p>{selectedAlert.details}</p>
                {selectedAlert.incident_id && <p className="incident-pill">Connected incident: {selectedAlert.incident_id}</p>}
              </div>

              <div className="triage-grid">
                <div className="section-block">
                  <h3>1. Select Severity</h3>
                  <div className="button-row">
                    {severityOptions.map(level => (
                      <button key={level} className={selectedSeverity === level ? 'chip selected' : 'chip'} onClick={() => setSelectedSeverity(level)}>{level}</button>
                    ))}
                  </div>
                </div>

                <div className="section-block">
                  <h3>2. Investigation Steps</h3>
                  {selectedAlert.expected_steps.map(step => (
                    <label className="check-row" key={step}>
                      <input type="checkbox" checked={selectedSteps.includes(step)} onChange={() => toggleItem(step, selectedSteps, setSelectedSteps)} />
                      {step}
                    </label>
                  ))}
                </div>

                <div className="section-block">
                  <h3>3. Report Quality Checklist</h3>
                  {selectedAlert.report_checklist.map(item => (
                    <label className="check-row" key={item}>
                      <input type="checkbox" checked={selectedReportItems.includes(item)} onChange={() => toggleItem(item, selectedReportItems, setSelectedReportItems)} />
                      {item}
                    </label>
                  ))}
                </div>
              </div>

              <div className="section-block">
                <h3>Case Notes</h3>
                <div className="input-row">
                  <input value={note} onChange={e => setNote(e.target.value)} placeholder="Add analyst note..." />
                  <button onClick={addNote}>Add Note</button>
                </div>
                <ul className="compact-list">{selectedAlert.notes?.map((n, i) => <li key={i}>{n}</li>)}</ul>
              </div>

              <div className="section-block">
                <h3>Timeline Builder</h3>
                <ul className="compact-list simulated">{selectedAlert.timeline?.map((t, i) => <li key={i}>{t}</li>)}</ul>
                <div className="input-row">
                  <input value={timelineEntry} onChange={e => setTimelineEntry(e.target.value)} placeholder="Add timeline entry..." />
                  <button onClick={addTimeline}>Add Timeline</button>
                </div>
                <ul className="compact-list">{selectedAlert.timeline_entries?.map((t, i) => <li key={i}>{t}</li>)}</ul>
              </div>

              <div className="section-block">
                <h3>Evidence Attachment Placeholder</h3>
                <ul className="compact-list simulated">{selectedAlert.evidence?.map((e, i) => <li key={i}>{e}</li>)}</ul>
                <div className="input-row">
                  <input value={evidenceName} onChange={e => setEvidenceName(e.target.value)} placeholder="Record evidence placeholder name..." />
                  <button onClick={addEvidence}>Attach Placeholder</button>
                </div>
                <ul className="compact-list">{selectedAlert.evidence_items?.map((e, i) => <li key={i}>{e.name}: {e.description}</li>)}</ul>
              </div>

              <div className="submit-row">
                <button className="primary" onClick={submitTriage}>Submit Case for Scoring</button>
                <button className="secondary" onClick={resetSimulator}>Reset Simulator</button>
              </div>

              {lastScore && (
                <div className="score-card">
                  <FileText />
                  <div>
                    <h3>Final Score: {lastScore.score}%</h3>
                    <p>{lastScore.score_summary}</p>
                    {lastScore.score_breakdown && (
                      <p className="score-breakdown">
                        Severity {lastScore.score_breakdown.severity_points}/30 · Investigation {lastScore.score_breakdown.investigation_step_points}/40 · Report {lastScore.score_breakdown.report_quality_points}/20 · Notes {lastScore.score_breakdown.notes_points}/10
                      </p>
                    )}
                  </div>
                </div>
              )}
            </>
          )}
        </section>
      </section>

      <section className="panel capstone-panel">
        <div className="panel-header">
          <div>
            <p className="eyebrow">FINAL EXERCISE</p>
            <h2>{capstone?.title || 'Capstone Case'}</h2>
            <p>{capstone?.objective}</p>
          </div>
          <span className="incident-pill">{capstone?.incident_id}</span>
        </div>
        <div className="capstone-list">
          {capstone?.alerts?.map(alert => (
            <button key={alert.id} onClick={() => { setFilter(''); setSelectedId(alert.id); window.scrollTo({ top: 0, behavior: 'smooth' }) }}>
              <span>{alert.id}</span>
              <strong>{alert.title}</strong>
              <em>{alert.timestamp}</em>
            </button>
          ))}
        </div>
      </section>
    </main>
  )
}

function Stat({ icon, label, value }) {
  return <div className="stat-card">{icon}<span>{label}</span><strong>{value}</strong></div>
}

function Meta({ icon, label, value }) {
  return <div className="meta-card">{icon}<span>{label}</span><strong>{value}</strong></div>
}

export default App
