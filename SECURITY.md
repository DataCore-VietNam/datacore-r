# Security Policy

## Supported versions

| Version | Supported          |
|---------|--------------------|
| 0.x     | Yes (latest minor) |

Only the latest minor release on `main` receives security fixes. Upgrade
to the latest version before reporting an issue.

## Reporting a vulnerability

**Do not file a public GitHub issue for security vulnerabilities.**

Report privately via one of:

- **GitHub private vulnerability reporting** (preferred): go to the
  [Security
  tab](https://github.com/DataCore-VietNam/datacore-r/security/advisories/new)
  and click “Report a vulnerability”
- **Email**: <security@datacore.vn> (PGP not required; use subject line
  “datacore-r security”)

Include as much of the following as possible:

- Description of the vulnerability and its potential impact
- Steps to reproduce or proof-of-concept
- Affected versions
- Suggested fix, if you have one

We will acknowledge receipt within 2 business days and aim to release a
fix within 14 days for critical issues.

## Scope

Issues in scope include:

- API key leakage or insufficient masking in logs/output
- Authentication bypass
- Dependency vulnerabilities with a clear exploit path

Out of scope: theoretical issues with no practical exploit path, issues
in test fixtures or mocked data.
