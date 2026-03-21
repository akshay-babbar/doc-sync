# Catch Stale Docstring After Validation Logic Change

A platform engineering team tightened the validation logic inside a Python function. The function's signature is completely unchanged — same parameters, same return type — but the implementation now enforces an additional rule. The existing docstring describes the old behavior and is now inaccurate.

The team wants to run the doc-coauthoring skill to catch any stale documentation before shipping. Use `--apply` mode.

## Setup

Extract the following files, then set up the git repository:

=============== FILE: inputs/setup.sh ===============
#!/usr/bin/env bash
set -euo pipefail
git init
git config user.email "dev@example.com"
git config user.name "Dev"
mkdir -p src
cat > src/validator.py << 'PYEOF'
def validate_password(password: str) -> bool:
    """Validate a password against security policy.

    Checks two conditions:
    1. Minimum length of 8 characters
    2. Contains at least one digit

    Args:
        password: The plaintext password string to validate.

    Returns:
        True if valid, False otherwise.
    """
    if len(password) < 8:
        return False
    if not any(c.isdigit() for c in password):
        return False
    return True
PYEOF
git add -A && git commit -m "baseline"
cat > src/validator.py << 'PYEOF'
def validate_password(password: str) -> bool:
    """Validate a password against security policy.

    Checks two conditions:
    1. Minimum length of 8 characters
    2. Contains at least one digit

    Args:
        password: The plaintext password string to validate.

    Returns:
        True if valid, False otherwise.
    """
    if len(password) < 8:
        return False
    if not any(c.isdigit() for c in password):
        return False
    if not any(c.isupper() for c in password):
        return False
    if not any(c in "!@#$%^&*" for c in password):
        return False
    return True
PYEOF

## Output Specification

Run the doc-coauthoring skill and produce a `doc-sync-report.md` with the full output.
