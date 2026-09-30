#!/usr/bin/env bash
# Stop: if Dart code or pubspec changed since the last commit, run the full
# analyzer and test suite. Failures exit 2 so Claude keeps working on them
# instead of finishing with a broken tree.
#
# Files tagged `@Tags(['wip'])` hold the in-progress roadmap step's
# acceptance tests (red on purpose, possibly not even compiling yet): their
# tests are excluded and their analyzer issues ignored, and a non-blocking
# reminder lists them. Every other issue or failure still blocks.
export PATH="/opt/homebrew/bin:$PATH"

input=$(cat)
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0

changed=$(git status --porcelain -- '*.dart' pubspec.yaml analysis_options.yaml 2>/dev/null)
[[ -z "$changed" ]] && exit 0

wip_files=$(grep -rlE "@Tags\(\[[^]]*'wip'" test integration_test 2>/dev/null)

analyze=$(flutter analyze 2>&1)
issues=$(echo "$analyze" | grep ' • ')
for f in $wip_files; do
  issues=$(echo "$issues" | grep -vF " • $f:")
done
issues=$(echo "$issues" | sed '/^$/d')

if [[ -n "$issues" ]]; then
  fail="flutter analyze failed:
$issues"
elif ! tests=$(flutter test --exclude-tags wip 2>&1); then
  fail="flutter test failed:
$(echo "$tests" | tail -60)"
fi

if [[ -z "$fail" ]]; then
  if [[ -n "$wip_files" ]]; then
    jq -n --arg m "Work in progress — tagged wip (excluded from this check; the step isn't done until they pass untagged): $(echo $wip_files)" \
      '{systemMessage: $m}'
  fi
  exit 0
fi

# Already blocked once this turn: don't loop forever, surface it to the user instead.
if [[ $(echo "$input" | jq -r '.stop_hook_active // false') == "true" ]]; then
  jq -n --arg m "Verification still failing after a retry — see flutter analyze / flutter test output." \
    '{systemMessage: $m}'
  exit 0
fi

echo "$fail" >&2
exit 2
