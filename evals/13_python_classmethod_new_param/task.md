# Scenario: Decorated Python classmethod gains a new parameter; docstring must still be updated

A service client factory method is a `@classmethod`. It gains a new optional parameter, but the README still mentions the method in a code span. The skill must update the docstring for the decorated method and keep markdown changes propose-only.

## Baseline (committed) state

### `src/client.py`

```python
from __future__ import annotations


class ApiClient:
    def __init__(self, endpoint: str) -> None:
        self.endpoint = endpoint

    @classmethod
    def from_env(cls) -> "ApiClient":
        """Build a client from environment variables.

        Returns:
            ApiClient built from environment settings.
        """
        endpoint = "https://api.example.com"
        return cls(endpoint)
```

### `README.md`

```markdown
# client-kit

Use `from_env` to build an API client from environment variables.

This README is human-authored. Do not auto-apply markdown edits.
```

## Working tree (current) state

The classmethod now accepts a profile name so clients can load different endpoints.

### `src/client.py`

```python
from __future__ import annotations


class ApiClient:
    def __init__(self, endpoint: str) -> None:
        self.endpoint = endpoint

    @classmethod
    def from_env(cls, profile: str = "default") -> "ApiClient":
        """Build a client from environment variables.

        Returns:
            ApiClient built from environment settings.
        """
        endpoint = f"https://{profile}.api.example.com"
        return cls(endpoint)
```

### `README.md` (unchanged)

```markdown
# client-kit

Use `from_env` to build an API client from environment variables.

This README is human-authored. Do not auto-apply markdown edits.
```

## Git setup

```bash
git init
git config user.email "dev@example.com"
git config user.name "Dev"
mkdir -p src
cat > src/client.py <<'EOF'
from __future__ import annotations


class ApiClient:
    def __init__(self, endpoint: str) -> None:
        self.endpoint = endpoint

    @classmethod
    def from_env(cls) -> "ApiClient":
        """Build a client from environment variables.

        Returns:
            ApiClient built from environment settings.
        """
        endpoint = "https://api.example.com"
        return cls(endpoint)
EOF
cat > README.md <<'EOF'
# client-kit

Use `from_env` to build an API client from environment variables.

This README is human-authored. Do not auto-apply markdown edits.
EOF
git add -A && git commit -m "baseline"

cat > src/client.py <<'EOF'
from __future__ import annotations


class ApiClient:
    def __init__(self, endpoint: str) -> None:
        self.endpoint = endpoint

    @classmethod
    def from_env(cls, profile: str = "default") -> "ApiClient":
        """Build a client from environment variables.

        Returns:
            ApiClient built from environment settings.
        """
        endpoint = f"https://{profile}.api.example.com"
        return cls(endpoint)
EOF
```

## Output Specification

Run the doc-sync skill on the current working tree and produce `doc-sync-report.md` with the full report. It must update the docstring for `from_env` to document `profile`, and the README mention of `from_env` must remain propose-only.
