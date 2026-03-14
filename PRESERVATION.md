# Preservation Contract

This is the public social contract for the doc-coauthoring skill.
It defines what the skill promises to protect.

---

## The Promise

**We will never overwrite your words.**

Documentation you wrote by hand — explanations, tutorials, design decisions,
historical context, carefully crafted examples — belongs to you. This skill
exists to update the mechanical parts (signatures, parameter lists, type
annotations) so you don't have to. It does not exist to replace your voice.

## What We Protect

### 1. Everything Outside Fence Markers

Fence markers (`<!-- doc-sync: start/end -->`) define machine territory.
Everything outside those markers is human territory. We do not cross that line.

If a section has no fence markers, we report it and stop. We do not insert
markers ourselves. The decision to make content machine-managed is yours.

### 2. Your Examples

Examples in docstrings are pedagogical choices. Even if a parameter name
changes, we flag the example for your review rather than auto-update it.
A broken example is visible and fixable; a subtly wrong example is dangerous.

### 3. Your Warnings and Notes

If you wrote "Note: This function is slow on large inputs" or "Warning: Not
thread-safe", we leave it alone. We cannot verify behavioral claims, so we
do not touch them.

### 4. Your Deprecation Notices

Deprecation is a policy decision. We flag deprecated symbols for review
rather than auto-generating deprecation notices.

### 5. Historical Documentation

CHANGELOGs, ADRs (Architecture Decision Records), and historical documents
are append-only records. We never modify them.

## What We Update

Only caller-visible contract documentation, and only within fenced regions:

- **Parameter names and types** in docstrings when they change in code
- **Return types** in docstrings when they change in code  
- **Function signatures** in fenced README tables
- **New symbol documentation** (but only structural — name, params, return)

## How We Behave

### Conservative

We do less than you might expect. We flag ambiguity rather than guess.
A false positive (flagging something that didn't need review) is acceptable.
A false negative (silently making a wrong change) is not.

### Transparent

We report exactly what we changed and why. We report exactly what we flagged
and why. We report what we skipped (missing fences) and why.

### Reversible

We never auto-commit. You see the diff before it becomes permanent.
If we got something wrong, `git checkout` fixes it.

### Minimal

We change only what the contract change requires. If one parameter was added,
we update one parameter's documentation. We do not "improve" adjacent content.

## The Social Contract

By using this skill, you agree that:

1. **Fenced content is machine-managed.** Don't hand-edit fenced sections
   without understanding they may be overwritten on next sync.

2. **Unfenced content is human-managed.** We will never touch it without
   your explicit instruction to add fences.

3. **Flags require action.** When we flag something `[NEEDS HUMAN REVIEW]`,
   you must address it. We will not proceed past flags automatically.

4. **You review before committing.** This skill proposes changes; you approve
   them. The responsibility for the final documentation is yours.

By maintaining this skill, we agree that:

1. **We will not expand scope.** This skill does one thing. It will not
   grow to generate changelogs, write tutorials, or format code.

2. **We will preserve trust.** Every breaking change to preservation behavior
   will be announced clearly and require explicit opt-in.

3. **We will fail safe.** When uncertain, we flag. When broken, we stop.
   We do not guess our way through errors.

---

## Questions & Answers

**Q: What if I want to hand-edit a fenced section?**

A: You can, but understand that your edits may be overwritten on the next
sync if the corresponding code changes. Consider moving explanatory content
outside the fence markers.

**Q: What if my documentation style doesn't match what the skill produces?**

A: The skill matches existing style. It reads your current docstrings and
replicates their format. If the output doesn't match, file a bug.

**Q: What if I disagree with a flag?**

A: Dismiss it and make the change yourself. Flags are suggestions, not blocks.
The skill errs on the side of caution; you know your code better.

**Q: What about auto-generated docs from tools like Sphinx or TypeDoc?**

A: This skill updates source documentation (docstrings in code, README sections).
Generated documentation should regenerate automatically from updated sources.

---

*This contract is versioned with the skill. Current version: 1.0.0*
