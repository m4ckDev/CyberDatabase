import base64
import json
import sys
import urllib.request

from playwright.sync_api import sync_playwright


def main():

    if len(sys.argv) != 2:
        raise SystemExit("URL required")

    url = sys.argv[1]

    with sync_playwright() as p:

        browser = p.chromium.launch(
            executable_path="/bin/chromium",
            headless=True,
            args=["--no-sandbox"],
        )

        page = browser.new_page(
            viewport={
                "width": 1440,
                "height": 900,
            }
        )

        navigation = []

        def capture_response(item):
            try:
                if (
                    item.request.is_navigation_request()
                    and item.frame == page.main_frame
                ):
                    navigation.append({
                        "url": item.url,
                        "status": item.status,
                    })
            except Exception:
                pass

        page.on(
            "response",
            capture_response
        )

        response = page.goto(
            url,
            wait_until="domcontentloaded",
            timeout=30000,
        )

        page.wait_for_timeout(750)

        try:
            with urllib.request.urlopen(
                "https://api.ipify.org",
                timeout=5
            ) as ip_response:
                exit_ip = (
                    ip_response
                    .read()
                    .decode("utf-8")
                    .strip()
                )
        except Exception:
            exit_ip = None

        try:
            response_headers = (
                response.all_headers()
                if response
                else {}
            )
        except Exception:
            response_headers = {}

        try:
            raw_cookies = (
                page.context.cookies()
            )

            cookies = [
                {
                    "name": item.get("name"),
                    "domain": item.get("domain"),
                    "path": item.get("path"),
                    "secure": item.get("secure"),
                    "httpOnly": item.get("httpOnly"),
                    "sameSite": item.get("sameSite"),
                    "expires": item.get("expires"),
                }
                for item in raw_cookies
            ]

        except Exception:
            cookies = []

        screenshot = page.screenshot(
            type="jpeg",
            quality=70,
            full_page=False,
        )

        try:
            body_text = page.locator(
                "body"
            ).inner_text(
                timeout=5000
            )[:6000]

        except Exception:
            body_text = ""

        result = {
            "requested_url": url,
            "final_url": page.url,
            "title": page.title(),
            "status": (
                response.status
                if response
                else None
            ),
            "screenshot": (
                base64.b64encode(
                    screenshot
                ).decode("ascii")
            ),
            "body_text": body_text,
            "exit_ip": exit_ip,
            "headers": response_headers,
            "redirects": navigation,
            "cookies": cookies,
        }

        print(
            json.dumps(result)
        )

        browser.close()


if __name__ == "__main__":
    main()
