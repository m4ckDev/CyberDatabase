# OSINT: Darkweb & Russia — Source Record

Canonical Start.me page:

https://start.me/p/kx5qL5/osint-darkweb-russia

Public references identify this collection as **OSINT: Darkweb & Russia** and attribute the Start.me collection to **CommanderGirl**.

## Repository purpose

This file ensures the source itself is permanently represented in CyberDatabase even when Start.me's current public JavaScript application does not expose its bookmark payload to static retrieval.

Related CyberDatabase material:

- [OSINT resource directory](../resource-directory/OSINT.md)
- [Dark-web / underground defensive watchlist](../threat-intelligence/DARK_WEB_WATCHLIST.md)
- `../../imports/deepdarkCTI/` — synchronized public CTI research material
- `../../knowledge-base/osint/`
- `../../knowledge-base/threat-intelligence/`

## Public research references associated with this collection

The collection is referenced in multiple public OSINT indexes as a Dark Web and Russia resource board. Those references preserve the canonical page rather than reproducing its private/application data:

- https://start.me/p/kx5qL5/osint-darkweb-russia
- https://github.com/C3n7ral051nt4g3ncy/OSINT_Inception-links
- https://github.com/sudo-flgr/OSINTKit-Brasil
- https://github.com/gh4rib/ghariib
- https://github.com/D-XPL01T/OSINT-Resources-by-Countries-GLOBAL

## Current extraction status

The live Start.me page is reachable, but the available static client receives Start.me's application-update shell rather than the collection's current bookmarks/widgets.

Accordingly:

- the canonical source is preserved;
- the collection is indexed from CyberDatabase;
- related defensive OSINT/CTI material is linked;
- no unknown bookmark destination is invented;
- no claim is made that a current live bookmark export was obtained.

An authenticated Start.me HTML export can be imported losslessly with:

```bash
python3 scripts/import_startme_export.py osint-darkweb-russia.html \
  --markdown references/startme/OSINT_DARKWEB_RUSSIA_CURRENT.md \
  --json references/startme/OSINT_DARKWEB_RUSSIA_CURRENT.json
```

## Dark-web handling

CyberDatabase may catalog public reporting, research tools, indexing/search resources, and defensive threat-intelligence references. It does not store stolen data, credentials, live malware, criminal transaction instructions, or authentication/access details for illicit services.
