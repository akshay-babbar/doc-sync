# doc-coauthoring

A universal agentic skill that updates inline docstrings and fence-marked README
sections when a **documented symbol's** contract changes. Conservative by design:
patches what changed, protects what didn't, flags what's uncertain.

Scope: any symbol that already has a docstring or fence-marked section —
public, private, or internal. Documentation drift does not respect visibility.

## What It Does

- ✅ Detects caller-visible contract changes via git diff (tracked files: staged + unstaged)
- ✅ Untracked files excluded by default — stage new files to include them
- ✅ Dry-run mode by default — reports what would change without writing files
- ✅ Apply mode (`--apply`) writes patches after you review the dry-run
- ✅ **Auto-writes** inline docstrings and fenced README sections (permission layer: fences)
- ✅ **Proposes-only** to unfenced README prose — never auto-overwrites mixed human content
- ✅ Discovers unfenced candidate sections via lightweight symbol-name grep
- ✅ Unified diff-style report: same format for auto-writes, proposals, flags, and skips
- ✅ Flags removed/renamed symbols as `[NEEDS HUMAN REVIEW]`, never auto-deletes
- ✅ Reports missing documentation coverage
- ✅ Preserves all human-authored content — runs forked, isolated from conversation

## Ownership Model

```
Docstring in source file      → auto-write (no setup needed)
Fenced README section         → auto-write (opt-in via <!-- doc-sync --> markers)
Unfenced README prose         → propose-only, shown in report, never auto-applied
No documentation found        → report only, nothing created
```

Fences are a **permission layer**, not a discovery layer. The skill finds relevant
sections everywhere using symbol-name matching. It only overwrites where it has
explicit permission. Start without any fences — the skill is immediately useful
via docstring updates and proposals.

## What It Does NOT Do

- ❌ No AST parsing — uses pattern matching
- ❌ No auto-fence insertion — fences require human decision
- ❌ No changelog generation — requires release context
- ❌ No tutorial updates — requires pedagogical judgment
- ❌ No auto-commit — human must review first
- ❌ No external API calls — zero network dependencies
- ❌ No pip/npm dependencies — pure shell + markdown

## V1 Known Limitations

### Trust-on-Prompt Write Boundary

The skill uses `allowed-tools: Edit` which permits file edits anywhere in the
workspace. The ownership rules (docstrings = auto-write, fenced = auto-write,
unfenced = propose-only) are enforced by **prompt instructions**, not by a
hard filesystem permission boundary.

For V1 this is acceptable because:
- Dry-run is the default — no writes without explicit `--apply`
- `check-fences.sh` runs before any markdown edit
- The skill runs in a forked context, isolated from conversation

Future versions may add path-restricted tool permissions.

### Body-Only Change Detection is Model-Dependent

The "body-only change in a documented function" case (Step 2.5) requires the
model to compare the existing docstring description to the new code behavior
and judge whether they conflict.

This is the most subjective step. Expected behavior by model:
- **Claude Opus/Sonnet**: reliable, will catch most semantic drift
- **Claude Haiku**: may skip some body-change updates
- **Other models**: untested, results may vary

If body-only detection matters for your workflow, use Sonnet or higher.

## Installation

### Claude Code

```bash
npx skills add your-org/doc-coauthoring
```

Or manual installation:

```bash
mkdir -p ~/.claude/skills
cp -r doc-coauthoring ~/.claude/skills/
```

Invoke with:
```
/doc-coauthoring --dry-run       # preview changes (default)
/doc-coauthoring --apply         # write patches
/doc-coauthoring --apply HEAD~3  # specify commit range
```

### Cursor

```bash
# Option 1: Use the conversion script
cd doc-coauthoring
./scripts/convert.sh /path/to/your/project
# Creates .cursorrules in your project

# Option 2: Manual
cp doc-coauthoring/.cursorrules /path/to/your/project/
```

### Windsurf / Codeium

```bash
# Option 1: Use the conversion script
cd doc-coauthoring
./scripts/convert.sh /path/to/your/project
# Creates .windsurfrules in your project

# Option 2: Copy SKILL.md to workflows
cp -r doc-coauthoring ~/.codeium/windsurf/skills/
```

### GitHub Copilot (VS Code)

```bash
mkdir -p .github/copilot
cp doc-coauthoring/SKILL.md .github/copilot/doc-coauthoring.md
```

### Gemini CLI

```bash
mkdir -p ~/.gemini/skills
cp -r doc-coauthoring ~/.gemini/skills/
```

### OpenAI Codex CLI

```bash
mkdir -p ~/.codex/skills
cp -r doc-coauthoring ~/.codex/skills/
```

### Goose (Block)

```bash
mkdir -p ~/.config/goose/skills
cp -r doc-coauthoring ~/.config/goose/skills/
```

### Roo Code

```bash
mkdir -p .roo/skills
cp -r doc-coauthoring .roo/skills/
```

### Trae

```bash
mkdir -p .trae/skills
cp -r doc-coauthoring .trae/skills/
```

### Amp

```bash
mkdir -p .amp/skills
cp -r doc-coauthoring .amp/skills/
```

### Generic AGENTS.md

Add to your `AGENTS.md`:

```markdown
## Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| [doc-coauthoring](./doc-coauthoring/SKILL.md) | `/doc-sync`, after API changes | Updates docstrings and fenced README sections |
```

## Fence Markers Quickstart

Fence markers define machine-managed territory in your documentation:

```markdown
## API Reference

Human-written introduction here. NOT touched by the skill.

<!-- doc-sync: start -->
| Function | Parameters | Returns |
|----------|------------|---------|
| `parse(text: str)` | text: Input string | dict |
| `validate(data: dict)` | data: Data to validate | bool |
<!-- doc-sync: end -->

Human-written notes here. NOT touched by the skill.
```

**Rules:**
1. Content inside fences = machine-managed (will be updated)
2. Content outside fences = human-owned (never touched)
3. No fences = skill reports and stops (does not insert fences)

See `references/fence-format.md` for full specification.

## Usage

### After Making Code Changes

```bash
# 1. (Optional) Run the diff script directly to see what changed
bash doc-coauthoring/scripts/get_diff.sh
# Default: all tracked uncommitted changes (staged + unstaged vs HEAD)
# Or specify a range: HEAD~3..HEAD

# 2. Preview what the skill would update (no file writes)
/doc-coauthoring --dry-run

# 3. Review the report, then apply
/doc-coauthoring --apply
```

### Pre-validation (automatic)

Before writing to any markdown file, the skill runs:

```bash
bash doc-coauthoring/scripts/check-fences.sh path/to/README.md
```

If fence markers are missing or malformed, it stops for that file and reports.
This enforces the preservation contract mechanically — not just via prompt.

### Example: Before and After

**Code change:**
```diff
- def fetch_user(user_id: int) -> User:
+ def fetch_user(user_id: int, include_profile: bool = False) -> User:
```

**Docstring update:**
```diff
  def fetch_user(user_id: int, include_profile: bool = False) -> User:
      """Fetch a user by ID.
      
      Args:
          user_id: The user's unique identifier.
+         include_profile: Whether to include profile data. Defaults to False.
          
      Returns:
          User object.
      """
```

**README update (inside fences):**
```diff
  <!-- doc-sync: start -->
  | Function | Parameters | Returns |
  |----------|------------|---------|
- | `fetch_user(user_id)` | user_id: int | User |
+ | `fetch_user(user_id, include_profile=False)` | user_id: int, include_profile: bool | User |
  <!-- doc-sync: end -->
```

### Example: Removed Symbol

```bash
# Skill output:
## Flagged for Human Review
- `deprecated_function` — symbol removed from codebase
  Documentation preserved. Please review and remove manually if appropriate.
```

The skill never deletes documentation. Removal requires human confirmation.

## Test Cases

The skill is designed to pass these scenarios:

| Scenario | Expected Behavior |
|----------|-------------------|
| Added parameter | Updates docstring + fenced README row |
| Pure internal refactor | Reports "no contract changes", does nothing |
| Private method signature changed | Detects and updates docstring (in scope by documented-symbol rule) |
| Removed symbol (any visibility) | Flags `[NEEDS HUMAN REVIEW]`, preserves docs |
| Missing fence markers | `check-fences.sh` fails → reports and skips file |
| No existing documentation | Reports "missing coverage", does not create |
| User runs without `--apply` | Dry-run only — no files written, report shown |

## File Structure

```
doc-coauthoring/
├── SKILL.md                   # Lean router (~200 tokens)
├── PRESERVATION.md            # Public social contract
├── README.md                  # This file
├── scripts/
│   ├── get_diff.sh            # Git diff → changed documented symbols
│   ├── check-fences.sh        # Pre-validate fence markers before any Edit
│   └── convert.sh             # SKILL.md → Cursor/Windsurf formats
└── references/
    ├── workflow-steps.md      # Detailed execution steps (lazy-loaded)
    ├── scope-bounds.md        # What the skill will NOT touch
    ├── fence-format.md        # Fence marker specification
    └── verify-steps.md        # 3-point verification checklist
```

**Architecture note**: `SKILL.md` is a lean router (~200 tokens). Heavy content
lives in `references/` and is lazy-loaded by the agent only when needed. This
preserves context window space for other installed skills (progressive disclosure).

## Philosophy

> Documentation co-authorship is a negotiated boundary: machines maintain
> what they can verify (signatures, types, parameter lists), humans maintain
> what requires judgment (explanations, examples, warnings). The fence marker
> is the contract line — enforced mechanically, not just by instruction. Cross
> it, and trust is broken. Respect it, and documentation stays accurate without
> losing its voice. Scope is defined not by visibility but by whether documentation
> already exists: if it was documented, it deserves to stay accurate.

## Contributing

1. This skill follows the [Agent Skills open standard](https://agentskills.io)
2. All changes must preserve the conservative philosophy
3. New features that expand scope will be rejected
4. Bug fixes that improve accuracy are welcome

## License

MIT
