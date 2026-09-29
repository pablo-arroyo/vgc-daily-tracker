#!/usr/bin/env bash
# Stop: if Dart code or pubspec changed since the last commit, run the full
# analyzer and test suite. Failures exit 2 so Claude keeps working on them
# instead of finishing with a broken tree.
export PATH="/opt/homebrew/bin:$PATH"

input=$(cat)
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

changed=$(git status --porcelain -- '*.dart' pubspec.yaml analysis_options.yaml 2>/dev/null)
[[ -z "$changed" ]] && exit 0

if ! analyze=$(flutter analyze 2>&1); then
  fail="flutter analyze failed:
$analyze"
elif ! tests=$(flutter test 2>&1); then
  fail="flutter test failed:
$(echo "$tests" | tail -60)"
fi

[[ -z "$fail" ]] && exit 0

# Already blocked once this turn: don't loop forever, surface it to the user instead.
if [[ $(echo "$input" | jq -r '.stop_hook_active // false') == "true" ]]; then
  jq -n --arg m "Verification still failing after a retry — see flutter analyze / flutter test output." \
    '{systemMessage: $m}'
  exit 0
fi

echo "$fail" >&2
exit 2
