# Why You Can Trust doc-sync

## The Promise

**We never overwrite your words.** Your examples, warnings, explanations, and carefully crafted prose stay yours. We only update the mechanical parts — parameter names, type annotations, return types — and only when you approve.

## What We Protect

| Protected | What This Means |
|-----------|-----------------|
| **Your examples** | Never auto-updated, even if outdated |
| **Your warnings/notes** | Behavioral claims stay untouched |
| **README content** | Proposed only — you approve every change |
| **CHANGELOGs, ADRs** | Never modified, ever |

## What We Update

Only caller-visible contract info in docstrings:
- Parameter names and types
- Return type annotations
- Minimal deprecation notices (when code adds `@deprecated`)

## How We Behave

| Principle | In Practice |
|-----------|-------------|
| **Conservative** | Flag ambiguity rather than guess |
| **Transparent** | Every change explained, every skip documented |
| **Reversible** | Never auto-commits — `git checkout` always works |
| **Minimal** | One param change = one param doc updated |

## The Social Contract

**You agree to:**
- Review flagged items before proceeding
- Keep final responsibility for documentation quality

**We agree to:**
- Never expand scope without explicit opt-in
- Fail safe: when uncertain, we flag and stop
- Preserve your voice and intent

## Protected Files (Never Modified)

```
CHANGELOG.md, CHANGELOG.rst, HISTORY.md
ADR-*.md, decisions/*.md
CONTRIBUTING.md, CODE_OF_CONDUCT.md, SECURITY.md
LICENSE*, .github/*.md
*.mdx
```

These files are excluded from candidate search entirely — not proposed, not flagged, not mentioned.

---

*Version 3.0.11*
