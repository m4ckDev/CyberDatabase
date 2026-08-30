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

        result = {
            "requested_url": url,
            "final_url": page.url,
            "title": page.title(),
            "status": (
                response.status
                if response
                else None
            ),
        }

        print(json.dumps(result))

        browser.close()


if __name__ == "__main__":
    main()
