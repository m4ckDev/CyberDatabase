from fastapi import APIRouter, Depends, File, HTTPException, UploadFile
from fastapi.responses import FileResponse, JSONResponse, PlainTextResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel

from collections import defaultdict, deque
from pathlib import Path

import hashlib
import os
import re
import secrets
import socket
import subprocess
import time

import psutil
import psycopg2
from jose import jwt


def install_platform(app, current_user, database_url, password_hasher):

    router = APIRouter()

    secret_key = os.environ.get("SECRET_KEY", "")
    storage_dir = Path(
        os.environ.get(
            "CYBERDECK_STORAGE",
            "/opt/cyberdeck/files"
        )
    )

    capture_dir = Path(
        os.environ.get(
            "CYBERDECK_CAPTURES",
            "/opt/cyberdeck/captures"
        )
    )

    version = os.environ.get(
        "CYBERDECK_VERSION",
        "0.5.0"
    )

    max_upload_mb = int(
        os.environ.get(
            "MAX_UPLOAD_MB",
            "50"
        )
    )

    max_upload_bytes = (
        max_upload_mb * 1024 * 1024
    )

    storage_dir.mkdir(
        parents=True,
        exist_ok=True
    )

    capture_dir.mkdir(
        parents=True,
        exist_ok=True
    )


    def uid(user):

        value = (
            user.get("sub")
            or user.get("id")
        )

        if value is None:
            raise HTTPException(
                status_code=401,
                detail="Invalid user"
            )

        return int(value)


    def own_lab(cur, lab_id, user_id):

        cur.execute(
            """
            SELECT 1
            FROM labs
            WHERE id=%s
            AND user_id=%s
            """,
            (lab_id, user_id)
        )

        if not cur.fetchone():
            raise HTTPException(
                status_code=404,
                detail="Lab not found"
            )


    def clean_target(value):

        value = value.strip()

        if (
            not value
            or len(value) > 255
            or value.startswith("-")
        ):
            raise HTTPException(
                status_code=400,
                detail="Invalid target"
            )

        if not re.fullmatch(
            r"[A-Za-z0-9._:\-/]+",
            value
        ):
            raise HTTPException(
                status_code=400,
                detail="Invalid target"
            )

        return value


    login_attempts = defaultdict(deque)


    @app.middleware("http")
    async def cyberdeck_security(
        request,
        call_next
    ):

        path = request.url.path

        client_ip = (
            request.client.host
            if request.client
            else "unknown"
        )

        if (
            path == "/api/login"
            and request.method == "POST"
        ):

            now = time.time()

            attempts = login_attempts[
                client_ip
            ]

            while (
                attempts
                and now - attempts[0] > 60
            ):
                attempts.popleft()

            if len(attempts) >= 12:

                return JSONResponse(
                    status_code=429,
                    content={
                        "detail":
                        "Too many login attempts"
                    }
                )

            attempts.append(now)


        response = await call_next(
            request
        )


        response.headers[
            "X-Content-Type-Options"
        ] = "nosniff"

        response.headers[
            "X-Frame-Options"
        ] = "DENY"

        response.headers[
            "Referrer-Policy"
        ] = "no-referrer"

        response.headers[
            "Permissions-Policy"
        ] = (
            "camera=(), "
            "microphone=(), "
            "geolocation=()"
        )

        response.headers[
            "Content-Security-Policy"
        ] = (
            "default-src 'self'; "
            "style-src 'self' 'unsafe-inline'; "
            "script-src 'self' 'unsafe-inline'; "
            "connect-src 'self'; "
            "img-src 'self' data:; "
            "object-src 'none'; "
            "base-uri 'self'; "
            "frame-ancestors 'none'"
        )

        if path.startswith("/api/"):
            response.headers[
                "Cache-Control"
            ] = "no-store"


        audit = (
            request.method
            in {
                "POST",
                "PUT",
                "PATCH",
                "DELETE"
            }
            or path
            in {
                "/api/login",
                "/api/terminal/run"
            }
        )


        if audit:

            user_id = None

            auth = request.headers.get(
                "authorization",
                ""
            )

            if (
                auth.lower().startswith(
                    "bearer "
                )
                and secret_key
            ):

                token = auth.split(
                    " ",
                    1
                )[1]

                try:

                    payload = jwt.decode(
                        token,
                        secret_key,
                        algorithms=["HS256"]
                    )

                    raw_uid = (
                        payload.get("sub")
                        or payload.get("id")
                    )

                    if raw_uid is not None:
                        user_id = int(
                            raw_uid
                        )

                except Exception:
                    pass


            try:

                with psycopg2.connect(
                    database_url
                ) as conn:

                    with conn.cursor() as cur:

                        cur.execute(
                            """
                            INSERT INTO audit_log
                            (
                                user_id,
                                method,
                                path,
                                status_code,
                                ip,
                                user_agent
                            )
                            VALUES
                            (
                                %s,%s,%s,%s,%s,%s
                            )
                            """,
                            (
                                user_id,
                                request.method,
                                path[:500],
                                response.status_code,
                                client_ip[:100],
                                request.headers.get(
                                    "user-agent",
                                    ""
                                )[:500]
                            )
                        )

            except Exception:
                pass


        return response


    class NoteCreate(BaseModel):

        title: str
        content: str = ""
        tags: str = ""


    class LabNoteCreate(BaseModel):

        content: str


    class FindingCreate(BaseModel):

        target_id: int | None = None
        title: str
        severity: str = "info"
        description: str = ""
        evidence: str = ""
        remediation: str = ""


    class JobCreate(BaseModel):

        action: str
        target: str
        lab_id: int | None = None
        target_id: int | None = None


    class CaptureCreate(BaseModel):

        target: str


    class AssetCreate(BaseModel):

        name: str
        address: str
        operating_system: str = ""
        tags: str = ""
        notes: str = ""


    class PasswordChange(BaseModel):

        current_password: str
        new_password: str


    class NotificationRead(BaseModel):

        read: bool = True


    @router.get("/api/version")
    def api_version(
        user=Depends(current_user)
    ):

        return {
            "name": "CyberDeck",
            "version": version
        }


    @router.get("/api/system/status")
    def system_status(
        user=Depends(current_user)
    ):

        mem = psutil.virtual_memory()
        disk = psutil.disk_usage("/")
        net = psutil.net_io_counters()

        uptime = int(
            time.time()
            - psutil.boot_time()
        )

        try:

            address = socket.gethostbyname(
                socket.gethostname()
            )

        except Exception:

            address = "unknown"


        services = {}

        for service in (
            "cyberdeck",
            "cyberdeck-worker",
            "postgresql"
        ):

            try:

                result = subprocess.run(
                    [
                        "systemctl",
                        "is-active",
                        service
                    ],
                    capture_output=True,
                    text=True,
                    timeout=3
                )

                services[service] = (
                    result.stdout.strip()
                    or "unknown"
                )

            except Exception:

                services[service] = (
                    "unknown"
                )


        counts = {}
        db_size = None

        try:

            with psycopg2.connect(
                database_url
            ) as conn:

                with conn.cursor() as cur:

                    for table in (
                        "users",
                        "rooms",
                        "labs",
                        "tool_runs",
                        "scan_jobs",
                        "user_files",
                        "assets"
                    ):

                        cur.execute(
                            f"""
                            SELECT COUNT(*)
                            FROM {table}
                            """
                        )

                        counts[table] = (
                            cur.fetchone()[0]
                        )

                    cur.execute(
                        """
                        SELECT
                        pg_database_size(
                            current_database()
                        )
                        """
                    )

                    db_size = (
                        cur.fetchone()[0]
                    )

        except Exception:
            pass


        return {
            "version": version,
            "hostname":
                socket.gethostname(),
            "ip": address,
            "uptime": uptime,
            "cpu_percent":
                psutil.cpu_percent(
                    interval=0.1
                ),
            "memory_percent":
                mem.percent,
            "memory_total":
                mem.total,
            "disk_percent":
                disk.percent,
            "disk_total":
                disk.total,
            "disk_free":
                disk.free,
            "bytes_sent":
                net.bytes_sent,
            "bytes_recv":
                net.bytes_recv,
            "load":
                list(
                    os.getloadavg()
                ),
            "database_bytes":
                db_size,
            "counts":
                counts,
            "services":
                services
        }


    @router.get("/api/notes")
    def list_notes(
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    SELECT
                        id,
                        title,
                        content,
                        tags,
                        pinned,
                        created_at,
                        updated_at
                    FROM user_notes
                    WHERE user_id=%s
                    ORDER BY
                        pinned DESC,
                        updated_at DESC
                    """,
                    (user_id,)
                )

                rows = cur.fetchall()


        return [
            {
                "id": r[0],
                "title": r[1],
                "content": r[2],
                "tags": r[3],
                "pinned": r[4],
                "created_at":
                    r[5].isoformat(),
                "updated_at":
                    r[6].isoformat()
            }
            for r in rows
        ]


    @router.post("/api/notes")
    def create_note(
        data: NoteCreate,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        title = (
            data.title
            .strip()[:180]
        )

        if not title:

            raise HTTPException(
                status_code=400,
                detail="Title required"
            )


        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    INSERT INTO user_notes
                    (
                        user_id,
                        title,
                        content,
                        tags
                    )
                    VALUES
                    (
                        %s,%s,%s,%s
                    )
                    RETURNING id
                    """,
                    (
                        user_id,
                        title,
                        data.content,
                        data.tags[:500]
                    )
                )

                note_id = (
                    cur.fetchone()[0]
                )


        return {
            "id": note_id
        }


    @router.delete(
        "/api/notes/{note_id}"
    )
    def delete_note(
        note_id: int,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    DELETE FROM user_notes
                    WHERE id=%s
                    AND user_id=%s
                    """,
                    (
                        note_id,
                        user_id
                    )
                )


        return {
            "deleted": True
        }


    @router.get("/api/files")
    def list_files(
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    SELECT
                        id,
                        original_name,
                        size_bytes,
                        mime_type,
                        sha256,
                        created_at
                    FROM user_files
                    WHERE user_id=%s
                    ORDER BY
                        created_at DESC
                    """,
                    (user_id,)
                )

                rows = cur.fetchall()


        return [
            {
                "id": r[0],
                "name": r[1],
                "size": r[2],
                "mime": r[3],
                "sha256": r[4],
                "created_at":
                    r[5].isoformat()
            }
            for r in rows
        ]


    @router.post("/api/files")
    async def upload_file(
        upload: UploadFile = File(...),
        user=Depends(current_user)
    ):

        user_id = uid(user)

        original = Path(
            upload.filename
            or "file"
        ).name[:255]

        stored = (
            f"{user_id}-"
            + secrets.token_hex(18)
        )

        user_dir = (
            storage_dir
            / str(user_id)
        )

        user_dir.mkdir(
            parents=True,
            exist_ok=True
        )

        path = (
            user_dir
            / stored
        )

        total = 0

        digest = hashlib.sha256()


        try:

            with path.open("wb") as handle:

                while True:

                    chunk = await upload.read(
                        1024 * 1024
                    )

                    if not chunk:
                        break

                    total += len(chunk)

                    if (
                        total
                        > max_upload_bytes
                    ):

                        raise HTTPException(
                            status_code=413,
                            detail=(
                                f"File exceeds "
                                f"{max_upload_mb} MB"
                            )
                        )

                    digest.update(chunk)

                    handle.write(chunk)

        except Exception:

            path.unlink(
                missing_ok=True
            )

            raise


        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    INSERT INTO user_files
                    (
                        user_id,
                        original_name,
                        stored_name,
                        size_bytes,
                        mime_type,
                        sha256
                    )
                    VALUES
                    (
                        %s,%s,%s,%s,%s,%s
                    )
                    RETURNING id
                    """,
                    (
                        user_id,
                        original,
                        stored,
                        total,
                        upload.content_type
                        or
                        "application/octet-stream",
                        digest.hexdigest()
                    )
                )

                file_id = (
                    cur.fetchone()[0]
                )


        return {
            "id": file_id,
            "name": original,
            "size": total
        }


    @router.get(
        "/api/files/{file_id}/download"
    )
    def download_file(
        file_id: int,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    SELECT
                        original_name,
                        stored_name,
                        mime_type
                    FROM user_files
                    WHERE id=%s
                    AND user_id=%s
                    """,
                    (
                        file_id,
                        user_id
                    )
                )

                row = cur.fetchone()


        if not row:

            raise HTTPException(
                status_code=404,
                detail="File not found"
            )


        path = (
            storage_dir
            / str(user_id)
            / row[1]
        )


        if not path.exists():

            raise HTTPException(
                status_code=404,
                detail=
                "File missing from disk"
            )


        return FileResponse(
            path,
            filename=row[0],
            media_type=row[2]
        )


    @router.delete(
        "/api/files/{file_id}"
    )
    def delete_file(
        file_id: int,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        stored = None

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    SELECT stored_name
                    FROM user_files
                    WHERE id=%s
                    AND user_id=%s
                    """,
                    (
                        file_id,
                        user_id
                    )
                )

                row = cur.fetchone()

                if row:

                    stored = row[0]

                    cur.execute(
                        """
                        DELETE FROM user_files
                        WHERE id=%s
                        AND user_id=%s
                        """,
                        (
                            file_id,
                            user_id
                        )
                    )


        if stored:

            (
                storage_dir
                / str(user_id)
                / stored
            ).unlink(
                missing_ok=True
            )


        return {
            "deleted": bool(stored)
        }


    @router.get("/api/logs")
    def audit_logs(
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                if user.get(
                    "is_admin"
                ):

                    cur.execute(
                        """
                        SELECT
                            a.id,
                            u.username,
                            a.method,
                            a.path,
                            a.status_code,
                            a.ip,
                            a.created_at
                        FROM audit_log a
                        LEFT JOIN users u
                        ON u.id=a.user_id
                        ORDER BY a.id DESC
                        LIMIT 300
                        """
                    )

                else:

                    cur.execute(
                        """
                        SELECT
                            a.id,
                            u.username,
                            a.method,
                            a.path,
                            a.status_code,
                            a.ip,
                            a.created_at
                        FROM audit_log a
                        LEFT JOIN users u
                        ON u.id=a.user_id
                        WHERE a.user_id=%s
                        ORDER BY a.id DESC
                        LIMIT 200
                        """,
                        (user_id,)
                    )


                rows = cur.fetchall()


        return [
            {
                "id": r[0],
                "username": r[1],
                "method": r[2],
                "path": r[3],
                "status": r[4],
                "ip": r[5],
                "created_at":
                    r[6].isoformat()
            }
            for r in rows
        ]


    @router.get(
        "/api/labs/{lab_id}/notes"
    )
    def lab_notes(
        lab_id: int,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                own_lab(
                    cur,
                    lab_id,
                    user_id
                )

                cur.execute(
                    """
                    SELECT
                        id,
                        content,
                        created_at
                    FROM lab_notes
                    WHERE lab_id=%s
                    ORDER BY id DESC
                    """,
                    (lab_id,)
                )

                rows = cur.fetchall()


        return [
            {
                "id": r[0],
                "content": r[1],
                "created_at":
                    r[2].isoformat()
            }
            for r in rows
        ]


    @router.post(
        "/api/labs/{lab_id}/notes"
    )
    def create_lab_note(
        lab_id: int,
        data: LabNoteCreate,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        content = (
            data.content.strip()
        )

        if not content:

            raise HTTPException(
                status_code=400,
                detail="Note required"
            )


        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                own_lab(
                    cur,
                    lab_id,
                    user_id
                )

                cur.execute(
                    """
                    INSERT INTO lab_notes
                    (
                        lab_id,
                        content
                    )
                    VALUES
                    (
                        %s,%s
                    )
                    RETURNING id
                    """,
                    (
                        lab_id,
                        content
                    )
                )

                note_id = (
                    cur.fetchone()[0]
                )


        return {
            "id": note_id
        }


    @router.get(
        "/api/labs/{lab_id}/findings"
    )
    def list_findings(
        lab_id: int,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                own_lab(
                    cur,
                    lab_id,
                    user_id
                )

                cur.execute(
                    """
                    SELECT
                        id,
                        target_id,
                        title,
                        severity,
                        description,
                        evidence,
                        remediation,
                        status,
                        created_at,
                        updated_at
                    FROM lab_findings
                    WHERE lab_id=%s
                    ORDER BY id DESC
                    """,
                    (lab_id,)
                )

                rows = cur.fetchall()


        return [
            {
                "id": r[0],
                "target_id": r[1],
                "title": r[2],
                "severity": r[3],
                "description": r[4],
                "evidence": r[5],
                "remediation": r[6],
                "status": r[7],
                "created_at":
                    r[8].isoformat(),
                "updated_at":
                    r[9].isoformat()
            }
            for r in rows
        ]


    @router.post(
        "/api/labs/{lab_id}/findings"
    )
    def create_finding(
        lab_id: int,
        data: FindingCreate,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        title = (
            data.title
            .strip()[:180]
        )

        severity = (
            data.severity
            .lower()
            .strip()
        )


        if severity not in {
            "info",
            "low",
            "medium",
            "high",
            "critical"
        }:

            raise HTTPException(
                status_code=400,
                detail="Invalid severity"
            )


        if not title:

            raise HTTPException(
                status_code=400,
                detail="Title required"
            )


        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                own_lab(
                    cur,
                    lab_id,
                    user_id
                )


                if data.target_id is not None:

                    cur.execute(
                        """
                        SELECT 1
                        FROM lab_targets
                        WHERE id=%s
                        AND lab_id=%s
                        """,
                        (
                            data.target_id,
                            lab_id
                        )
                    )

                    if not cur.fetchone():

                        raise HTTPException(
                            status_code=400,
                            detail="Invalid target"
                        )


                cur.execute(
                    """
                    INSERT INTO lab_findings
                    (
                        lab_id,
                        target_id,
                        title,
                        severity,
                        description,
                        evidence,
                        remediation
                    )
                    VALUES
                    (
                        %s,%s,%s,%s,%s,%s,%s
                    )
                    RETURNING id
                    """,
                    (
                        lab_id,
                        data.target_id,
                        title,
                        severity,
                        data.description,
                        data.evidence,
                        data.remediation
                    )
                )

                finding_id = (
                    cur.fetchone()[0]
                )


        return {
            "id": finding_id
        }


    @router.get(
        "/api/labs/{lab_id}/scans"
    )
    def lab_scans(
        lab_id: int,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                own_lab(
                    cur,
                    lab_id,
                    user_id
                )

                cur.execute(
                    """
                    SELECT
                        s.id,
                        s.target_id,
                        t.name,
                        s.scan_type,
                        s.command,
                        s.output,
                        s.created_at
                    FROM lab_scans s
                    LEFT JOIN lab_targets t
                    ON t.id=s.target_id
                    WHERE s.lab_id=%s
                    ORDER BY s.id DESC
                    LIMIT 100
                    """,
                    (lab_id,)
                )

                rows = cur.fetchall()


        return [
            {
                "id": r[0],
                "target_id": r[1],
                "target_name": r[2],
                "scan_type": r[3],
                "command": r[4],
                "output": r[5],
                "created_at":
                    r[6].isoformat()
            }
            for r in rows
        ]


    background_actions = {
        "host_discovery",
        "nmap_quick",
        "nmap_full",
        "nmap_service",
        "nmap_os",
        "nmap_udp",
        "nmap_safe",
        "nmap_vuln",
        "nikto_http",
        "nikto_https",
        "gobuster_http",
        "gobuster_https",
        "ssh_fingerprint",
        "smb_info",
        "trace",
        "whois",
        "tls"
    }


    @router.get("/api/jobs")
    def list_jobs(
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    SELECT
                        id,
                        action,
                        target,
                        status,
                        return_code,
                        created_at,
                        started_at,
                        finished_at,
                        output,
                        lab_id,
                        target_id
                    FROM scan_jobs
                    WHERE user_id=%s
                    ORDER BY id DESC
                    LIMIT 100
                    """,
                    (user_id,)
                )

                rows = cur.fetchall()


        return [
            {
                "id": r[0],
                "action": r[1],
                "target": r[2],
                "status": r[3],
                "return_code": r[4],
                "created_at":
                    r[5].isoformat(),
                "started_at":
                    r[6].isoformat()
                    if r[6]
                    else None,
                "finished_at":
                    r[7].isoformat()
                    if r[7]
                    else None,
                "output": r[8],
                "lab_id": r[9],
                "target_id": r[10]
            }
            for r in rows
        ]


    @router.post("/api/jobs")
    def create_job(
        data: JobCreate,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        action = (
            data.action.strip()
        )

        target = clean_target(
            data.target
        )


        if (
            action
            not in background_actions
        ):

            raise HTTPException(
                status_code=400,
                detail=
                "Unsupported background action"
            )


        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                if data.lab_id is not None:

                    own_lab(
                        cur,
                        data.lab_id,
                        user_id
                    )

                    if (
                        data.target_id
                        is not None
                    ):

                        cur.execute(
                            """
                            SELECT 1
                            FROM lab_targets
                            WHERE id=%s
                            AND lab_id=%s
                            """,
                            (
                                data.target_id,
                                data.lab_id
                            )
                        )

                        if not cur.fetchone():

                            raise HTTPException(
                                status_code=400,
                                detail=
                                "Invalid target"
                            )


                cur.execute(
                    """
                    INSERT INTO scan_jobs
                    (
                        user_id,
                        lab_id,
                        target_id,
                        action,
                        target,
                        status
                    )
                    VALUES
                    (
                        %s,%s,%s,%s,%s,
                        'queued'
                    )
                    RETURNING id
                    """,
                    (
                        user_id,
                        data.lab_id,
                        data.target_id,
                        action,
                        target
                    )
                )

                job_id = (
                    cur.fetchone()[0]
                )


        return {
            "id": job_id,
            "status": "queued"
        }


    @router.post(
        "/api/jobs/{job_id}/cancel"
    )
    def cancel_job(
        job_id: int,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    UPDATE scan_jobs
                    SET
                        status='canceled',
                        finished_at=NOW()
                    WHERE id=%s
                    AND user_id=%s
                    AND status='queued'
                    RETURNING id
                    """,
                    (
                        job_id,
                        user_id
                    )
                )

                row = cur.fetchone()


        if not row:

            raise HTTPException(
                status_code=409,
                detail=
                "Job cannot be canceled"
            )


        return {
            "canceled": True
        }


    @router.get("/api/captures")
    def list_captures(
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    SELECT
                        id,
                        target,
                        status,
                        size_bytes,
                        created_at,
                        finished_at,
                        error
                    FROM captures
                    WHERE user_id=%s
                    ORDER BY id DESC
                    LIMIT 100
                    """,
                    (user_id,)
                )

                rows = cur.fetchall()


        return [
            {
                "id": r[0],
                "target": r[1],
                "status": r[2],
                "size": r[3],
                "created_at":
                    r[4].isoformat(),
                "finished_at":
                    r[5].isoformat()
                    if r[5]
                    else None,
                "error": r[6]
            }
            for r in rows
        ]


    @router.post("/api/captures")
    def create_capture(
        data: CaptureCreate,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        target = clean_target(
            data.target
        )

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    INSERT INTO scan_jobs
                    (
                        user_id,
                        action,
                        target,
                        status
                    )
                    VALUES
                    (
                        %s,
                        'pcap_capture',
                        %s,
                        'queued'
                    )
                    RETURNING id
                    """,
                    (
                        user_id,
                        target
                    )
                )

                job_id = (
                    cur.fetchone()[0]
                )


                cur.execute(
                    """
                    INSERT INTO captures
                    (
                        user_id,
                        job_id,
                        target,
                        status
                    )
                    VALUES
                    (
                        %s,%s,%s,'queued'
                    )
                    RETURNING id
                    """,
                    (
                        user_id,
                        job_id,
                        target
                    )
                )

                capture_id = (
                    cur.fetchone()[0]
                )


        return {
            "id": capture_id,
            "job_id": job_id,
            "status": "queued"
        }


    @router.get(
        "/api/captures/{capture_id}/download"
    )
    def download_capture(
        capture_id: int,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    SELECT
                        path,
                        status
                    FROM captures
                    WHERE id=%s
                    AND user_id=%s
                    """,
                    (
                        capture_id,
                        user_id
                    )
                )

                row = cur.fetchone()


        if not row:

            raise HTTPException(
                status_code=404,
                detail="Capture not found"
            )


        if (
            row[1] != "completed"
            or not row[0]
        ):

            raise HTTPException(
                status_code=409,
                detail=
                "Capture is not ready"
            )


        path = Path(row[0])


        if not path.exists():

            raise HTTPException(
                status_code=404,
                detail=
                "Capture file missing"
            )


        return FileResponse(
            path,
            filename=(
                f"cyberdeck-capture-"
                f"{capture_id}.pcap"
            ),
            media_type=
            "application/vnd.tcpdump.pcap"
        )


    @router.delete(
        "/api/captures/{capture_id}"
    )
    def delete_capture(
        capture_id: int,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        path = None

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    SELECT
                        path,
                        status
                    FROM captures
                    WHERE id=%s
                    AND user_id=%s
                    """,
                    (
                        capture_id,
                        user_id
                    )
                )

                row = cur.fetchone()


                if not row:

                    raise HTTPException(
                        status_code=404,
                        detail=
                        "Capture not found"
                    )


                if row[1] in {
                    "queued",
                    "running"
                }:

                    raise HTTPException(
                        status_code=409,
                        detail=
                        "Capture is still running"
                    )


                path = row[0]

                cur.execute(
                    """
                    DELETE FROM captures
                    WHERE id=%s
                    AND user_id=%s
                    """,
                    (
                        capture_id,
                        user_id
                    )
                )


        if path:

            Path(path).unlink(
                missing_ok=True
            )


        return {
            "deleted": True
        }


    @router.get("/api/assets")
    def list_assets(
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    SELECT
                        id,
                        name,
                        address,
                        operating_system,
                        tags,
                        notes,
                        created_at,
                        updated_at
                    FROM assets
                    WHERE user_id=%s
                    ORDER BY
                        updated_at DESC
                    """,
                    (user_id,)
                )

                rows = cur.fetchall()


        return [
            {
                "id": r[0],
                "name": r[1],
                "address": r[2],
                "operating_system":
                    r[3],
                "tags": r[4],
                "notes": r[5],
                "created_at":
                    r[6].isoformat(),
                "updated_at":
                    r[7].isoformat()
            }
            for r in rows
        ]


    @router.get("/api/machines")
    def list_machines(
        user=Depends(current_user)
    ):
        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:
            with conn.cursor() as cur:
                cur.execute(
                    """
                    SELECT
                        id,
                        name,
                        address,
                        operating_system,
                        tags,
                        notes
                    FROM assets
                    WHERE user_id=%s
                    ORDER BY name ASC
                    """,
                    (user_id,)
                )
                rows = cur.fetchall()

        machines = []

        for row in rows:
            address = (row[2] or "").strip()
            host = address

            if "://" in host:
                host = host.split(
                    "://", 1
                )[1]

            host = host.split("/", 1)[0]

            if host.count(":") == 1:
                host = host.split(":", 1)[0]

            status = "unknown"
            response_ms = None

            if host:
                try:
                    started = time.perf_counter()

                    result = subprocess.run(
                        [
                            "ping",
                            "-c", "1",
                            "-W", "1",
                            host
                        ],
                        stdout=subprocess.DEVNULL,
                        stderr=subprocess.DEVNULL,
                        timeout=2
                    )

                    elapsed = (
                        time.perf_counter()
                        - started
                    ) * 1000

                    response_ms = round(
                        elapsed,
                        1
                    )

                    status = (
                        "online"
                        if result.returncode == 0
                        else "offline"
                    )

                except Exception:
                    status = "unknown"

            machines.append(
                {
                    "id": row[0],
                    "name": row[1],
                    "address": address,
                    "operating_system": row[3],
                    "tags": row[4],
                    "notes": row[5],
                    "status": status,
                    "response_ms": response_ms
                }
            )

        return machines


    @router.post("/api/assets")
    def create_asset(
        data: AssetCreate,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        name = (
            data.name
            .strip()[:150]
        )

        address = (
            data.address
            .strip()[:255]
        )


        if not name or not address:

            raise HTTPException(
                status_code=400,
                detail=
                "Name and address required"
            )


        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    INSERT INTO assets
                    (
                        user_id,
                        name,
                        address,
                        operating_system,
                        tags,
                        notes
                    )
                    VALUES
                    (
                        %s,%s,%s,%s,%s,%s
                    )
                    RETURNING id
                    """,
                    (
                        user_id,
                        name,
                        address,
                        data.operating_system[
                            :150
                        ],
                        data.tags[:500],
                        data.notes
                    )
                )

                asset_id = (
                    cur.fetchone()[0]
                )


        return {
            "id": asset_id
        }


    @router.delete(
        "/api/assets/{asset_id}"
    )
    def delete_asset(
        asset_id: int,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    DELETE FROM assets
                    WHERE id=%s
                    AND user_id=%s
                    """,
                    (
                        asset_id,
                        user_id
                    )
                )


        return {
            "deleted": True
        }


    @router.get("/api/search")
    def global_search(
        q: str,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        term = q.strip()

        if len(term) < 2:
            return []

        like = f"%{term}%"

        results = []


        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    SELECT
                        id,
                        title,
                        LEFT(content,400)
                    FROM user_notes
                    WHERE user_id=%s
                    AND
                    (
                        title ILIKE %s
                        OR content ILIKE %s
                    )
                    ORDER BY
                        updated_at DESC
                    LIMIT 20
                    """,
                    (
                        user_id,
                        like,
                        like
                    )
                )

                for row in cur.fetchall():

                    results.append({
                        "type": "note",
                        "title": row[1],
                        "detail": row[2],
                        "url": "/notes"
                    })


                cur.execute(
                    """
                    SELECT
                        id,
                        name,
                        COALESCE(
                            description,
                            ''
                        )
                    FROM labs
                    WHERE user_id=%s
                    AND
                    (
                        name ILIKE %s
                        OR
                        COALESCE(
                            description,
                            ''
                        ) ILIKE %s
                    )
                    ORDER BY id DESC
                    LIMIT 20
                    """,
                    (
                        user_id,
                        like,
                        like
                    )
                )

                for row in cur.fetchall():

                    results.append({
                        "type": "lab",
                        "title": row[1],
                        "detail": row[2],
                        "url":
                            f"/lab?id={row[0]}"
                    })


                cur.execute(
                    """
                    SELECT
                        t.id,
                        t.name,
                        t.address,
                        t.lab_id
                    FROM lab_targets t
                    JOIN labs l
                    ON l.id=t.lab_id
                    WHERE l.user_id=%s
                    AND
                    (
                        t.name ILIKE %s
                        OR t.address ILIKE %s
                        OR
                        COALESCE(
                            t.notes,
                            ''
                        ) ILIKE %s
                    )
                    ORDER BY t.id DESC
                    LIMIT 20
                    """,
                    (
                        user_id,
                        like,
                        like,
                        like
                    )
                )

                for row in cur.fetchall():

                    results.append({
                        "type": "target",
                        "title": row[1],
                        "detail": row[2],
                        "url":
                            f"/lab?id={row[3]}"
                    })


                cur.execute(
                    """
                    SELECT
                        f.id,
                        f.title,
                        f.severity,
                        f.lab_id
                    FROM lab_findings f
                    JOIN labs l
                    ON l.id=f.lab_id
                    WHERE l.user_id=%s
                    AND
                    (
                        f.title ILIKE %s
                        OR
                        COALESCE(
                            f.description,
                            ''
                        ) ILIKE %s
                        OR
                        COALESCE(
                            f.evidence,
                            ''
                        ) ILIKE %s
                    )
                    ORDER BY f.id DESC
                    LIMIT 20
                    """,
                    (
                        user_id,
                        like,
                        like,
                        like
                    )
                )

                for row in cur.fetchall():

                    results.append({
                        "type": "finding",
                        "title": row[1],
                        "detail": row[2],
                        "url":
                            f"/lab?id={row[3]}"
                    })


                cur.execute(
                    """
                    SELECT
                        e.id,
                        e.title,
                        LEFT(
                            e.description,
                            400
                        )
                    FROM knowledge_entries e
                    WHERE
                        e.title ILIKE %s
                        OR
                        e.description ILIKE %s
                        OR
                        COALESCE(
                            e.tags,
                            ''
                        ) ILIKE %s
                    ORDER BY e.id
                    LIMIT 20
                    """,
                    (
                        like,
                        like,
                        like
                    )
                )

                for row in cur.fetchall():

                    results.append({
                        "type": "learn",
                        "title": row[1],
                        "detail": row[2],
                        "url": "/learn"
                    })


        return results[:80]


    @router.post(
        "/api/settings/password"
    )
    def change_password(
        data: PasswordChange,
        user=Depends(current_user)
    ):

        user_id = uid(user)


        if len(
            data.new_password
        ) < 12:

            raise HTTPException(
                status_code=400,
                detail=(
                    "New password must be "
                    "at least 12 characters"
                )
            )


        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    SELECT password_hash
                    FROM users
                    WHERE id=%s
                    """,
                    (user_id,)
                )

                row = cur.fetchone()


                if not row:

                    raise HTTPException(
                        status_code=404,
                        detail="User not found"
                    )


                try:

                    password_hasher.verify(
                        row[0],
                        data.current_password
                    )

                except Exception:

                    raise HTTPException(
                        status_code=400,
                        detail=
                        "Current password is incorrect"
                    )


                new_hash = (
                    password_hasher.hash(
                        data.new_password
                    )
                )


                cur.execute(
                    """
                    UPDATE users
                    SET password_hash=%s
                    WHERE id=%s
                    """,
                    (
                        new_hash,
                        user_id
                    )
                )


        return {
            "changed": True
        }


    @router.get(
        "/api/notifications"
    )
    def notifications(
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    SELECT
                        id,
                        title,
                        body,
                        read_at,
                        created_at
                    FROM notifications
                    WHERE user_id=%s
                    ORDER BY id DESC
                    LIMIT 100
                    """,
                    (user_id,)
                )

                rows = cur.fetchall()


        return [
            {
                "id": r[0],
                "title": r[1],
                "body": r[2],
                "read":
                    bool(r[3]),
                "created_at":
                    r[4].isoformat()
            }
            for r in rows
        ]


    @router.post(
        "/api/notifications/"
        "{notification_id}/read"
    )
    def read_notification(
        notification_id: int,
        data: NotificationRead,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                cur.execute(
                    """
                    UPDATE notifications
                    SET read_at=
                    CASE
                        WHEN %s
                        THEN NOW()
                        ELSE NULL
                    END
                    WHERE id=%s
                    AND user_id=%s
                    """,
                    (
                        data.read,
                        notification_id,
                        user_id
                    )
                )


        return {
            "updated": True
        }


    @router.get(
        "/api/labs/{lab_id}/report.txt"
    )
    def lab_report(
        lab_id: int,
        user=Depends(current_user)
    ):

        user_id = uid(user)

        with psycopg2.connect(
            database_url
        ) as conn:

            with conn.cursor() as cur:

                own_lab(
                    cur,
                    lab_id,
                    user_id
                )

                cur.execute(
                    """
                    SELECT
                        name,
                        COALESCE(
                            description,
                            ''
                        )
                    FROM labs
                    WHERE id=%s
                    """,
                    (lab_id,)
                )

                lab = cur.fetchone()


                cur.execute(
                    """
                    SELECT
                        name,
                        address,
                        COALESCE(
                            notes,
                            ''
                        )
                    FROM lab_targets
                    WHERE lab_id=%s
                    ORDER BY id
                    """,
                    (lab_id,)
                )

                targets = cur.fetchall()


                cur.execute(
                    """
                    SELECT
                        title,
                        severity,
                        COALESCE(
                            description,
                            ''
                        ),
                        COALESCE(
                            evidence,
                            ''
                        ),
                        COALESCE(
                            remediation,
                            ''
                        ),
                        status
                    FROM lab_findings
                    WHERE lab_id=%s
                    ORDER BY id
                    """,
                    (lab_id,)
                )

                findings = cur.fetchall()


                cur.execute(
                    """
                    SELECT
                        content,
                        created_at
                    FROM lab_notes
                    WHERE lab_id=%s
                    ORDER BY id
                    """,
                    (lab_id,)
                )

                notes = cur.fetchall()


                cur.execute(
                    """
                    SELECT
                        scan_type,
                        command,
                        created_at
                    FROM lab_scans
                    WHERE lab_id=%s
                    ORDER BY id
                    """,
                    (lab_id,)
                )

                scans = cur.fetchall()


        lines = [
            "CYBERDECK LAB REPORT",
            "=" * 72,
            f"Lab: {lab[0]}",
            f"Description: {lab[1]}",
            "",
            "TARGETS",
            "-" * 72
        ]


        for item in targets:

            lines.extend([
                f"{item[0]}  {item[1]}",
                item[2],
                ""
            ])


        lines.extend([
            "FINDINGS",
            "-" * 72
        ])


        for item in findings:

            lines.extend([
                (
                    f"[{item[1].upper()}] "
                    f"{item[0]} "
                    f"({item[5]})"
                ),
                item[2],
                "Evidence:",
                item[3],
                "Remediation:",
                item[4],
                ""
            ])


        lines.extend([
            "NOTES",
            "-" * 72
        ])


        for item in notes:

            lines.extend([
                (
                    f"{item[1]}  "
                    f"{item[0]}"
                ),
                ""
            ])


        lines.extend([
            "SCANS",
            "-" * 72
        ])


        for item in scans:

            lines.append(
                (
                    f"{item[2]}  "
                    f"{item[0]}  "
                    f"{item[1]}"
                )
            )


        return PlainTextResponse(
            "\n".join(lines),
            headers={
                "Content-Disposition":
                (
                    "attachment; "
                    f'filename="cyberdeck-'
                    f'lab-{lab_id}.txt"'
                )
            }
        )


    pages = {
        "/system": "system.html",
        "/files": "files.html",
        "/logs": "logs.html",
        "/notes": "notes.html",
        "/jobs": "jobs.html",
        "/captures": "captures.html",
        "/machines": "machines.html",
        "/assets": "assets.html",
        "/search": "search.html",
        "/settings": "settings.html",
        "/notifications":
            "notifications.html",
        "/install":
            "install.html"
    }


    for route_path, filename in (
        pages.items()
    ):

        def page(
            file_name=filename
        ):

            return FileResponse(
                "/opt/cyberdeck/"
                "frontend/"
                + file_name
            )

        router.add_api_route(
            route_path,
            page,
            methods=["GET"],
            include_in_schema=False
        )


    @router.get(
        "/manifest.webmanifest",
        include_in_schema=False
    )
    def manifest():

        return FileResponse(
            "/opt/cyberdeck/frontend/"
            "manifest.webmanifest",
            media_type=
            "application/manifest+json"
        )


    @router.get(
        "/sw.js",
        include_in_schema=False
    )
    def service_worker():

        return FileResponse(
            "/opt/cyberdeck/"
            "frontend/sw.js",
            media_type=
            "application/javascript"
        )


    app.include_router(router)


    static_dir = (
        "/opt/cyberdeck/"
        "frontend/static"
    )

    if os.path.isdir(static_dir):

        app.mount(
            "/static",
            StaticFiles(
                directory=static_dir
            ),
            name="cyberdeck-static"
        )
