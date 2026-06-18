#!/usr/bin/env bash
# UserPromptSubmit hook: prepends a non-negotiable instruction to every prompt.
# This is the "always on" enforcement that a skill alone cannot guarantee,
# because skills self-trigger only ~20% of the time but a hook runs every turn.

cat <<'EOF'
[THREE-GATE POLICY — injected by hook, not optional]
Before treating ANY deliverable as done (code, document, analysis, numbers, or
a factually-grounded answer), you MUST run the three-gate-pipeline skill:
executor -> verifier -> executive. Do not produce a final deliverable in a
single pass. If the request is genuinely trivial (greeting, one quick fact,
pure opinion), you may answer directly AND state "(trivial — gates skipped)".
EOF
