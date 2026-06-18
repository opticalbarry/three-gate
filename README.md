# three-gate marketplace

A Claude Code / Cowork plugin that forces every substantive task through a
three-stage review pipeline:

1. **executor** — builds the deliverable, records sources + assumptions
2. **verifier** — checks for hallucinations, sources, bugs; PASS/FAIL
3. **executive** — final judgment: is there a better/more efficient approach?

A `UserPromptSubmit` hook injects the policy every turn; a `Stop` hook blocks
finishing until all three gates ran. This is the enforcement a skill alone
can't guarantee.

## Install (Claude Code)

```
/plugin marketplace add YOUR_GH_USERNAME/three-gate
/plugin install three-gate-review@three-gate
```

Restart, then verify:

```
/agents          # should list executor, verifier, executive
/gate <task>     # manually run the pipeline on a task
```

## Repo layout

```
.claude-plugin/marketplace.json          <- marketplace catalog (repo root)
plugins/three-gate-review/
  .claude-plugin/plugin.json             <- plugin manifest
  agents/{executor,verifier,executive}.md
  skills/three-gate-pipeline/SKILL.md
  hooks/{hooks.json,inject_mandate.sh,check_gates.sh}
  commands/gate.md
```

## Cost note

Three agents ≈ 3x token usage per gated task. The skill auto-skips trivial
requests. Tune by setting verifier/executive `model: sonnet` in their agent
files if cost matters more than maximum rigor.
