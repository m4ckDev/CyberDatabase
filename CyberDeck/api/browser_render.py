import base64
import json
import sys

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

        response = page.goto(
            url,
            wait_until="domcontentloaded",
            timeout=30000,
        )

        page.wait_for_timeout(750)

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
        }

        print(
            json.dumps(result)
        )

        browser.close()


if __name__ == "__main__":
    main()
