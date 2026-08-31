from datetime import datetime, timezone
from pathlib import Path
import random
import time

LOG_DIR = Path("/data/logs")
LOG_DIR.mkdir(parents=True, exist_ok=True)

USERS = ["admin", "jdoe", "backup", "service-web", "analyst"]
IPS = ["10.10.10.15", "10.10.10.23", "172.16.4.50", "192.168.56.10", "203.0.113.45"]
WEB_PATHS = ["/", "/login", "/search?q=training", "/api/status", "/assets/app.css"]
SIMULATED_SUSPICIOUS_WEB = [
    "/login?user=admin",
    "/search?q=%27%20OR%20%271%27%3D%271",
    "/../../etc/passwd",
    "/admin/debug",
]
PROCESSES = [
    "pid=1201 user=root process=cron cmd=\"/usr/sbin/cron -f\"",
    "pid=1440 user=www-data process=python cmd=\"python app.py\"",
    "pid=1777 user=backup process=tar cmd=\"tar -czf backup.tar.gz /var/www\"",
    "pid=1888 user=www-data process=sh cmd=\"sh -c whoami\"",
]


def ts():
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def append(name, line):
    with (LOG_DIR / name).open("a", encoding="utf-8") as f:
        f.write(line + "\n")


def auth_event():
    user = random.choice(USERS)
    ip = random.choice(IPS)
    outcome = random.choices(["Accepted", "Failed"], weights=[3, 7])[0]
    append("auth.log", f"{ts()} host=blue-range sshd event={outcome} user={user} src={ip} service=ssh")


def web_event():
    ip = random.choice(IPS)
    suspicious = random.random() < 0.25
    path = random.choice(SIMULATED_SUSPICIOUS_WEB if suspicious else WEB_PATHS)
    status = random.choice([200, 200, 302, 401, 403, 404])
    append("web-access.log", f"{ts()} src={ip} method=GET path=\"{path}\" status={status} ua=\"training-generator\" note=\"synthetic\"")


def process_event():
    append("process.log", f"{ts()} host=blue-range {random.choice(PROCESSES)}")


def fim_event():
    events = [
        "path=/var/www/html/index.html action=modified user=deploy hash=changed",
        "path=/etc/ssh/sshd_config action=modified user=root hash=changed",
        "path=/tmp/training-note.txt action=created user=analyst hash=new",
        "path=/var/log/app.log action=modified user=www-data hash=changed",
    ]
    append("fim.log", f"{ts()} host=blue-range {random.choice(events)}")


def network_event():
    events = [
        "src=10.10.10.20 dst=10.10.10.5 dport=443 proto=tcp state=established process=nginx",
        "src=10.10.10.20 dst=203.0.113.45 dport=4444 proto=tcp state=attempted process=sh",
        "src=10.10.10.20 dst=198.51.100.10 dport=53 proto=udp state=allowed process=systemd-resolved",
        "src=10.10.10.20 dst=10.10.10.1 dport=22 proto=tcp state=established process=ssh",
    ]
    append("network.log", f"{ts()} host=blue-range {random.choice(events)}")


GENERATORS = [auth_event, web_event, process_event, fim_event, network_event]

if __name__ == "__main__":
    while True:
        random.choice(GENERATORS)()
        time.sleep(2)
