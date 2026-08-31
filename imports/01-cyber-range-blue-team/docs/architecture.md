# Lab Architecture

The lab is intentionally simple and local-only.

```text
+-------------------+       writes logs        +--------------------+
| Simulated Web App | -----------------------> | sample-logs/       |
| localhost:8080    |                          | web-access.log     |
+-------------------+                          +--------------------+

+-------------------+       writes logs        +--------------------+
| Log Generator     | -----------------------> | auth/process/net/  |
| synthetic events  |                          | syslog/fim logs    |
+-------------------+                          +--------------------+

+-------------------+       reads logs         +--------------------+
| Monitor           | -----------------------> | JSON alerts        |
| detection logic   |                          | reports/alerts*    |
+-------------------+                          +--------------------+

+-------------------+
| Dashboard         |
| localhost:8088    |
+-------------------+
```

## Components

### Simulated Web Service

A harmless Flask application that writes web access-style events. It does not contain real exploitation functionality.

### Log Generator

A Python container that creates synthetic Linux, authentication, process, file integrity, network, and web events.

### Monitor

A Python container that scans logs and emits example JSON alerts.

### Dashboard Placeholder

A static HTML page for future visualization. It is intentionally simple so learners can later replace it with their own dashboard stack.
