#!/usr/bin/env python3
"""Convert a Start.me/Netscape bookmark HTML export to Markdown and JSON.

The converter preserves:
- folder hierarchy;
- bookmark title;
- URL;
- duplicate bookmarks;
- ordering as encountered in the export.

It intentionally does not dereference, normalize, deduplicate, or "fix" URLs,
because doing so would alter the source export.
"""

from __future__ import annotations

import argparse
import html
import json
from dataclasses import dataclass, asdict
from html.parser import HTMLParser
from pathlib import Path
from typing import List


@dataclass
class Bookmark:
    title: str
    url: str
    folders: List[str]
    add_date: str | None = None
    icon: str | None = None


class NetscapeBookmarkParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.bookmarks: list[Bookmark] = []
        self.folder_stack: list[str] = []
        self.pending_folder: str | None = None
        self.in_h3 = False
        self.h3_text: list[str] = []
        self.in_a = False
        self.a_text: list[str] = []
        self.a_href: str | None = None
        self.a_add_date: str | None = None
        self.a_icon: str | None = None
        self.dl_depth = 0
        self.folder_depths: list[int] = []

    def handle_starttag(self, tag: str, attrs) -> None:
        attrs_dict = {k.lower(): v for k, v in attrs}
        tag = tag.lower()

        if tag == "h3":
            self.in_h3 = True
            self.h3_text = []
        elif tag == "a":
            self.in_a = True
            self.a_text = []
            self.a_href = attrs_dict.get("href")
            self.a_add_date = attrs_dict.get("add_date")
            self.a_icon = attrs_dict.get("icon")
        elif tag == "dl":
            self.dl_depth += 1
            if self.pending_folder is not None:
                self.folder_stack.append(self.pending_folder)
                self.folder_depths.append(self.dl_depth)
                self.pending_folder = None

    def handle_endtag(self, tag: str) -> None:
        tag = tag.lower()

        if tag == "h3":
            self.in_h3 = False
            name = "".join(self.h3_text).strip()
            if name:
                self.pending_folder = name

        elif tag == "a":
            self.in_a = False
            if self.a_href:
                title = "".join(self.a_text).strip() or self.a_href
                self.bookmarks.append(
                    Bookmark(
                        title=title,
                        url=self.a_href,
                        folders=list(self.folder_stack),
                        add_date=self.a_add_date,
                        icon=self.a_icon,
                    )
                )
            self.a_text = []
            self.a_href = None
            self.a_add_date = None
            self.a_icon = None

        elif tag == "dl":
            if self.folder_depths and self.folder_depths[-1] == self.dl_depth:
                self.folder_depths.pop()
                self.folder_stack.pop()
            self.dl_depth = max(0, self.dl_depth - 1)

    def handle_data(self, data: str) -> None:
        if self.in_h3:
            self.h3_text.append(data)
        if self.in_a:
            self.a_text.append(data)


def markdown_for(bookmarks: list[Bookmark], source: str) -> str:
    lines = [
        "# Start.me Bookmark Export",
        "",
        f"Source export: `{source}`",
        "",
        f"Bookmarks: **{len(bookmarks)}**",
        "",
        "Entries are preserved in source order. Duplicate URLs are intentionally retained.",
        "",
    ]

    current: tuple[str, ...] | None = None

    for item in bookmarks:
        folders = tuple(item.folders)
        if folders != current:
            current = folders
            lines.append("")
            if folders:
                lines.append("## " + " / ".join(folders))
            else:
                lines.append("## Unfiled")
            lines.append("")

        safe_title = item.title.replace("[", "\\[").replace("]", "\\]")
        lines.append(f"- [{safe_title}]({item.url})")

    lines.append("")
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("input", type=Path, help="Start.me bookmark HTML export")
    parser.add_argument("--markdown", type=Path, required=True)
    parser.add_argument("--json", dest="json_path", type=Path, required=True)
    args = parser.parse_args()

    raw = args.input.read_text(encoding="utf-8", errors="replace")
    parser_obj = NetscapeBookmarkParser()
    parser_obj.feed(raw)

    args.markdown.parent.mkdir(parents=True, exist_ok=True)
    args.json_path.parent.mkdir(parents=True, exist_ok=True)

    args.markdown.write_text(
        markdown_for(parser_obj.bookmarks, str(args.input)),
        encoding="utf-8",
    )

    payload = {
        "source_export": str(args.input),
        "count": len(parser_obj.bookmarks),
        "bookmarks": [asdict(item) for item in parser_obj.bookmarks],
    }
    args.json_path.write_text(
        json.dumps(payload, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )

    print(f"Imported {len(parser_obj.bookmarks)} bookmarks")
    print(f"Markdown: {args.markdown}")
    print(f"JSON: {args.json_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
