# Docker Notes

Run the simulator with:

```powershell
docker compose up --build
```

Containers:

- `soc-sim-backend` exposes FastAPI on `localhost:8000`
- `soc-sim-frontend` exposes React/Vite on `localhost:5173`

The SQLite database persists to `backend/data/soc_simulator.sqlite3`.
