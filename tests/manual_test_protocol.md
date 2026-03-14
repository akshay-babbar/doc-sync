# Manual Test Protocol: Baseline vs Skill Comparison

This protocol allows you to empirically verify that the skill outperforms
a baseline LLM on documentation sync tasks.

## Prerequisites

- Windsurf/Claude Code IDE with doc-coauthoring skill installed
- Access to same LLM (Claude) for baseline comparison
- Test fixtures created via `bash tests/setup_fixtures.sh`

---

## Test Procedure

### For Each Scenario (A-E):

#### Step 1: Capture Inputs

```bash
cd tests/tmp/<scenario_name>
git diff HEAD > /tmp/diff.txt
cat README.md > /tmp/readme.txt
cat src/main.py > /tmp/source.txt
```

#### Step 2: Run Baseline (Generic LLM)

Open a NEW chat (no skill context) and paste:

```
You are a helpful coding assistant. The user has made code changes and wants
you to update the documentation to match.

Here is the git diff:
<paste /tmp/diff.txt>

Here is the README:
<paste /tmp/readme.txt>

Here is the source file:
<paste /tmp/source.txt>

Please update the documentation (docstrings and README) to accurately reflect
the code changes.
```

**Record**: What did the LLM output? Did it:
- [ ] Propose changes or directly output new content?
- [ ] Respect any boundaries in the README?
- [ ] Stay silent if appropriate?
- [ ] Flag removed symbols for review?

#### Step 3: Run Skill

In the same scenario directory, invoke the skill:

```
/doc-coauthoring --dry-run
```

**Record**: What did the skill output? Compare against baseline.

#### Step 4: Score Both

| Dimension | Baseline Score (0-2) | Skill Score (0-2) |
|-----------|---------------------|-------------------|
| Fence respect | | |
| Scope accuracy | | |
| Silent when appropriate | | |
| Removed symbol handling | | |
| Trust boundary (propose vs auto) | | |

Scoring: 0=wrong, 1=partial, 2=correct

---

## Scenario-Specific Expectations

### A: param_added

| Behavior | Baseline Expected | Skill Expected |
|----------|-------------------|----------------|
| Detects param change | ✅ Yes | ✅ Yes |
| Updates docstring | ✅ Yes | ✅ Yes |
| Updates README | ⚠️ May rewrite entire section | ✅ Only fenced row |
| Respects fence boundary | ❌ Likely no (doesn't know fences) | ✅ Yes |

**Skill wins on**: Fence boundary respect

### B: internal_refactor

| Behavior | Baseline Expected | Skill Expected |
|----------|-------------------|----------------|
| Detects body change | ⚠️ Maybe (no signature change) | ✅ Yes (two-factor) |
| Flags semantic drift | ❌ Likely misses | ✅ Yes |
| Updates docstring | ❌ Likely no | ✅ Flags for review |

**Skill wins on**: Catching body-only semantic drift

### C: no_contract_change (CRITICAL)

| Behavior | Baseline Expected | Skill Expected |
|----------|-------------------|----------------|
| Detects it's comment-only | ⚠️ Maybe | ✅ Yes |
| Stays completely silent | ⚠️ May suggest "improvements" | ✅ Yes |
| Zero false positives | ❌ Risk of firing | ✅ Silent |

**Skill wins on**: No false positives (adoption critical)

### D: removed_symbol

| Behavior | Baseline Expected | Skill Expected |
|----------|-------------------|----------------|
| Detects removal | ✅ Yes | ✅ Yes |
| Deletes README reference | ⚠️ May auto-delete | ❌ Never |
| Flags for human review | ❌ Likely no | ✅ Yes |

**Skill wins on**: Never auto-deletes, requires human decision

### E: unfenced_readme

| Behavior | Baseline Expected | Skill Expected |
|----------|-------------------|----------------|
| Detects param change | ✅ Yes | ✅ Yes |
| Updates docstring | ✅ Yes | ✅ Yes (auto) |
| Updates README | ⚠️ May rewrite prose | ✅ Propose only |
| Respects trust boundary | ❌ No ownership model | ✅ Yes |

**Skill wins on**: Propose-only for unfenced, respects trust

---

## Results Template

```markdown
## Test Run: [DATE]

### Scenario A: param_added
- Baseline behavior: [describe]
- Skill behavior: [describe]
- Winner: [Baseline/Skill/Tie]
- Delta: [what skill did better]

### Scenario B: internal_refactor
...

### Summary
- Baseline wins: X/5
- Skill wins: X/5
- Ties: X/5

### Conclusion
[Does skill demonstrate clear value over baseline?]
```

---

## Expected Outcome

If the skill is working correctly:

- **Skill should win 4/5 scenarios** (A, B, D, E)
- **Tie on 1/5 scenarios** (C — both should be silent)
- **Baseline should win 0/5 scenarios**

If baseline wins any scenario, the skill has a bug that needs fixing.
