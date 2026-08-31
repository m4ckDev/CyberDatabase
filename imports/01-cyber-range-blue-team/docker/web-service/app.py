from flask import Flask, request, jsonify
from datetime import datetime, timezone
from pathlib import Path
import os

app = Flask(__name__)
LOG_PATH = Path(os.environ.get("LOG_PATH", "/app/logs/web-access.log"))
LOG_PATH.parent.mkdir(parents=True, exist_ok=True)


def write_access_log(status_code: int, note: str = "") -> None:
    ts = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    src = request.headers.get("X-Forwarded-For", request.remote_addr or "127.0.0.1")
    method = request.method
    path = request.full_path.rstrip("?")
    user_agent = request.headers.get("User-Agent", "unknown")
    line = f'{ts} src={src} method={method} path="{path}" status={status_code} ua="{user_agent}" note="{note}"\n'
    with LOG_PATH.open("a", encoding="utf-8") as f:
        f.write(line)


@app.after_request
def after(response):
    write_access_log(response.status_code, "local simulated web service")
    return response


@app.route("/")
def home():
    return """
    <html>
      <head><title>Blue Team Training Web Service</title></head>
      <body style="font-family:Arial; background:#0b1020; color:#f5f7fb; padding:40px;">
        <h1>Blue Team Training Web Service</h1>
        <p>This harmless local service creates web-style logs for defensive analysis.</p>
        <ul>
          <li><a style="color:#ffd166" href="/login">/login</a></li>
          <li><a style="color:#ffd166" href="/search?q=training">/search?q=training</a></li>
          <li><a style="color:#ffd166" href="/api/status">/api/status</a></li>
        </ul>
      </body>
    </html>
    """


@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        return jsonify({"status": "simulated", "message": "Login is disabled in this training app."}), 401
    return """
    <html>
      <body style="font-family:Arial; background:#0b1020; color:#f5f7fb; padding:40px;">
        <h2>Training Login Page</h2>
        <p>This page is non-functional and exists only to create defensive web logs.</p>
        <form method="POST">
          <input name="username" placeholder="demo" />
          <input name="password" placeholder="disabled" type="password" />
          <button type="submit">Submit Disabled Login</button>
        </form>
      </body>
    </html>
    """


@app.route("/search")
def search():
    query = request.args.get("q", "")
    return jsonify({"query": query, "result": "simulated local search result"})


@app.route("/api/status")
def status():
    return jsonify({"service": "blue-team-training-web", "status": "ok", "local_only": True})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
