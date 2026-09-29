#!/usr/bin/env bash
# PostToolUse (Edit|Write): format the edited Dart file, then analyze it.
# - lib/ code: analyzer issues exit 2 so they are fed back to Claude to fix.
# - test code: issues are reported without blocking, because undefined
#   symbols there are the expected TDD "red" step, not something to silence.
export PATH="/opt/homebrew/bin:$PATH"

f=$(jq -r '.tool_response.filePath // .tool_input.file_path // empty')
[[ "$f" == *.dart && -f "$f" ]] || exit 0

# Generated code (freezed / json_serializable) is not ours to format or lint.
[[ "$f" == *.g.dart || "$f" == *.freezed.dart ]] && exit 0

cd "${CLAUDE_PROJECT_DIR:-$(dirname "$f")}" || exit 0

dart format "$f" >/dev/null

out=$(dart analyze "$f" 2>&1) && exit 0

case "$f" in
  */test/*|*/integration_test/*|*/testing/*)
    msg="TDD red step — analyzer issues in test file $f are expected while the production code doesn't exist yet. Next: run the test, confirm it fails for the right reason, then write the MINIMUM code in lib/ to make it pass. Do not change or delete the test to silence these:
$out"
    jq -n --arg m "$msg" \
      '{hookSpecificOutput: {hookEventName: "PostToolUse", additionalContext: $m}}'
    exit 0
    ;;
esac

echo "dart analyze reported issues in $f — fix them before continuing:" >&2
echo "$out" >&2
exit 2
