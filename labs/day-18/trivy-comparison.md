# Trivy comparison (HIGH + CRITICAL, --ignore-unfixed, Trivy 0.74.0)

| Image | CRITICAL | HIGH | Notes |
|---|---|---|---|
| node:14 | 18 | 439 | Debian 10, end-of-life |
| node:22-alpine | 0 | 10 | Alpine, 19 OS packages |
| my-site:1.0 | 0 | 3 | nginx:alpine base |
| nonroot-demo | 0 | 2 | alpine:3.20 base |

Fewer findings: nonroot-demo (2 vs 3), because it is bare Alpine with no nginx, so it has fewer packages and a smaller attack surface. node:14 has 457 because it is end-of-life Debian 10 with old Node tooling.
