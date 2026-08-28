import os
import subprocess
import time
from pathlib import Path

import psycopg2


DATABASE_URL = os.environ[
    "DATABASE_URL"
]


ALLOWED = {
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
    "tls",
    "pcap_capture"
}


def notify(
    cur,
    user_id,
    title,
    body
):

    cur.execute(
        """
        INSERT INTO notifications
        (
            user_id,
            title,
            body
        )
        VALUES
        (
            %s,%s,%s
        )
        """,
        (
            user_id,
            title[:180],
            body[:1000]
        )
    )


def claim_job():

    with psycopg2.connect(
        DATABASE_URL
    ) as conn:

        with conn.cursor() as cur:

            cur.execute(
                """
                SELECT
                    id,
                    user_id,
                    lab_id,
                    target_id,
                    action,
                    target
                FROM scan_jobs
                WHERE status='queued'
                ORDER BY id
                FOR UPDATE SKIP LOCKED
                LIMIT 1
                """
            )

            row = cur.fetchone()

            if not row:
                return None

            cur.execute(
                """
                UPDATE scan_jobs
                SET
                    status='running',
                    started_at=NOW()
                WHERE id=%s
                """,
                (row[0],)
            )

            if (
                row[4]
                == "pcap_capture"
            ):

                cur.execute(
                    """
                    UPDATE captures
                    SET status='running'
                    WHERE job_id=%s
                    """,
                    (row[0],)
                )

            return row


def finish_job(
    job,
    status,
    output,
    return_code,
    duration_ms
):

    (
        job_id,
        user_id,
        lab_id,
        target_id,
        action,
        target
    ) = job

    output = (
        output or ""
    )[:500000]


    with psycopg2.connect(
        DATABASE_URL
    ) as conn:

        with conn.cursor() as cur:

            cur.execute(
                """
                UPDATE scan_jobs
                SET
                    status=%s,
                    output=%s,
                    return_code=%s,
                    finished_at=NOW()
                WHERE id=%s
                """,
                (
                    status,
                    output,
                    return_code,
                    job_id
                )
            )


            if (
                action
                != "pcap_capture"
            ):

                cur.execute(
                    """
                    INSERT INTO tool_runs
                    (
                        user_id,
                        action,
                        target,
                        output,
                        return_code,
                        duration_ms
                    )
                    VALUES
                    (
                        %s,%s,%s,%s,%s,%s
                    )
                    """,
                    (
                        user_id,
                        action,
                        target,
                        output,
                        return_code,
                        duration_ms
                    )
                )


                if lab_id is not None:

                    cur.execute(
                        """
                        INSERT INTO lab_scans
                        (
                            lab_id,
                            target_id,
                            scan_type,
                            command,
                            output
                        )
                        VALUES
                        (
                            %s,%s,%s,%s,%s
                        )
                        """,
                        (
                            lab_id,
                            target_id,
                            action,
                            (
                                f"{action} "
                                f"{target}"
                            ),
                            output
                        )
                    )


            notify(
                cur,
                user_id,
                (
                    "job completed"
                    if status
                    == "completed"
                    else
                    "job failed"
                ),
                (
                    f"{action} "
                    f"{target} -> "
                    f"{status}"
                )
            )


def run_capture(job):

    (
        job_id,
        user_id,
        lab_id,
        target_id,
        action,
        target
    ) = job


    with psycopg2.connect(
        DATABASE_URL
    ) as conn:

        with conn.cursor() as cur:

            cur.execute(
                """
                SELECT id
                FROM captures
                WHERE job_id=%s
                AND user_id=%s
                """,
                (
                    job_id,
                    user_id
                )
            )

            row = cur.fetchone()

            if not row:

                raise RuntimeError(
                    "capture record not found"
                )

            capture_id = row[0]


    started = time.time()


    result = subprocess.run(
        [
            "sudo",
            "/usr/local/sbin/"
            "cyberdeck-pcap-runner",
            str(capture_id),
            target
        ],
        capture_output=True,
        text=True,
        timeout=300
    )


    duration_ms = int(
        (
            time.time()
            - started
        ) * 1000
    )


    output = (
        result.stdout.strip()
        or result.stderr.strip()
        or "capture complete"
    )


    path = Path(
        "/opt/cyberdeck/"
        "captures/"
        f"capture-{capture_id}.pcap"
    )


    with psycopg2.connect(
        DATABASE_URL
    ) as conn:

        with conn.cursor() as cur:

            if (
                result.returncode == 0
                and path.exists()
            ):

                cur.execute(
                    """
                    UPDATE captures
                    SET
                        status='completed',
                        path=%s,
                        size_bytes=%s,
                        finished_at=NOW(),
                        error=NULL
                    WHERE id=%s
                    """,
                    (
                        str(path),
                        path.stat().st_size,
                        capture_id
                    )
                )

                status = "completed"

            else:

                cur.execute(
                    """
                    UPDATE captures
                    SET
                        status='failed',
                        finished_at=NOW(),
                        error=%s
                    WHERE id=%s
                    """,
                    (
                        output[:2000],
                        capture_id
                    )
                )

                status = "failed"


    finish_job(
        job,
        status,
        output,
        result.returncode,
        duration_ms
    )


def run_job(job):

    (
        job_id,
        user_id,
        lab_id,
        target_id,
        action,
        target
    ) = job


    if action not in ALLOWED:

        finish_job(
            job,
            "failed",
            "unsupported action",
            2,
            0
        )

        return


    if action == "pcap_capture":

        run_capture(job)

        return


    started = time.time()


    try:

        result = subprocess.run(
            [
                "sudo",
                "/usr/local/sbin/"
                "cyberdeck-tool-runner",
                action,
                target
            ],
            capture_output=True,
            text=True,
            timeout=900
        )


        duration_ms = int(
            (
                time.time()
                - started
            ) * 1000
        )


        output = (
            result.stdout.strip()
            or result.stderr.strip()
            or "no output"
        )


        status = (
            "completed"
            if result.returncode == 0
            else "failed"
        )


        finish_job(
            job,
            status,
            output,
            result.returncode,
            duration_ms
        )


    except subprocess.TimeoutExpired:

        finish_job(
            job,
            "failed",
            "job timed out",
            124,
            int(
                (
                    time.time()
                    - started
                ) * 1000
            )
        )


    except Exception as exc:

        finish_job(
            job,
            "failed",
            str(exc),
            1,
            int(
                (
                    time.time()
                    - started
                ) * 1000
            )
        )


def main():

    while True:

        try:

            job = claim_job()

            if job:

                run_job(job)

            else:

                time.sleep(2)

        except Exception:

            time.sleep(5)


if __name__ == "__main__":

    main()
