# Start.me Source Collections

This directory preserves and indexes the Start.me collections supplied for CyberDatabase consolidation.

## Sources

| Collection | Canonical source | Repository representation | Verification status |
|---|---|---|---|
| CYBERSEC TOOLS | https://start.me/p/bpjxDe/cybersec-tools | [CYBERSEC_TOOLS.md](CYBERSEC_TOOLS.md) plus existing training, personal-security, hardware, and threat-intelligence directories | Existing CyberDatabase captures indexed; current Start.me public app is JavaScript-only to static clients |
| OSINT: Darkweb & Russia | https://start.me/p/kx5qL5/osint-darkweb-russia | [OSINT_DARKWEB_RUSSIA.md](OSINT_DARKWEB_RUSSIA.md) | Canonical source preserved; current bookmark payload is not exposed to the available static client |
| The Ultimate OSINT Collection | https://start.me/p/DPYPMz/the-ultimate-osint-collection | [ULTIMATE_OSINT_COLLECTION_2022-03-26.md](ULTIMATE_OSINT_COLLECTION_2022-03-26.md) | 245 resource entries recovered and grouped from the 2022-03-26 archived rendered page |

## Why these files exist

Start.me currently serves its public pages through a JavaScript application. A normal static HTTP client receives the application shell rather than the complete bookmark/widget data. CyberDatabase therefore keeps three things separately:

1. the canonical Start.me URL;
2. every bookmark/resource that can be verified from an existing CyberDatabase capture or a rendered archive;
3. provenance and extraction status so a missing value is never silently invented.

## Official export ingestion

Start.me supports account-level exports of bookmarks as HTML and feeds as OPML. The repository includes:

`scripts/import_startme_export.py`

That script accepts a Start.me/Netscape-style bookmark HTML export and writes both Markdown and JSON while retaining folder hierarchy, titles, and URLs. It requires no network access.

Example:

```bash
python3 scripts/import_startme_export.py startme-export.html \
  --markdown references/startme/current-export.md \
  --json references/startme/current-export.json
```

An authenticated Start.me export is the authoritative way to prove an exact current mirror when the public JavaScript application cannot be statically enumerated.

## Content policy

This directory mirrors resource indexes and public research references. It does not copy third-party article bodies, stolen datasets, credentials, live malware, or operational access details for criminal services. External sites remain owned and licensed by their respective authors/operators.
