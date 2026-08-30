from __future__ import annotations

import math
import os
import threading
import time
from dataclasses import dataclass

from fastapi import HTTPException


@dataclass
class Bucket:
    tokens: float
    updated: float


class RateLimitGuard:

    def __init__(self, limiter, user_id):
        self.limiter = limiter
        self.user_id = user_id
        self.released = False

    def release(self):
        if not self.released:
            self.released = True
            self.limiter.release(self.user_id)


class AdvancedToolRateLimiter:

    ACTION_COSTS = {
        "ping": 1,
        "dns": 1,
        "reverse": 1,
        "whois": 2,
        "trace": 3,
        "traceroute": 3,
        "http": 2,
        "https": 2,
        "tls": 2,
        "ssh": 2,
        "rdp": 2,
        "smb": 3,
        "snmp": 3,
        "nmap": 6,
        "nmap_quick": 4,
        "nmap_services": 8,
        "nikto": 10,
        "gobuster": 10,
    }

    def __init__(self):

        self.user_capacity = float(
            os.getenv(
                "CYBERDECK_RATE_USER_CAPACITY",
                "120"
            )
        )

        self.user_refill = float(
            os.getenv(
                "CYBERDECK_RATE_USER_REFILL",
                "2"
            )
        )

        self.ip_capacity = float(
            os.getenv(
                "CYBERDECK_RATE_IP_CAPACITY",
                "300"
            )
        )

        self.ip_refill = float(
            os.getenv(
                "CYBERDECK_RATE_IP_REFILL",
                "5"
            )
        )

        self.target_capacity = float(
            os.getenv(
                "CYBERDECK_RATE_TARGET_CAPACITY",
                "40"
            )
        )

        self.target_refill = float(
            os.getenv(
                "CYBERDECK_RATE_TARGET_REFILL",
                "0.75"
            )
        )

        self.max_concurrent = int(
            os.getenv(
                "CYBERDECK_RATE_MAX_CONCURRENT",
                "4"
            )
        )

        self.state_ttl = float(
            os.getenv(
                "CYBERDECK_RATE_STATE_TTL",
                "900"
            )
        )

        self.lock = threading.RLock()

        self.user_buckets = {}
        self.ip_buckets = {}
        self.target_buckets = {}

        self.active = {}
        self.violations = {}
        self.blocked_until = {}

        self.last_cleanup = 0.0

    def _bucket(
        self,
        store,
        key,
        capacity,
        refill,
        now
    ):

        bucket = store.get(key)

        if bucket is None:
            bucket = Bucket(
                tokens=capacity,
                updated=now
            )
            store[key] = bucket
            return bucket

        elapsed = max(
            0.0,
            now - bucket.updated
        )

        bucket.tokens = min(
            capacity,
            bucket.tokens + elapsed * refill
        )

        bucket.updated = now

        return bucket

    def _retry_after(
        self,
        bucket,
        cost,
        refill
    ):

        if refill <= 0:
            return 60

        missing = max(
            0.0,
            cost - bucket.tokens
        )

        return max(
            1,
            math.ceil(
                missing / refill
            )
        )

    def _violation(
        self,
        user_id,
        now,
        retry
    ):

        history = self.violations.setdefault(
            user_id,
            []
        )

        cutoff = now - 60

        history[:] = [
            x for x in history
            if x >= cutoff
        ]

        history.append(now)

        count = len(history)

        penalty = 0

        if count >= 8:
            penalty = 120
        elif count >= 5:
            penalty = 30
        elif count >= 3:
            penalty = 10

        if penalty:
            self.blocked_until[user_id] = max(
                self.blocked_until.get(
                    user_id,
                    0
                ),
                now + penalty
            )

        return max(
            retry,
            penalty
        )

    def _deny(
        self,
        user_id,
        now,
        retry,
        detail
    ):

        retry = self._violation(
            user_id,
            now,
            retry
        )

        raise HTTPException(
            status_code=429,
            detail=detail,
            headers={
                "Retry-After": str(
                    max(1, int(retry))
                )
            }
        )

    def _cleanup(self, now):

        if now - self.last_cleanup < 300:
            return

        self.last_cleanup = now
        cutoff = now - self.state_ttl

        for store in (
            self.user_buckets,
            self.ip_buckets,
            self.target_buckets
        ):

            stale = [
                key
                for key, bucket
                in store.items()
                if bucket.updated < cutoff
            ]

            for key in stale:
                store.pop(
                    key,
                    None
                )

        self.violations = {
            user: [
                stamp
                for stamp in stamps
                if stamp >= now - 60
            ]
            for user, stamps
            in self.violations.items()
            if stamps
        }

        self.blocked_until = {
            user: until
            for user, until
            in self.blocked_until.items()
            if until > now
        }

    def acquire(
        self,
        user_id,
        client_ip,
        action,
        target
    ):

        user_id = str(user_id)
        client_ip = str(
            client_ip or "unknown"
        )

        action = str(
            action or ""
        ).lower()

        target = str(
            target or ""
        ).lower()

        cost = float(
            self.ACTION_COSTS.get(
                action,
                5
            )
        )

        now = time.monotonic()

        with self.lock:

            self._cleanup(now)

            blocked = self.blocked_until.get(
                user_id,
                0
            )

            if blocked > now:

                retry = math.ceil(
                    blocked - now
                )

                raise HTTPException(
                    status_code=429,
                    detail="Temporary tool cooldown",
                    headers={
                        "Retry-After": str(
                            retry
                        )
                    }
                )

            active = self.active.get(
                user_id,
                0
            )

            if active >= self.max_concurrent:

                self._deny(
                    user_id,
                    now,
                    2,
                    "Too many concurrent tool jobs"
                )

            user_bucket = self._bucket(
                self.user_buckets,
                user_id,
                self.user_capacity,
                self.user_refill,
                now
            )

            ip_bucket = self._bucket(
                self.ip_buckets,
                client_ip,
                self.ip_capacity,
                self.ip_refill,
                now
            )

            target_key = (
                user_id,
                target
            )

            target_bucket = self._bucket(
                self.target_buckets,
                target_key,
                self.target_capacity,
                self.target_refill,
                now
            )

            waits = []

            if user_bucket.tokens < cost:
                waits.append(
                    self._retry_after(
                        user_bucket,
                        cost,
                        self.user_refill
                    )
                )

            if ip_bucket.tokens < cost:
                waits.append(
                    self._retry_after(
                        ip_bucket,
                        cost,
                        self.ip_refill
                    )
                )

            if target_bucket.tokens < cost:
                waits.append(
                    self._retry_after(
                        target_bucket,
                        cost,
                        self.target_refill
                    )
                )

            if waits:

                self._deny(
                    user_id,
                    now,
                    max(waits),
                    "Tool rate limit exceeded"
                )

            user_bucket.tokens -= cost
            ip_bucket.tokens -= cost
            target_bucket.tokens -= cost

            self.active[user_id] = (
                active + 1
            )

        return RateLimitGuard(
            self,
            user_id
        )

    def release(
        self,
        user_id
    ):

        user_id = str(user_id)

        with self.lock:

            count = self.active.get(
                user_id,
                0
            )

            if count <= 1:
                self.active.pop(
                    user_id,
                    None
                )
            else:
                self.active[user_id] = (
                    count - 1
                )


advanced_tool_limiter = (
    AdvancedToolRateLimiter()
)
