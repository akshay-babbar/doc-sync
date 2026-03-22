# Scenario: Markdown proposal cascades across multiple files for one documented symbol

A reporting utility changed the signature of a documented exported function. The function is mentioned in multiple markdown files, not just the README. The skill must update the docstring and propose markdown changes for every code-span or table-cell mention it finds.

## Baseline (committed) state

### `src/reporting.py`

```python
from __future__ import annotations


def build_summary(start_date: str, end_date: str) -> dict:
    """Build a summary report.

    Args:
        start_date: ISO start date.
        end_date: ISO end date.

    Returns:
        Summary payload.
    """
    return {"start": start_date, "end": end_date}
```

### `README.md`

```markdown
# analytics-kit

Use `build_summary` when you need a summary payload.

This README is human-authored. Do not auto-apply markdown edits.
```

### `docs/usage.md`

```markdown
# Usage

The `build_summary` helper powers the dashboard export flow.
```

### `docs/reference.md`

```markdown
# Reference

| Helper | Purpose |
|--------|---------|
| `build_summary` | Build summary payloads |
```

## Working tree (current) state

The function now supports archived records, but the documentation has not been updated yet.

### `src/reporting.py`

```python
from __future__ import annotations


def build_summary(start_date: str, end_date: str, include_archived: bool = False) -> dict:
    """Build a summary report.

    Args:
        start_date: ISO start date.
        end_date: ISO end date.

    Returns:
        Summary payload.
    """
    payload = {"start": start_date, "end": end_date}
    if include_archived:
        payload["archived"] = True
    return payload
```

### `README.md` (unchanged)

```markdown
# analytics-kit

Use `build_summary` when you need a summary payload.

This README is human-authored. Do not auto-apply markdown edits.
```

### `docs/usage.md` (unchanged)

```markdown
# Usage

The `build_summary` helper powers the dashboard export flow.
```

### `docs/reference.md` (unchanged)

```markdown
# Reference

| Helper | Purpose |
|--------|---------|
| `build_summary` | Build summary payloads |
```

## Git setup

```bash
git init
git config user.email "dev@example.com"
git config user.name "Dev"
mkdir -p src docs
cat > src/reporting.py <<'EOF'
from __future__ import annotations


def build_summary(start_date: str, end_date: str) -> dict:
    """Build a summary report.

    Args:
        start_date: ISO start date.
        end_date: ISO end date.

    Returns:
        Summary payload.
    """
    return {"start": start_date, "end": end_date}
EOF
cat > README.md <<'EOF'
# analytics-kit

Use `build_summary` when you need a summary payload.

This README is human-authored. Do not auto-apply markdown edits.
EOF
cat > docs/usage.md <<'EOF'
# Usage

The `build_summary` helper powers the dashboard export flow.
EOF
cat > docs/reference.md <<'EOF'
# Reference

| Helper | Purpose |
|--------|---------|
| `build_summary` | Build summary payloads |
EOF
git add -A && git commit -m "baseline"

cat > src/reporting.py <<'EOF'
from __future__ import annotations


def build_summary(start_date: str, end_date: str, include_archived: bool = False) -> dict:
    """Build a summary report.

    Args:
        start_date: ISO start date.
        end_date: ISO end date.

    Returns:
        Summary payload.
    """
    payload = {"start": start_date, "end": end_date}
    if include_archived:
        payload["archived"] = True
    return payload
EOF
```

## Output Specification

Run the doc-sync skill on the current working tree and produce `doc-sync-report.md` with the full report. It must update the docstring for `build_summary` to document `include_archived`, and it must propose markdown updates for every markdown file that mentions `build_summary` (`README.md`, `docs/usage.md`, and `docs/reference.md`).
