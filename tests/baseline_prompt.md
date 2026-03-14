# Baseline Prompt (Generic LLM — No Skill)

This represents what a state-of-the-art LLM would receive WITHOUT the doc-coauthoring skill.
This is the "90% solution" that works out of the box.

---

## Prompt Given to LLM

```
You are a helpful coding assistant. The user has made code changes and wants
you to update the documentation to match.

Here is the git diff of what changed:

<git_diff>
{paste git diff HEAD output here}
</git_diff>

Here are the current documentation files:

<readme>
{paste README.md contents}
</readme>

<source_file>
{paste source file with docstrings}
</source_file>

Please update the documentation (docstrings and README) to accurately reflect
the code changes. Make sure the documentation stays in sync with the code.
```

---

## Expected Baseline Behavior (Known Weaknesses)

A generic LLM with this prompt will typically:

### ✅ What it does well
- Detect obvious signature changes (params, return types)
- Update docstrings when clearly out of date
- Suggest README updates for major changes

### ❌ What it gets wrong

| Scenario | Baseline Behavior | Problem |
|----------|-------------------|---------|
| **Unfenced README** | Rewrites entire README section | Overwrites human-authored prose |
| **Body-only change** | Often skips (no signature change) | Misses semantic drift |
| **Removed symbol** | May delete README reference | Loses intentional tombstones |
| **Comment-only change** | May fire anyway | False positive, annoying |
| **Private functions** | May document them | Scope creep |

### Why these failures happen

1. **No ownership model** — LLM doesn't know what's machine-editable vs human-authored
2. **No scope rules** — LLM documents everything, not just "previously documented" symbols
3. **No fence markers** — LLM can't distinguish safe-to-edit zones
4. **No binding vote** — LLM doesn't respect prior documentation decisions

---

## The Delta: What the Skill Adds

The doc-coauthoring skill adds these specific guardrails:

| Skill Feature | What It Prevents |
|---------------|------------------|
| Fence markers (`<!-- doc-sync: start/end -->`) | Overwriting human prose |
| Two-factor rule (code change + prior doc) | Documenting undocumented symbols |
| Ownership policy (docstring=auto, unfenced=propose) | Trust boundary violations |
| [REMOVED] flag (never auto-delete) | Losing intentional tombstones |
| Silent on comment-only changes | False positives |

---

## How to Test Baseline vs Skill

1. Run same scenario with baseline prompt
2. Run same scenario with skill invocation
3. Compare outputs on these dimensions:
   - Did it respect fence boundaries?
   - Did it stay silent when it should?
   - Did it propose vs auto-write correctly?
   - Did it flag removed symbols for review?
