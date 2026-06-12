# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.x.x   | ✅ Active support |
| < 1.0   | ❌ No longer supported |

## Reporting a Vulnerability

**Please do NOT report security vulnerabilities via GitHub Issues.**

To report a vulnerability:

1. **Email**: security@flowerai.example.com
2. **PGP Key**: Available at `https://flowerai.example.com/.well-known/pgp-key.txt`
3. **GitHub**: Use [Private Security Advisories](https://github.com/your-username/flower-ai/security/advisories/new)

### What to include

- Description of the vulnerability
- Steps to reproduce
- Potential impact assessment
- Suggested fix (optional)

### Response Timeline

| Milestone | Target |
|-----------|--------|
| Acknowledgement | 48 hours |
| Initial assessment | 5 business days |
| Fix release | 30 days (critical: 7 days) |
| Public disclosure | 90 days after fix |

## Security Measures

FlowerAI implements the following security controls:

- **Authentication**: JWT (HS256) + OAuth2 (Google, GitHub)
- **Authorisation**: Role-Based Access Control (RBAC)
- **Rate Limiting**: Redis-backed sliding window algorithm
- **Input Validation**: Pydantic v2 + file type validation + size limits
- **Image Sanitisation**: PIL re-encoding removes EXIF metadata and embedded scripts
- **Dependency Scanning**: Dependabot + Trivy in CI/CD
- **Container Security**: Non-root user, read-only filesystem where possible
- **Secret Management**: Environment variables + HashiCorp Vault (production)
- **TLS**: All traffic encrypted in transit (TLS 1.3 minimum)
- **CORS**: Strict origin allowlist
- **CSP**: Content-Security-Policy headers on all responses
- **SQL Injection**: SQLAlchemy ORM with parameterised queries only
- **OWASP Top 10**: Reviewed quarterly

## Responsible Disclosure

We follow responsible disclosure principles. Security researchers who report valid vulnerabilities in good faith will be acknowledged in our release notes (with permission).
