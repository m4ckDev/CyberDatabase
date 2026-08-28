from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import FileResponse, PlainTextResponse
from pydantic import BaseModel

import base64
import datetime
import hashlib
import ipaddress
import json
import os
import re
import secrets
import subprocess
import time
import urllib.parse
import urllib.request

import psycopg2


def install_toolbox(app, current_user, database_url):

    router = APIRouter()

    def get_uid(user):
        value = user.get("sub") or user.get("id")

        if value is None:
            raise HTTPException(
                status_code=401,
                detail="Invalid user"
            )

        return int(value)

    def admin_only(user):
        if not user.get("is_admin"):
            raise HTTPException(
                status_code=403,
                detail="Admin required"
            )

    def log_run(uid, action, target, output, return_code, duration_ms):
        output = output[:200000]

        with psycopg2.connect(database_url) as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    INSERT INTO tool_runs
                    (
                        user_id,
                        action,
                        target,
                        output,
                        return_code,
                        duration_ms
                    )
                    VALUES (%s,%s,%s,%s,%s,%s)
                """, (
                    uid,
                    action,
                    target,
                    output,
                    return_code,
                    duration_ms
                ))

    class ToolRequest(BaseModel):
        action: str
        target: str = ""

    class UtilityRequest(BaseModel):
        action: str
        text: str = ""

    class TerminalRequest(BaseModel):
        command: str

    class CVERequest(BaseModel):
        query: str

    @router.post("/api/toolbox/run")
    def run_tool(data: ToolRequest, user=Depends(current_user)):

        uid = get_uid(user)

        action = data.action.strip()
        target = data.target.strip()

        if not re.fullmatch(r"[a-z0-9_]{1,80}", action):
            raise HTTPException(
                status_code=400,
                detail="Invalid action"
            )

        command = [
            "sudo",
            "/usr/local/sbin/cyberdeck-tool-runner",
            action
        ]

        if target:
            command.append(target)

        start = time.time()

        try:
            result = subprocess.run(
                command,
                capture_output=True,
                text=True,
                timeout=270
            )

        except subprocess.TimeoutExpired:
            raise HTTPException(
                status_code=408,
                detail="Command timed out"
            )

        duration = int(
            (time.time() - start) * 1000
        )

        output = (
            result.stdout.strip()
            or result.stderr.strip()
            or "no output"
        )

        log_run(
            uid,
            action,
            target,
            output,
            result.returncode,
            duration
        )

        return {
            "output": output,
            "return_code": result.returncode,
            "duration_ms": duration
        }

    @router.get("/api/toolbox/history")
    def history(user=Depends(current_user)):

        uid = get_uid(user)

        with psycopg2.connect(database_url) as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT
                        id,
                        action,
                        target,
                        return_code,
                        duration_ms,
                        created_at
                    FROM tool_runs
                    WHERE user_id=%s
                    ORDER BY created_at DESC
                    LIMIT 30
                """, (uid,))

                rows = cur.fetchall()

        return [
            {
                "id": r[0],
                "action": r[1],
                "target": r[2],
                "return_code": r[3],
                "duration_ms": r[4],
                "created_at": r[5].isoformat()
            }
            for r in rows
        ]

    @router.get("/api/toolbox/history/{run_id}")
    def history_item(run_id: int, user=Depends(current_user)):

        uid = get_uid(user)

        with psycopg2.connect(database_url) as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT
                        action,
                        target,
                        output,
                        return_code,
                        duration_ms,
                        created_at
                    FROM tool_runs
                    WHERE id=%s AND user_id=%s
                """, (run_id, uid))

                row = cur.fetchone()

        if not row:
            raise HTTPException(
                status_code=404,
                detail="Run not found"
            )

        return {
            "action": row[0],
            "target": row[1],
            "output": row[2],
            "return_code": row[3],
            "duration_ms": row[4],
            "created_at": row[5].isoformat()
        }

    @router.get("/api/toolbox/favorites")
    def favorites(user=Depends(current_user)):

        uid = get_uid(user)

        with psycopg2.connect(database_url) as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT action
                    FROM tool_favorites
                    WHERE user_id=%s
                    ORDER BY created_at
                """, (uid,))

                rows = cur.fetchall()

        return [r[0] for r in rows]

    @router.post("/api/toolbox/favorites/{action}")
    def add_favorite(action: str, user=Depends(current_user)):

        uid = get_uid(user)

        if not re.fullmatch(r"[a-z0-9_]{1,80}", action):
            raise HTTPException(
                status_code=400,
                detail="Invalid action"
            )

        with psycopg2.connect(database_url) as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    INSERT INTO tool_favorites
                        (user_id, action)
                    VALUES
                        (%s, %s)
                    ON CONFLICT DO NOTHING
                """, (uid, action))

        return {"saved": True}

    @router.delete("/api/toolbox/favorites/{action}")
    def delete_favorite(action: str, user=Depends(current_user)):

        uid = get_uid(user)

        with psycopg2.connect(database_url) as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    DELETE FROM tool_favorites
                    WHERE user_id=%s
                    AND action=%s
                """, (uid, action))

        return {"deleted": True}

    @router.post("/api/toolbox/utility")
    def utility(data: UtilityRequest, user=Depends(current_user)):

        action = data.action
        text = data.text

        try:

            if action == "sha256":
                output = hashlib.sha256(
                    text.encode()
                ).hexdigest()

            elif action == "sha512":
                output = hashlib.sha512(
                    text.encode()
                ).hexdigest()

            elif action == "md5":
                output = hashlib.md5(
                    text.encode()
                ).hexdigest()

            elif action == "base64_encode":
                output = base64.b64encode(
                    text.encode()
                ).decode()

            elif action == "base64_decode":
                output = base64.b64decode(
                    text,
                    validate=True
                ).decode(errors="replace")

            elif action == "url_encode":
                output = urllib.parse.quote(text)

            elif action == "url_decode":
                output = urllib.parse.unquote(text)

            elif action == "hex_encode":
                output = text.encode().hex()

            elif action == "hex_decode":
                output = bytes.fromhex(
                    text
                ).decode(errors="replace")

            elif action == "password":
                try:
                    length = int(text)
                except Exception:
                    length = 24

                length = max(12, min(length, 128))

                alphabet = (
                    "abcdefghijklmnopqrstuvwxyz"
                    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                    "0123456789"
                    "!@#$%^&*_-+="
                )

                output = "".join(
                    secrets.choice(alphabet)
                    for _ in range(length)
                )

            elif action == "cidr":
                network = ipaddress.ip_network(
                    text.strip(),
                    strict=False
                )

                output = "\n".join([
                    f"network: {network.network_address}",
                    f"netmask: {network.netmask}",
                    f"broadcast: {network.broadcast_address}",
                    f"addresses: {network.num_addresses}",
                    f"prefix: /{network.prefixlen}",
                ])

            elif action == "timestamp":
                stamp = float(text.strip())

                output = datetime.datetime.fromtimestamp(
                    stamp,
                    tz=datetime.timezone.utc
                ).isoformat()

            elif action == "jwt":

                parts = text.split(".")

                if len(parts) < 2:
                    raise ValueError("Invalid JWT")

                def decode_part(value):
                    value += "=" * (
                        (4 - len(value) % 4) % 4
                    )

                    decoded = base64.urlsafe_b64decode(
                        value
                    )

                    return json.loads(decoded)

                output = json.dumps({
                    "header": decode_part(parts[0]),
                    "payload": decode_part(parts[1])
                }, indent=2)

            else:
                raise HTTPException(
                    status_code=400,
                    detail="Unknown utility"
                )

        except HTTPException:
            raise

        except Exception as exc:
            raise HTTPException(
                status_code=400,
                detail=str(exc)
            )

        return {"output": output}

    @router.post("/api/toolbox/cve")
    def cve_lookup(data: CVERequest, user=Depends(current_user)):

        query = data.query.strip()

        if not query:
            raise HTTPException(
                status_code=400,
                detail="Enter product, version, or CVE"
            )

        url = (
            "https://services.nvd.nist.gov/rest/json/cves/2.0"
            "?resultsPerPage=10&keywordSearch="
            + urllib.parse.quote(query)
        )

        request = urllib.request.Request(
            url,
            headers={
                "User-Agent": "CyberDeck/1.0"
            }
        )

        try:
            with urllib.request.urlopen(
                request,
                timeout=15
            ) as response:
                payload = json.loads(
                    response.read()
                )

        except Exception as exc:
            raise HTTPException(
                status_code=502,
                detail=f"CVE lookup failed: {exc}"
            )

        results = []

        for item in payload.get(
            "vulnerabilities",
            []
        ):

            cve = item.get("cve", {})

            descriptions = cve.get(
                "descriptions",
                []
            )

            description = ""

            for entry in descriptions:
                if entry.get("lang") == "en":
                    description = entry.get(
                        "value",
                        ""
                    )
                    break

            references = [
                ref.get("url")
                for ref in cve.get(
                    "references",
                    []
                )[:5]
                if ref.get("url")
            ]

            results.append({
                "id": cve.get("id"),
                "description": description,
                "references": references
            })

        return {"results": results}

    @router.post("/api/terminal/run")
    def terminal(data: TerminalRequest, user=Depends(current_user)):

        admin_only(user)

        command = data.command.strip()

        if not command:
            return {"output": ""}

        if len(command) > 4000:
            raise HTTPException(
                status_code=400,
                detail="Command too long"
            )

        try:
            result = subprocess.run(
                [
                    "sudo",
                    "/usr/local/sbin/cyberdeck-shell-runner",
                    command
                ],
                capture_output=True,
                text=True,
                timeout=60
            )

        except subprocess.TimeoutExpired:
            raise HTTPException(
                status_code=408,
                detail="Command timed out"
            )

        output = (
            result.stdout.rstrip()
            or result.stderr.rstrip()
        )

        return {
            "output": output,
            "return_code": result.returncode
        }

    @router.get("/api/toolbox/export")
    def export_history(user=Depends(current_user)):

        uid = get_uid(user)

        with psycopg2.connect(database_url) as conn:
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT
                        action,
                        target,
                        output,
                        return_code,
                        duration_ms,
                        created_at
                    FROM tool_runs
                    WHERE user_id=%s
                    ORDER BY created_at DESC
                    LIMIT 200
                """, (uid,))

                rows = cur.fetchall()

        sections = []

        for row in rows:
            sections.append(
                "\n".join([
                    "=" * 70,
                    f"time: {row[5]}",
                    f"action: {row[0]}",
                    f"target: {row[1] or '-'}",
                    f"return code: {row[3]}",
                    f"duration: {row[4]} ms",
                    "",
                    row[2] or ""
                ])
            )

        return PlainTextResponse(
            "\n\n".join(sections),
            headers={
                "Content-Disposition":
                'attachment; filename="cyberdeck-tool-history.txt"'
            }
        )

    @router.get("/terminal", include_in_schema=False)
    def terminal_page():
        return FileResponse(
            "/opt/cyberdeck/frontend/terminal.html"
        )

    app.include_router(router)
