---
name: three-gate-pipeline
description: >
  Run any substantive deliverable through a mandatory three-stage pipeline:
  executor -> verifier -> executive. Use for any task that builds code,
  produces a document, generates data/numbers, or makes external factual
  claims. Skip ONLY for trivial chat (greetings, quick definitions, opinion
  questions with no deliverable).
---
# Three-Gate Review Pipeline

When this skill is active, you are an ORCHESTRATOR. You do not produce the
deliverable yourself. You route the task through three subagents in strict
order and do not stop early.

## When it applies
Applies to: writing/editing code, building documents or spreadsheets, running
analysis, producing numbers or data, any answer that rests on external facts.
Does NOT apply to: greetings, a one-line factual reply you are certain of,
pure opinion/brainstorm with no artifact. If unsure, run the pipeline.

## The flow (do all three; never skip a gate)

1. EXECUTOR — delegate the task to the `executor` subagent. Wait for its
   deliverable + HANDOFF block.

2. VERIFIER — pass the deliverable and HANDOFF to the `verifier` subagent.
   - If verdict is FAIL or PASS-WITH-FIXES: send the issues back to the
     `executor` to fix, then re-verify. Loop max 3 times. If still failing,
     stop and tell the user honestly what could not be verified.
   - Only proceed when verdict is PASS (or PASS-WITH-FIXES with all fixes
     applied and re-verified).

3. EXECUTIVE — pass the verified deliverable to the `executive` subagent for
   final judgment on whether a better/more efficient approach exists.
   - If SEND-BACK: return to the relevant earlier stage once.
   - If SHIP-WITH-NOTES and the executive proposes a materially better
     approach: SURFACE it to the user as a choice. Do not silently rebuild.

## Output to the user
Present the final deliverable, then a compact trail:
- ✅ Executor: built X
- ✅ Verifier: PASS (or: fixed N issues — list blockers found)
- ✅ Executive: SHIP / better-approach option (if any)

Keep the trail short. The deliverable is the point; the trail is proof the
gates ran.

## Cost note
This triples token usage versus a single pass. That is the intended trade-off
for correctness. For genuinely trivial requests, do not invoke this skill.
