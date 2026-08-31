# Web and API Security

This section is the CyberDatabase entry point for the synchronized HackTricks `pentesting-web/` material. It organizes web assessment around application boundaries, evidence, detection, and remediation rather than individual payload collections.

## Application map

Before vulnerability testing, document:

- domains, subdomains, and virtual hosts;
- application entry points;
- API base paths and versions;
- authentication flows;
- user roles;
- session/token types;
- file upload/download paths;
- administrative interfaces;
- third-party integrations;
- WebSocket or other real-time endpoints;
- cloud/storage dependencies.

## HTTP baseline

Capture:

- redirect behavior;
- security headers;
- cookies and attributes;
- TLS configuration;
- caching behavior;
- CORS policy;
- supported methods;
- server/framework indicators;
- error handling.

Example baseline request:

```bash
curl -skI https://<HOST>/
```

Use a proxy such as Burp Suite or OWASP ZAP when you need complete request/response history and controlled replay.

## Authentication

Review:

- registration and account recovery;
- MFA enrollment/recovery;
- password policy and lockout;
- session creation and invalidation;
- remember-me behavior;
- OAuth/OIDC/SAML flows where used;
- API token lifecycle;
- device/session management.

Test whether the server enforces security decisions rather than relying on hidden UI controls.

## Authorization

Authorization failures are often more important than input bugs. Build a role/resource matrix and test whether users can access or modify objects belonging to other users or higher-privileged roles.

Record:

```text
Role -> Resource -> Expected action -> Observed action
```

Test object-level and function-level authorization separately.

## Input handling

Review all attacker-controlled input channels:

- URL/query parameters;
- path parameters;
- form bodies;
- JSON/XML;
- headers;
- cookies;
- uploaded files;
- filenames and metadata;
- WebSocket messages;
- data retrieved from third-party systems.

Potential weakness classes include injection, path traversal, unsafe deserialization, server-side request behavior, template processing, parser differentials, and unsafe file handling.

External payload reference: `../../references/security-research/payloads-site/README.md`

The Payloads.site reference maps SQL injection, XSS, LFI/RFI, command injection, SSRF, and common encoding/transformation options into the CyberDatabase web-testing workflow without mixing third-party payload material into CyberDatabase-owned documentation.

## Browser-side security

Review:

- DOM manipulation;
- output encoding;
- CSP;
- cross-origin messaging;
- local/session storage;
- sensitive data in client bundles;
- CSRF protections;
- clickjacking defenses;
- service workers;
- client-side routing and API assumptions.

## API security

For APIs, document:

- authentication scheme;
- authorization model;
- object identifiers;
- rate limits;
- pagination/filtering;
- mass-assignment behavior;
- schema validation;
- excessive data exposure;
- administrative endpoints;
- webhook/signature validation.

Test both direct API calls and workflows performed through the front end.

## File handling

File functionality should validate:

- allowed content/type;
- filename normalization;
- storage location;
- execution permissions;
- download authorization;
- archive extraction paths;
- malware scanning where applicable;
- whether user files are served from a separate origin.

## Evidence standard

For each web finding retain:

- exact request;
- exact relevant response;
- user/role used;
- target object/resource;
- expected control;
- observed behavior;
- impact;
- remediation;
- retest steps.

Redact tokens, passwords, session cookies, and unrelated personal data from reports.

## Defensive telemetry

Useful sources include:

- reverse proxy/WAF logs;
- application logs;
- API gateway logs;
- authentication provider logs;
- database audit logs;
- cloud load-balancer logs;
- endpoint/container logs;
- distributed tracing.

## Source relationship

The complete synchronized HackTricks web reference is available at:

`../../references/hacktricks-upstream/src/pentesting-web/`

Use `../hacktricks-derived/UPSTREAM_INDEX.md` for the current full upstream topic map after synchronization.

Additional external research references are indexed under `../../references/security-research/`.
