from fastapi import (
    APIRouter,
    Depends,
    File,
    Form,
    HTTPException,
    UploadFile,
)
from fastapi.responses import FileResponse
from pydantic import BaseModel

from pathlib import Path

import json
import os
import re
import secrets
import subprocess


class VpnConnect(BaseModel):
    profile_id: str
    kill_switch: bool = True


def install_vpn(app, current_user):

    router = APIRouter()

    vpn_root = Path(
        os.environ.get(
            "CYBERDECK_VPN_DIR",
            "/opt/cyberdeck/vpn",
        )
    )

    profiles_root = vpn_root / "profiles"

    profiles_root.mkdir(
        parents=True,
        exist_ok=True,
    )


    def uid(user):

        value = (
            user.get("sub")
            or user.get("id")
        )

        if value is None:
            raise HTTPException(
                status_code=401,
                detail="Invalid user",
            )

        return int(value)


    def directory(user_id):

        path = (
            profiles_root
            / str(user_id)
        )

        path.mkdir(
            parents=True,
            exist_ok=True,
        )

        try:
            os.chmod(path, 0o700)
        except Exception:
            pass

        return path


    def index_path(user_id):

        return (
            directory(user_id)
            / "profiles.json"
        )


    def load_profiles(user_id):

        path = index_path(user_id)

        if not path.exists():
            return []

        try:

            data = json.loads(
                path.read_text(
                    encoding="utf-8"
                )
            )

            if isinstance(data, list):
                return data

        except Exception:
            pass

        return []


    def save_profiles(
        user_id,
        profiles,
    ):

        path = index_path(user_id)

        temp = path.with_suffix(
            ".tmp"
        )

        temp.write_text(
            json.dumps(
                profiles,
                indent=2,
            ),
            encoding="utf-8",
        )

        os.chmod(
            temp,
            0o600,
        )

        temp.replace(path)


    def find_profile(
        user_id,
        profile_id,
    ):

        if not re.fullmatch(
            r"[a-f0-9]{10}",
            profile_id,
        ):
            raise HTTPException(
                status_code=400,
                detail="Invalid VPN profile",
            )

        profiles = load_profiles(
            user_id
        )

        for profile in profiles:

            if (
                profile.get("id")
                == profile_id
            ):
                return profile

        raise HTTPException(
            status_code=404,
            detail="VPN profile not found",
        )


    def run_runner(
        *args,
        timeout=75,
    ):

        command = [
            "sudo",
            "-n",
            "/usr/local/sbin/cyberdeck-vpn-runner",
            *[
                str(value)
                for value in args
            ],
        ]

        try:

            result = subprocess.run(
                command,
                capture_output=True,
                text=True,
                timeout=timeout,
            )

        except subprocess.TimeoutExpired:

            raise HTTPException(
                status_code=504,
                detail="VPN operation timed out",
            )


        if result.returncode != 0:

            message = (
                result.stderr.strip()
                or result.stdout.strip()
                or "VPN operation failed"
            )

            raise HTTPException(
                status_code=500,
                detail=message[-1500:],
            )


        try:

            return json.loads(
                result.stdout.strip()
                or "{}"
            )

        except Exception:

            raise HTTPException(
                status_code=500,
                detail="Invalid VPN runner response",
            )


    def validate_wireguard(
        content,
    ):

        lowered = content.lower()

        if (
            "[interface]"
            not in lowered
            or "[peer]"
            not in lowered
        ):

            raise HTTPException(
                status_code=400,
                detail="Invalid WireGuard configuration",
            )


        dangerous = re.compile(
            r"(?im)^\s*"
            r"(preup|postup|predown|postdown|saveconfig)"
            r"\s*="
        )

        if dangerous.search(content):

            raise HTTPException(
                status_code=400,
                detail=(
                    "WireGuard scripts and SaveConfig "
                    "are not accepted"
                ),
            )


        if not re.search(
            r"(?im)^\s*endpoint\s*=",
            content,
        ):

            raise HTTPException(
                status_code=400,
                detail="WireGuard Endpoint required",
            )


    def validate_openvpn(
        content,
    ):

        dangerous = re.compile(
            r"(?im)^\s*("
            r"script-security|"
            r"up|"
            r"down|"
            r"route-up|"
            r"route-pre-down|"
            r"ipchange|"
            r"learn-address|"
            r"client-connect|"
            r"client-disconnect|"
            r"plugin|"
            r"management|"
            r"auth-user-pass|"
            r"auth-user-pass-verify|"
            r"askpass"
            r")(\s|$)"
        )

        if dangerous.search(content):

            raise HTTPException(
                status_code=400,
                detail=(
                    "This OpenVPN profile requires "
                    "unsupported scripts or credentials"
                ),
            )


        external_files = re.compile(
            r"(?im)^\s*("
            r"ca|"
            r"cert|"
            r"key|"
            r"pkcs12|"
            r"tls-auth|"
            r"tls-crypt|"
            r"crl-verify|"
            r"dh|"
            r"secret"
            r")\s+\S+"
        )

        if external_files.search(
            content
        ):

            raise HTTPException(
                status_code=400,
                detail=(
                    "OpenVPN certificates and keys "
                    "must be embedded in the profile"
                ),
            )


        if not re.search(
            r"(?im)^\s*remote\s+\S+",
            content,
        ):

            raise HTTPException(
                status_code=400,
                detail="OpenVPN remote server required",
            )


    @router.get(
        "/api/vpn/preflight"
    )
    def vpn_preflight(
        user=Depends(current_user),
    ):

        return run_runner(
            "preflight"
        )


    @router.get(
        "/api/vpn/profiles"
    )
    def vpn_profiles(
        user=Depends(current_user),
    ):

        return load_profiles(
            uid(user)
        )


    @router.post(
        "/api/vpn/profiles"
    )
    async def upload_profile(
        provider: str = Form("custom"),
        country: str = Form(""),
        city: str = Form(""),
        label: str = Form(""),
        protocol: str = Form(...),
        upload: UploadFile = File(...),
        user=Depends(current_user),
    ):

        user_id = uid(user)

        protocol = (
            protocol
            .strip()
            .lower()
        )

        if protocol not in {
            "wireguard",
            "openvpn",
        }:

            raise HTTPException(
                status_code=400,
                detail="Unsupported VPN protocol",
            )


        raw = await upload.read(
            131073
        )

        if len(raw) > 131072:

            raise HTTPException(
                status_code=413,
                detail="VPN profile exceeds 128 KB",
            )


        try:

            content = raw.decode(
                "utf-8"
            )

        except UnicodeDecodeError:

            raise HTTPException(
                status_code=400,
                detail="VPN profile must be UTF-8 text",
            )


        if protocol == "wireguard":

            validate_wireguard(
                content
            )

        else:

            validate_openvpn(
                content
            )


        profile_id = (
            secrets.token_hex(5)
        )

        profile_path = (
            directory(user_id)
            / f"{profile_id}.conf"
        )

        profile_path.write_text(
            content,
            encoding="utf-8",
        )

        os.chmod(
            profile_path,
            0o600,
        )


        profile = {
            "id": profile_id,
            "provider":
                provider.strip()[:80]
                or "custom",
            "country":
                country.strip()[:80],
            "city":
                city.strip()[:80],
            "label":
                label.strip()[:100]
                or (
                    Path(
                        upload.filename
                        or "vpn"
                    ).name[:100]
                ),
            "protocol": protocol,
        }


        profiles = load_profiles(
            user_id
        )

        profiles.append(
            profile
        )

        save_profiles(
            user_id,
            profiles,
        )

        return profile


    @router.delete(
        "/api/vpn/profiles/{profile_id}"
    )
    def delete_profile(
        profile_id: str,
        user=Depends(current_user),
    ):

        user_id = uid(user)

        find_profile(
            user_id,
            profile_id,
        )


        try:

            status = run_runner(
                "status",
                user_id,
            )

            if (
                status.get(
                    "profile_id"
                )
                == profile_id
            ):

                run_runner(
                    "disconnect",
                    user_id,
                )

        except HTTPException:
            pass


        path = (
            directory(user_id)
            / f"{profile_id}.conf"
        )

        path.unlink(
            missing_ok=True
        )


        profiles = [
            item
            for item
            in load_profiles(user_id)
            if item.get("id")
            != profile_id
        ]

        save_profiles(
            user_id,
            profiles,
        )

        return {
            "deleted": True
        }


    @router.post(
        "/api/vpn/connect"
    )
    def vpn_connect(
        data: VpnConnect,
        user=Depends(current_user),
    ):

        user_id = uid(user)

        profile = find_profile(
            user_id,
            data.profile_id,
        )

        run_runner(
            "connect",
            user_id,
            profile["id"],
            profile["protocol"],
            "1"
            if data.kill_switch
            else "0",
            timeout=90,
        )

        result = run_runner(
            "status",
            user_id,
        )

        result["profile"] = profile

        return result


    @router.post(
        "/api/vpn/disconnect"
    )
    def vpn_disconnect(
        user=Depends(current_user),
    ):

        return run_runner(
            "disconnect",
            uid(user),
        )


    @router.get(
        "/api/vpn/status"
    )
    def vpn_status(
        user=Depends(current_user),
    ):

        user_id = uid(user)

        result = run_runner(
            "status",
            user_id,
        )

        profile_id = result.get(
            "profile_id"
        )

        if profile_id:

            try:

                result["profile"] = (
                    find_profile(
                        user_id,
                        profile_id,
                    )
                )

            except HTTPException:
                pass

        return result


    @router.get(
        "/vpn",
        include_in_schema=False,
    )
    def vpn_page():

        return FileResponse(
            "/opt/cyberdeck/frontend/vpn.html"
        )


    app.include_router(
        router
    )
