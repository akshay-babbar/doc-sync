# Scenario: Protected file mention exists alongside a valid README proposal

A Python package changed a documented function signature. The symbol is mentioned in two markdown files: a regular `README.md` section that should receive a propose-only update, and a `CHANGELOG.md` entry that must be ignored completely. The skill must update the docstring, propose the README change, and never mention or propose the changelog entry.

## Baseline (committed) state

### `src/reports.py`

```python
def publish_report(report_id: str) -> str:
    """Publish a stored report.

    Args:
        report_id: Report identifier to publish.

    Returns:
        Published report identifier.
    """
    return report_id
```

### `README.md`

```markdown
# reports-kit

Use `publish_report` to publish a generated report for downstream systems.

README updates are propose-only.
```

### `CHANGELOG.md`

```markdown
# Changelog

## v1.4.0

- Improved `publish_report` reliability during weekend batch runs.
```

## Working tree (current) state

The function adds a new optional parameter `include_archived`. README and changelog are otherwise unchanged.

### `src/reports.py`

```python
def publish_report(report_id: str, include_archived: bool = False) -> str:
    """Publish a stored report.

    Args:
        report_id: Report identifier to publish.

    Returns:
        Published report identifier.
    """
    _ = include_archived
    return report_id
```

### `README.md` (unchanged)

```markdown
# reports-kit

Use `publish_report` to publish a generated report for downstream systems.

README updates are propose-only.
```

### `CHANGELOG.md` (unchanged)

```markdown
# Changelog

## v1.4.0

- Improved `publish_report` reliability during weekend batch runs.
```

## Git setup

```bash
git init
mkdir -p src
cat > src/reports.py <<'EOF'
def publish_report(report_id: str) -> str:
    """Publish a stored report.

    Args:
        report_id: Report identifier to publish.

    Returns:
        Published report identifier.
    """
    return report_id
EOF
cat > README.md <<'EOF'
# reports-kit

Use `publish_report` to publish a generated report for downstream systems.

README updates are propose-only.
EOF
cat > CHANGELOG.md <<'EOF'
# Changelog

## v1.4.0

- Improved `publish_report` reliability during weekend batch runs.
EOF
git add -A && git commit -m "baseline"

cat > src/reports.py <<'EOF'
def publish_report(report_id: str, include_archived: bool = False) -> str:
    """Publish a stored report.

    Args:
        report_id: Report identifier to publish.

    Returns:
        Published report identifier.
    """
    _ = include_archived
    return report_id
EOF
```

## Output Specification

Produce `doc-sync-report.md` with the full doc-sync report. It must update the `publish_report` docstring, include a propose-only entry for `README.md`, and completely ignore `CHANGELOG.md` (no proposal, no flag, no mention).
