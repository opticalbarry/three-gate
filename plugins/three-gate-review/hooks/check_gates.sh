#!/usr/bin/env bash
# Stop hook: fires when Claude tries to finish its turn.
# It inspects the transcript for evidence that all three subagents ran. If a
# deliverable was produced but a gate is missing, it blocks the stop and tells
# Claude to finish the pipeline. This is the teeth behind the policy.
#
# Input arrives as JSON on stdin with a "transcript_path" field.
# Exit code 2 = block the stop and feed "reason" back to Claude.

input=$(cat)
transcript=$(printf '%s' "$input" | grep -o '"transcript_path"[^,}]*' | sed 's/.*: *"//; s/"$//')

# If we can't read the transcript, don't block (fail open).
[ -z "$transcript" ] || [ ! -f "$transcript" ] && exit 0

body=$(cat "$transcript" 2>/dev/null)

# Heuristic: did this turn produce a deliverable worth gating?
# (subagent invocations are logged with the agent name)
echo "$body" | grep -qi 'executor'  && saw_exec=1
echo "$body" | grep -qi 'verifier'  && saw_verif=1
echo "$body" | grep -qi 'executive' && saw_ex010=1

# If none of the agents were used at all, assume trivial turn -> allow.
if [ -z "$saw_exec$saw_verif$saw_ex010" ]; then
  exit 0
fi

missing=""
[ -z "$saw_exec" ]  && missing="$missing executor"
[ -z "$saw_verif" ] && missing="$missing verifier"
[ -z "$saw_ex010" ] && missing="$missing executive"

if [ -n "$missing" ]; then
  reason="Three-gate policy not satisfied. Missing stage(s):$missing. Run the remaining subagent(s) before finishing."
  printf '{"decision":"block","reason":%s}\n' "$(printf '%s' "$reason" | python3 -c 'import json,sys;print(json.dumps(sys.stdin.read()))')"
  exit 0
fi

exit 0
