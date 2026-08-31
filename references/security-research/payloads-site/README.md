# Payloads.site Reference

Primary site: https://payloads.site/

Payloads.site is a web-application security payload library intended for penetration testing, bug-bounty work, security research, and lab validation. CyberDatabase uses it as an external reference source for web-security testing methodology rather than copying the site's payload collection verbatim.

## Coverage observed

The site is centered on common web-application weakness classes and payload preparation. Current public descriptions identify coverage including:

- SQL injection (SQLi)
- Cross-site scripting (XSS), including reflected, stored, and DOM-oriented testing
- Local file inclusion (LFI)
- Remote file inclusion (RFI)
- Command injection
- Server-side request forgery (SSRF)
- Payload transformation and encoding

Common transformation options described for the service include URL encoding, Base64, hexadecimal encoding, HTML entity encoding, double HTML encoding, and plain text.

## CyberDatabase mapping

Use this source alongside:

- `../../../knowledge-base/web-security/README.md`
- `../../../knowledge-base/hacktricks-derived/UPSTREAM_INDEX.md`
- `../../hacktricks-upstream/src/pentesting-web/`

### Suggested testing workflow

1. Identify the input surface and expected data type.
2. Establish a normal baseline request and response.
3. Select the vulnerability class relevant to the input path.
4. Use controlled test strings in an authorized target or lab.
5. Compare server-side behavior, status codes, response bodies, logs, and side effects.
6. Record exact request/response evidence.
7. Validate remediation and retest.

## Related defensive controls

- parameterized database queries
- context-aware output encoding
- strict server-side validation
- allowlisted file access
- outbound request restrictions and egress controls
- safe process invocation without shell expansion
- least-privilege application identities
- WAF/API-gateway telemetry
- application and database audit logging

## Source handling

CyberDatabase links to Payloads.site as an external resource. Payload strings should only be exercised against systems you own or are explicitly authorized to test.
