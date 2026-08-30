import os
from datetime import datetime, timedelta, timezone

import psycopg2
from argon2 import PasswordHasher
from argon2.exceptions import VerifyMismatchError
from fastapi import FastAPI, HTTPException, Depends, Request
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import jwt, JWTError
from pydantic import BaseModel
from rate_limit import advanced_tool_limiter

DATABASE_URL = os.environ["DATABASE_URL"]
SECRET_KEY = os.environ["SECRET_KEY"]
ALGORITHM = "HS256"

app = FastAPI(title="CyberDeck API", version="0.1.0")

ph = PasswordHasher()
security = HTTPBearer()


class LoginRequest(BaseModel):
    username: str
    password: str


def get_user(username: str):
    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                SELECT id, username, password_hash, is_admin, is_active
                FROM users
                WHERE username = %s
                """,
                (username,),
            )
            return cur.fetchone()


def create_token(user_id: int, username: str, is_admin: bool):
    expires = datetime.now(timezone.utc) + timedelta(hours=12)

    return jwt.encode(
        {
            "sub": str(user_id),
            "username": username,
            "is_admin": is_admin,
            "exp": expires,
        },
        SECRET_KEY,
        algorithm=ALGORITHM,
    )


def current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
):
    try:
        payload = jwt.decode(
            credentials.credentials,
            SECRET_KEY,
            algorithms=[ALGORITHM],
        )
        return payload
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid or expired token")


@app.get("/api/health")
def health():
    return {
        "status": "online",
        "service": "CyberDeck",
    }


@app.post("/api/login")
def login(data: LoginRequest):
    user = get_user(data.username)

    if not user:
        raise HTTPException(status_code=401, detail="Invalid username or password")

    user_id, username, password_hash, is_admin, is_active = user

    if not is_active:
        raise HTTPException(status_code=403, detail="Account disabled")

    try:
        ph.verify(password_hash, data.password)
    except VerifyMismatchError:
        raise HTTPException(status_code=401, detail="Invalid username or password")

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute(
                "UPDATE users SET last_login = NOW() WHERE id = %s",
                (user_id,),
            )

    return {
        "access_token": create_token(user_id, username, is_admin),
        "token_type": "bearer",
    }


@app.get("/api/me")
def me(user=Depends(current_user)):
    return {
        "id": user["sub"],
        "username": user["username"],
        "is_admin": user["is_admin"],
    }

from fastapi.responses import FileResponse

@app.get("/", include_in_schema=False)
def login_page():
    return FileResponse("/opt/cyberdeck/frontend/index.html")

@app.get("/dashboard", include_in_schema=False)
def dashboard_page():
    return FileResponse("/opt/cyberdeck/frontend/dashboard.html")

@app.get("/api/network/status")
def network_status(user=Depends(current_user)):
    import psutil
    import socket
    import time

    net = psutil.net_io_counters()
    mem = psutil.virtual_memory()

    try:
        ip = socket.gethostbyname(socket.gethostname())
    except Exception:
        ip = "unknown"

    return {
        "hostname": socket.gethostname(),
        "ip": ip,
        "cpu": psutil.cpu_percent(interval=0.1),
        "memory": mem.percent,
        "bytes_sent": net.bytes_sent,
        "bytes_recv": net.bytes_recv,
        "packets_sent": net.packets_sent,
        "packets_recv": net.packets_recv,
        "uptime": int(time.time() - psutil.boot_time())
    }


@app.get("/network", include_in_schema=False)
def network_page():
    return FileResponse("/opt/cyberdeck/frontend/network.html")

import subprocess
import re

class ToolRequest(BaseModel):
    target: str

def clean_target(target: str):
    target = target.strip()

    if not target or len(target) > 253:
        raise HTTPException(status_code=400, detail="Invalid target")

    if not re.fullmatch(r"[A-Za-z0-9.-]+", target):
        raise HTTPException(status_code=400, detail="Invalid target")

    return target

def run_tool(command):
    try:
        result = subprocess.run(
            command,
            capture_output=True,
            text=True,
            timeout=20
        )

        output = result.stdout.strip() or result.stderr.strip()

        return {
            "output": output,
            "return_code": result.returncode
        }

    except subprocess.TimeoutExpired:
        raise HTTPException(status_code=408, detail="Tool timed out")


@app.post("/api/tools/ping")
def tool_ping(data: ToolRequest, user=Depends(current_user)):
    target = clean_target(data.target)
    return run_tool(["ping", "-c", "4", "-W", "2", target])


@app.post("/api/tools/dns")
def tool_dns(data: ToolRequest, user=Depends(current_user)):
    target = clean_target(data.target)
    return run_tool(["dig", "+short", target])


@app.post("/api/tools/traceroute")
def tool_traceroute(data: ToolRequest, user=Depends(current_user)):
    target = clean_target(data.target)
    return run_tool(["traceroute", "-m", "12", "-w", "2", target])


@app.get("/tools", include_in_schema=False)
def tools_page():
    return FileResponse("/opt/cyberdeck/frontend/tools.html")

class ChatCreate(BaseModel):
    title: str = "new chat"

class ChatMessageCreate(BaseModel):
    content: str


@app.get("/api/chats")
def list_chats(user=Depends(current_user)):
    uid = int(user["sub"])

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT id, title, created_at, updated_at
                FROM chats
                WHERE user_id = %s
                ORDER BY updated_at DESC
            """, (uid,))

            rows = cur.fetchall()

    return [
        {
            "id": r[0],
            "title": r[1],
            "created_at": r[2].isoformat(),
            "updated_at": r[3].isoformat()
        }
        for r in rows
    ]


@app.post("/api/chats")
def create_chat(data: ChatCreate, user=Depends(current_user)):
    uid = int(user["sub"])
    title = (data.title or "new chat").strip()[:120] or "new chat"

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO chats (user_id, title)
                VALUES (%s, %s)
                RETURNING id, title, created_at, updated_at
            """, (uid, title))

            r = cur.fetchone()

    return {
        "id": r[0],
        "title": r[1],
        "created_at": r[2].isoformat(),
        "updated_at": r[3].isoformat()
    }


@app.get("/api/chats/{chat_id}/messages")
def chat_messages(chat_id: int, user=Depends(current_user)):
    uid = int(user["sub"])

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT 1 FROM chats WHERE id=%s AND user_id=%s",
                (chat_id, uid)
            )

            if not cur.fetchone():
                raise HTTPException(status_code=404, detail="Chat not found")

            cur.execute("""
                SELECT id, role, content, created_at
                FROM chat_messages
                WHERE chat_id=%s
                ORDER BY id
            """, (chat_id,))

            rows = cur.fetchall()

    return [
        {
            "id": r[0],
            "role": r[1],
            "content": r[2],
            "created_at": r[3].isoformat()
        }
        for r in rows
    ]


@app.post("/api/chats/{chat_id}/messages")
def create_chat_message(
    chat_id: int,
    data: ChatMessageCreate,
    user=Depends(current_user)
):
    uid = int(user["sub"])
    content = data.content.strip()

    if not content:
        raise HTTPException(status_code=400, detail="Empty message")

    if len(content) > 20000:
        raise HTTPException(status_code=400, detail="Message too long")

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT 1 FROM chats WHERE id=%s AND user_id=%s",
                (chat_id, uid)
            )

            if not cur.fetchone():
                raise HTTPException(status_code=404, detail="Chat not found")

            cur.execute("""
                INSERT INTO chat_messages (chat_id, role, content)
                VALUES (%s, 'user', %s)
                RETURNING id, created_at
            """, (chat_id, content))

            message_id, created_at = cur.fetchone()

            cur.execute(
                "UPDATE chats SET updated_at=NOW() WHERE id=%s",
                (chat_id,)
            )

    return {
        "id": message_id,
        "role": "user",
        "content": content,
        "created_at": created_at.isoformat()
    }


@app.get("/chats", include_in_schema=False)
def chats_page():
    return FileResponse("/opt/cyberdeck/frontend/chats.html")

class RoomCreate(BaseModel):
    name: str

class RoomMessageCreate(BaseModel):
    content: str


@app.get("/api/rooms")
def list_rooms(user=Depends(current_user)):
    uid = int(user["sub"])

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT
                    r.id,
                    r.name,
                    COUNT(rm.user_id),
                    EXISTS(
                        SELECT 1
                        FROM room_members x
                        WHERE x.room_id = r.id
                        AND x.user_id = %s
                    )
                FROM rooms r
                LEFT JOIN room_members rm ON rm.room_id = r.id
                GROUP BY r.id
                ORDER BY r.name
            """, (uid,))

            rows = cur.fetchall()

    return [
        {
            "id": r[0],
            "name": r[1],
            "members": r[2],
            "joined": r[3]
        }
        for r in rows
    ]


@app.post("/api/rooms")
def create_room(data: RoomCreate, user=Depends(current_user)):
    uid = int(user["sub"])

    name = data.name.strip().lower()
    name = re.sub(r"[^a-z0-9_-]+", "-", name).strip("-")

    if not name or len(name) > 40:
        raise HTTPException(status_code=400, detail="Invalid room name")

    try:
        with psycopg2.connect(DATABASE_URL) as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    INSERT INTO rooms (name, created_by)
                    VALUES (%s, %s)
                    RETURNING id
                """, (name, uid))

                room_id = cur.fetchone()[0]

                cur.execute("""
                    INSERT INTO room_members (room_id, user_id)
                    VALUES (%s, %s)
                """, (room_id, uid))

        return {"id": room_id, "name": name}

    except psycopg2.IntegrityError:
        raise HTTPException(status_code=409, detail="Room already exists")


@app.post("/api/rooms/{room_id}/join")
def join_room(room_id: int, user=Depends(current_user)):
    uid = int(user["sub"])

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT 1 FROM rooms WHERE id=%s", (room_id,))

            if not cur.fetchone():
                raise HTTPException(status_code=404, detail="Room not found")

            cur.execute("""
                INSERT INTO room_members (room_id, user_id)
                VALUES (%s, %s)
                ON CONFLICT DO NOTHING
            """, (room_id, uid))

    return {"joined": True}


@app.get("/api/rooms/{room_id}/messages")
def get_room_messages(room_id: int, user=Depends(current_user)):
    uid = int(user["sub"])

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:

            cur.execute("""
                SELECT 1 FROM room_members
                WHERE room_id=%s AND user_id=%s
            """, (room_id, uid))

            if not cur.fetchone():
                raise HTTPException(status_code=403, detail="Join room first")

            cur.execute("""
                SELECT
                    m.id,
                    u.username,
                    m.content,
                    m.created_at
                FROM room_messages m
                JOIN users u ON u.id = m.user_id
                WHERE m.room_id=%s
                ORDER BY m.id DESC
                LIMIT 200
            """, (room_id,))

            rows = list(reversed(cur.fetchall()))

    return [
        {
            "id": r[0],
            "username": r[1],
            "content": r[2],
            "created_at": r[3].isoformat()
        }
        for r in rows
    ]


@app.post("/api/rooms/{room_id}/messages")
def send_room_message(
    room_id: int,
    data: RoomMessageCreate,
    user=Depends(current_user)
):
    uid = int(user["sub"])
    content = data.content.strip()

    if not content:
        raise HTTPException(status_code=400, detail="Empty message")

    if len(content) > 5000:
        raise HTTPException(status_code=400, detail="Message too long")

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:

            cur.execute("""
                SELECT 1 FROM room_members
                WHERE room_id=%s AND user_id=%s
            """, (room_id, uid))

            if not cur.fetchone():
                raise HTTPException(status_code=403, detail="Join room first")

            cur.execute("""
                INSERT INTO room_messages
                    (room_id, user_id, content)
                VALUES
                    (%s, %s, %s)
                RETURNING id, created_at
            """, (room_id, uid, content))

            message_id, created_at = cur.fetchone()

    return {
        "id": message_id,
        "content": content,
        "created_at": created_at.isoformat()
    }

import hashlib
import secrets

class InviteRegistration(BaseModel):
    token: str
    username: str
    password: str


def require_admin(user):
    if not user.get("is_admin"):
        raise HTTPException(status_code=403, detail="Admin required")


@app.get("/api/admin/rate-limits")
def admin_rate_limits(
    user=Depends(current_user)
):
    require_admin(user)
    return advanced_tool_limiter.snapshot()


@app.get("/api/admin/users")
def admin_users(user=Depends(current_user)):
    require_admin(user)

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT id, username, is_admin, is_active, created_at, last_login
                FROM users
                ORDER BY id
            """)
            rows = cur.fetchall()

    return [
        {
            "id": r[0],
            "username": r[1],
            "is_admin": r[2],
            "is_active": r[3],
            "created_at": r[4].isoformat(),
            "last_login": r[5].isoformat() if r[5] else None
        }
        for r in rows
    ]


@app.post("/api/admin/invites")
def create_invite(user=Depends(current_user)):
    require_admin(user)

    raw_token = secrets.token_urlsafe(32)
    token_hash = hashlib.sha256(raw_token.encode()).hexdigest()
    uid = int(user["sub"])

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO invites
                    (token_hash, created_by, expires_at)
                VALUES
                    (%s, %s, NOW() + INTERVAL '24 hours')
            """, (token_hash, uid))

    return {
        "token": raw_token,
        "expires_in": "24 hours"
    }


@app.post("/api/register")
def register_invited_user(data: InviteRegistration):

    username = data.username.strip()

    if not re.fullmatch(r"[A-Za-z0-9_.-]{3,40}", username):
        raise HTTPException(status_code=400, detail="Invalid username")

    if len(data.password) < 12:
        raise HTTPException(
            status_code=400,
            detail="Password must be at least 12 characters"
        )

    token_hash = hashlib.sha256(data.token.encode()).hexdigest()

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:

            cur.execute("""
                SELECT id
                FROM invites
                WHERE token_hash=%s
                AND used_at IS NULL
                AND expires_at > NOW()
                FOR UPDATE
            """, (token_hash,))

            invite = cur.fetchone()

            if not invite:
                raise HTTPException(
                    status_code=400,
                    detail="Invalid or expired invite"
                )

            password_hash = ph.hash(data.password)

            try:
                cur.execute("""
                    INSERT INTO users
                        (username, password_hash, is_admin, is_active)
                    VALUES
                        (%s, %s, FALSE, TRUE)
                    RETURNING id
                """, (username, password_hash))

                user_id = cur.fetchone()[0]

            except psycopg2.IntegrityError:
                raise HTTPException(
                    status_code=409,
                    detail="Username already exists"
                )

            cur.execute("""
                UPDATE invites
                SET used_at=NOW(), used_by=%s
                WHERE id=%s
            """, (user_id, invite[0]))

    return {"created": True}


@app.get("/admin", include_in_schema=False)
def admin_page():
    return FileResponse("/opt/cyberdeck/frontend/admin.html")


@app.get("/invite", include_in_schema=False)
def invite_page():
    return FileResponse("/opt/cyberdeck/frontend/invite.html")

@app.get("/api/learn/categories")
def learn_categories(user=Depends(current_user)):
    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT id, name
                FROM knowledge_categories
                ORDER BY sort_order, name
            """)
            rows = cur.fetchall()

    return [{"id": r[0], "name": r[1]} for r in rows]


@app.get("/api/learn")
def learn_entries(
    q: str = "",
    category: str = "",
    user=Depends(current_user)
):
    q = q.strip()
    category = category.strip()

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT
                    e.id,
                    c.name,
                    e.title,
                    e.command,
                    e.description,
                    e.example,
                    e.tags
                FROM knowledge_entries e
                JOIN knowledge_categories c
                    ON c.id = e.category_id
                WHERE
                    (%s = '' OR c.name = %s)
                AND (
                    %s = ''
                    OR e.title ILIKE '%%' || %s || '%%'
                    OR COALESCE(e.command,'') ILIKE '%%' || %s || '%%'
                    OR e.description ILIKE '%%' || %s || '%%'
                    OR COALESCE(e.tags,'') ILIKE '%%' || %s || '%%'
                )
                ORDER BY c.sort_order, e.title
                LIMIT 300
            """, (
                category, category,
                q, q, q, q, q
            ))

            rows = cur.fetchall()

    return [
        {
            "id": r[0],
            "category": r[1],
            "title": r[2],
            "command": r[3],
            "description": r[4],
            "example": r[5],
            "tags": r[6]
        }
        for r in rows
    ]


@app.get("/learn", include_in_schema=False)
def learn_page():
    return FileResponse("/opt/cyberdeck/frontend/learn.html")

class LabCreate(BaseModel):
    name: str
    description: str = ""


@app.get("/api/labs")
def get_labs(user=Depends(current_user)):
    uid = int(user["sub"])

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT id, name, description, created_at
                FROM labs
                WHERE user_id=%s
                ORDER BY created_at DESC
            """, (uid,))
            rows = cur.fetchall()

    return [
        {
            "id": r[0],
            "name": r[1],
            "description": r[2],
            "created_at": r[3].isoformat()
        }
        for r in rows
    ]


@app.post("/api/labs")
def create_lab(data: LabCreate, user=Depends(current_user)):
    uid = int(user["sub"])
    name = data.name.strip()

    if not name:
        raise HTTPException(status_code=400, detail="Name required")

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO labs (user_id, name, description)
                VALUES (%s, %s, %s)
                RETURNING id
            """, (uid, name[:120], data.description))

            lab_id = cur.fetchone()[0]

    return {"id": lab_id, "name": name}


@app.get("/labs", include_in_schema=False)
def labs_page():
    return FileResponse("/opt/cyberdeck/frontend/labs.html")

class TargetCreate(BaseModel):
    name: str
    address: str
    notes: str = ""


@app.get("/api/labs/{lab_id}")
def get_lab(lab_id: int, user=Depends(current_user)):
    uid = int(user["sub"])

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT id, name, description, created_at
                FROM labs
                WHERE id=%s AND user_id=%s
            """, (lab_id, uid))

            row = cur.fetchone()

    if not row:
        raise HTTPException(status_code=404, detail="Lab not found")

    return {
        "id": row[0],
        "name": row[1],
        "description": row[2],
        "created_at": row[3].isoformat()
    }


@app.get("/api/labs/{lab_id}/targets")
def get_lab_targets(lab_id: int, user=Depends(current_user)):
    uid = int(user["sub"])

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:

            cur.execute(
                "SELECT 1 FROM labs WHERE id=%s AND user_id=%s",
                (lab_id, uid)
            )

            if not cur.fetchone():
                raise HTTPException(status_code=404, detail="Lab not found")

            cur.execute("""
                SELECT id, name, address, notes, created_at
                FROM lab_targets
                WHERE lab_id=%s
                ORDER BY id
            """, (lab_id,))

            rows = cur.fetchall()

    return [
        {
            "id": r[0],
            "name": r[1],
            "address": r[2],
            "notes": r[3],
            "created_at": r[4].isoformat()
        }
        for r in rows
    ]


@app.post("/api/labs/{lab_id}/targets")
def create_lab_target(
    lab_id: int,
    data: TargetCreate,
    user=Depends(current_user)
):
    uid = int(user["sub"])

    name = data.name.strip()
    address = data.address.strip()

    if not name or not address:
        raise HTTPException(
            status_code=400,
            detail="Name and address required"
        )

    with psycopg2.connect(DATABASE_URL) as conn:
        with conn.cursor() as cur:

            cur.execute(
                "SELECT 1 FROM labs WHERE id=%s AND user_id=%s",
                (lab_id, uid)
            )

            if not cur.fetchone():
                raise HTTPException(status_code=404, detail="Lab not found")

            cur.execute("""
                INSERT INTO lab_targets
                    (lab_id, name, address, notes)
                VALUES
                    (%s, %s, %s, %s)
                RETURNING id
            """, (
                lab_id,
                name[:120],
                address[:255],
                data.notes
            ))

            target_id = cur.fetchone()[0]

    return {
        "id": target_id,
        "name": name,
        "address": address
    }

@app.get("/lab", include_in_schema=False)
def lab_workspace_page():
    return FileResponse("/opt/cyberdeck/frontend/lab.html")

class QuickToolRequest(BaseModel):
    target: str
    action: str


@app.post("/api/tools/run")
def quick_tool(
    data: QuickToolRequest,
    request: Request,
    user=Depends(current_user)
):
    target = clean_target(data.target)

    commands = {
        "ping": ["ping", "-c", "4", target],

        "dns": [
            "dig", "+short", target
        ],

        "reverse": [
            "dig", "-x", target, "+short"
        ],

        "trace": [
            "traceroute", "-m", "15", target
        ],

        "whois": [
            "whois", target
        ],

        "http": [
            "curl", "-I", "--max-time", "8",
            "http://" + target
        ],

        "https": [
            "curl", "-k", "-I", "--max-time", "8",
            "https://" + target
        ],

        "ssh": [
            "nc", "-vz", "-w", "3", target, "22"
        ],

        "http80": [
            "nc", "-vz", "-w", "3", target, "80"
        ],

        "https443": [
            "nc", "-vz", "-w", "3", target, "443"
        ],

        "smb": [
            "nc", "-vz", "-w", "3", target, "445"
        ],

        "rdp": [
            "nc", "-vz", "-w", "3", target, "3389"
        ]
    }

    command = commands.get(data.action)

    if not command:
        raise HTTPException(status_code=400, detail="Unknown tool")

    client_ip = (
        request.client.host
        if request.client
        else "unknown"
    )

    guard = advanced_tool_limiter.acquire(
        user_id=user["sub"],
        client_ip=client_ip,
        action=data.action,
        target=target
    )

    try:
        return run_tool(command)
    finally:
        guard.release()

# CYBERDECK_TOOLBOX_V2
from toolbox import install_toolbox
install_toolbox(app, current_user, DATABASE_URL)

# CYBERDECK_PLATFORM_V5
from platform_ext import install_platform

install_platform(
    app,
    current_user,
    DATABASE_URL,
    ph
)


# CYBERDECK_VPN_V1
from vpn_ext import install_vpn

install_vpn(
    app,
    current_user
)
