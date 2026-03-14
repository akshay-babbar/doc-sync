---
name: doc-coauthoring
description: >
  Updates inline docstrings and fence-marked README sections when a
  documented symbol's contract changes (parameters, return type, new or
  removed symbol). Invoke after commits that change function signatures.
  Preserves all human-authored content. Never modifies unfenced sections,
  tutorials, changelogs, or ADRs. Use /doc-coauthoring --dry-run to preview,
  /doc-coauthoring --apply to write patches. Auto-invocable by Claude for
  dry-run detection; only writes files when --apply is explicitly passed.
license: MIT
metadata:
  version: "2.0.0"
  author: doc-coauthoring
context: fork
allowed-tools: Read Edit Grep Bash
argument-hint: "[--dry-run | --apply] [commit-range]"
---

# Doc-Coauthoring

Surgical documentation updater. Patches docs when a documented symbol's
caller-visible contract changes. Conservative by design: flag more, change less.

## Invocation

- `/doc-coauthoring` or `/doc-coauthoring --dry-run` — detect and report, **no file writes**
- `/doc-coauthoring --apply` — detect, report, and write patches
- `/doc-coauthoring --apply HEAD~3..HEAD` — specify commit range

Arguments are available as `$ARGUMENTS`. Default to dry-run when empty.

## Workflow

Load `references/workflow-steps.md` for full execution detail.

1. Run `scripts/get_diff.sh $ARGUMENTS` to detect changes (default: all uncommitted)
2. Check existing doc coverage for every changed symbol (Step 2.5 in workflow-steps.md)
3. Check for unfenced README candidate sections via symbol-name grep (Step 2.5 Check 3)
4. Classify with two-factor + ownership test (Step 2 in workflow-steps.md)
5. For each markdown target: run `scripts/check-fences.sh <file>` before any edit
6. If `--apply`: auto-write docstrings + fenced sections; never auto-write unfenced prose
7. Verify every edit with `references/verify-steps.md`
8. Report in unified format: Updated / Proposed / Flagged / Missing Coverage / Skipped

## Scope — The Two-Factor Rule

A symbol is in scope when **both** conditions are true:
1. It already has a docstring or fence-marked section (previously documented)
2. Its code changed

**The binding vote principle**: past documentation is a vote on importance.
A trivial 1-line body change in a documented function is in scope.
A trivial 1-line change in an undocumented function is not.
Visibility (public/private/internal) is irrelevant — only prior documentation is.

**Ownership rule**: fences are the permission layer, not the discovery layer.
- Docstring in source → auto-write
- Fenced README section → auto-write
- Unfenced README prose → propose-only, never auto-written
- No coverage → report-only, nothing created

See `references/scope-bounds.md` and `references/workflow-steps.md` Step 2.5.

## When Uncertain

Flag as `[NEEDS HUMAN REVIEW]`, explain, stop. Never guess.
