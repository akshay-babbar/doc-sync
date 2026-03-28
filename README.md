# doc-sync

[![doc-sync](https://img.shields.io/endpoint?url=https%3A%2F%2Fapi.tessl.io%2Fv1%2Fbadges%2Fakshay-babbar%2Fdoc-sync)](https://tessl.io/registry/akshay-babbar/doc-sync)

Auto-syncs docstrings when code changes. Proposes README updates — never auto-writes.

## The Mental Model

```
CODE CHANGE ──► doc-sync ──► Docstring: auto-write (after you confirm)
                              │
                              └─► README: propose only (you decide)
```

**One rule**: If documentation already exists for a symbol, keep it in sync. If not, report missing coverage — don't create from scratch.

## Quick Start

```bash
# Install
npx tessl install akshay-babbar/doc-sync

# Preview what would change
/doc-sync --dry-run

# Apply changes (asks for confirmation first)
/doc-sync --apply

# Check last 3 commits
/doc-sync --dry-run HEAD~3..HEAD
```

## What Gets Updated

| Target | Behavior |
|--------|----------|
| **Docstrings** | Auto-written after you confirm the report |
| **README mentions** | Proposed only — never auto-applied |
| **CHANGELOG / ADRs** | Never touched |

## The Trust Model

```
┌─────────────────────────────────────────────────┐
│            YOUR DOCUMENTATION                    │
├─────────────────────────────────────────────────┤
│  DOCSTRINGS          │  README / MARKDOWN       │
│  ───────────          │  ─────────────────       │
│  Auto-write           │  Propose only            │
│  (after confirm)      │  (you approve)           │
├─────────────────────────────────────────────────┤
│  PROTECTED: CHANGELOG, ADRs, LICENSE, SECURITY  │
│  ─────────────────────────────────────────────  │
│  Never modified. Period.                         │
└─────────────────────────────────────────────────┘
```

## Example

**Code change:**
```diff
- def fetch_user(user_id: int) -> User:
+ def fetch_user(user_id: int, include_profile: bool = False) -> User:
```

**What doc-sync does:**
1. Detects the new parameter
2. Finds the docstring for `fetch_user`
3. Shows you: "Will add `include_profile` to docstring"
4. After you confirm, adds:
   ```diff
     Args:
         user_id: The user's unique identifier.
   +     include_profile: Whether to include profile data. Defaults to False.
   ```

## Supported Languages

Python, TypeScript/JavaScript, Go, Rust, Ruby, Java, Kotlin

## Philosophy

| We do | We don't |
|-------|----------|
| Update existing docs | Create new docs from scratch |
| Flag ambiguity | Guess and silently fix |
| Ask before writing | Auto-commit changes |
| Minimal surgical edits | "Improve" surrounding content |

## Platforms

| Platform | Status |
|----------|--------|
| Claude Code | ✅ |
| Windsurf | ✅ |
| Cursor | ✅ |
| OpenCode | ✅ |

---

**Why trust this tool?** See [TRUST.md](TRUST.md) for what we protect and why.
