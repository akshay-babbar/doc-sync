# Handle Legacy API Deprecation and Logic Refactoring

## Problem/Feature Description

A payments processing library (`paylib`) is going through a cleanup sprint. Two things happened in the latest commit: a legacy function was marked with a deprecation decorator, and a core tax calculation function was refactored to use a different formula (the old flat-rate logic was replaced with a tiered bracket system). The functions' signatures were not changed in either case.

The engineering lead wants the doc-coauthoring tool run with the apply flag to bring the documentation in sync with the code. They want to make sure the tool handles both changes correctly and produces a clear report of what was done.

Set up the repository, run the tool, and produce a report.

## Output Specification

- Produce a file called `doc-sync-report.md` containing the full output of the skill run.
- Updated source files should remain on disk so changes can be inspected.

## Input Files

Extract the files below and set up the repository as described at the end.

=============== FILE: paylib/billing.py ===============
import functools
from typing import Callable


def deprecated(func: Callable) -> Callable:
    """Mark a function as deprecated."""
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        import warnings
        warnings.warn(f"{func.__name__} is deprecated", DeprecationWarning, stacklevel=2)
        return func(*args, **kwargs)
    return wrapper


@deprecated
def get_user_balance(user_id: str) -> float:
    """Retrieve the current balance for a user account.

    Args:
        user_id: The unique identifier for the user.

    Returns:
        The account balance as a float.
    """
    # Legacy lookup — replaced by get_account_summary()
    return 0.0


def calculate_tax(amount: float, region: str = "US") -> float:
    """Calculate tax on a purchase amount using a flat rate.

    Args:
        amount: The pre-tax purchase amount in dollars.
        region: The ISO region code for tax jurisdiction.

    Returns:
        The tax amount to add to the purchase total.
    """
    if region != "US":
        return round(amount * 0.20, 2)
    # Tiered brackets
    if amount <= 100:
        return round(amount * 0.05, 2)
    elif amount <= 500:
        return round(100 * 0.05 + (amount - 100) * 0.10, 2)
    else:
        return round(100 * 0.05 + 400 * 0.10 + (amount - 500) * 0.15, 2)


def format_currency(amount: float, symbol: str = "$") -> str:
    """Format a numeric amount as a currency string.

    Args:
        amount: The monetary value to format.
        symbol: The currency symbol prefix.

    Returns:
        A formatted string like '$12.50'.
    """
    return f"{symbol}{amount:.2f}"

=============== FILE: README.md ===============
# paylib

Payments processing utilities.

## API

- `calculate_tax(amount, region)` — computes tax; uses a flat rate of 5% for US
- `format_currency(amount, symbol)` — formats a float as a currency string
- `get_user_balance(user_id)` — legacy balance lookup (being phased out)

---

**Baseline (commit this first):**

The committed version of `paylib/billing.py` should have:
1. `get_user_balance` WITHOUT the `@deprecated` decorator
2. `calculate_tax` using a flat-rate approach with the docstring describing it as flat-rate:

```python
import functools
from typing import Callable


def deprecated(func: Callable) -> Callable:
    """Mark a function as deprecated."""
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        import warnings
        warnings.warn(f"{func.__name__} is deprecated", DeprecationWarning, stacklevel=2)
        return func(*args, **kwargs)
    return wrapper


def get_user_balance(user_id: str) -> float:
    """Retrieve the current balance for a user account.

    Args:
        user_id: The unique identifier for the user.

    Returns:
        The account balance as a float.
    """
    return 0.0


def calculate_tax(amount: float, region: str = "US") -> float:
    """Calculate tax on a purchase amount using a flat rate.

    Args:
        amount: The pre-tax purchase amount in dollars.
        region: The ISO region code for tax jurisdiction.

    Returns:
        The tax amount to add to the purchase total.
    """
    if region != "US":
        return round(amount * 0.20, 2)
    return round(amount * 0.05, 2)


def format_currency(amount: float, symbol: str = "$") -> str:
    """Format a numeric amount as a currency string.

    Args:
        amount: The monetary value to format.
        symbol: The currency symbol prefix.

    Returns:
        A formatted string like '$12.50'.
    """
    return f"{symbol}{amount:.2f}"
```

Initialize a git repo, commit the baseline `billing.py` and `README.md`, then overwrite `billing.py` with the working-tree version above.
