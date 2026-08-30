import json
import subprocess
from urllib.parse import urlparse

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel


def install_browser(app, current_user):

    router = APIRouter()


    class BrowserRenderRequest(BaseModel):
        url: str


    def user_id(user):
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


    def clean_url(value):
        value = value.strip()

        if (
            not value
            or len(value) > 2048
        ):
            raise HTTPException(
                status_code=400,
                detail="Invalid URL"
            )

        try:
            parsed = urlparse(value)
        except Exception:
            raise HTTPException(
                status_code=400,
                detail="Invalid URL"
            )

        if parsed.scheme not in {
            "http",
            "https"
        }:
            raise HTTPException(
                status_code=400,
                detail="Only HTTP and HTTPS are allowed"
            )

        if not parsed.hostname:
            raise HTTPException(
                status_code=400,
                detail="Hostname required"
            )

        if parsed.username or parsed.password:
            raise HTTPException(
                status_code=400,
                detail="Credentials in URLs are not allowed"
            )

        return value


    @router.post("/api/browser/render")
    def render_page(
        data: BrowserRenderRequest,
        user=Depends(current_user)
    ):

        uid = user_id(user)
        url = clean_url(data.url)

        try:
            result = subprocess.run(
                [
                    "sudo",
                    "-n",
                    "/usr/local/sbin/"
                    "cyberdeck-browser-runner",
                    str(uid),
                    url
                ],
                capture_output=True,
                text=True,
                timeout=45
            )

        except subprocess.TimeoutExpired:
            raise HTTPException(
                status_code=504,
                detail="Browser request timed out"
            )

        output = (
            result.stdout.strip()
            or result.stderr.strip()
        )

        if result.returncode != 0:
            raise HTTPException(
                status_code=502,
                detail=(
                    output[-2000:]
                    or "Browser render failed"
                )
            )

        try:
            return json.loads(output)

        except json.JSONDecodeError:
            raise HTTPException(
                status_code=502,
                detail="Invalid browser response"
            )


    app.include_router(router)
