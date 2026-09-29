#!/usr/bin/env bash
# PostToolUse (Edit|Write): format the edited Dart file, then analyze it.
# Analyzer issues exit 2 so they are fed back to Claude to fix immediately.
export PATH="/opt/homebrew/bin:$PATH"

f=$(jq -r '.tool_response.filePath // .tool_input.file_path // empty')
[[ "$f" == *.dart && -f "$f" ]] || exit 0

# Generated code (freezed / json_serializable) is not ours to format or lint.
[[ "$f" == *.g.dart || "$f" == *.freezed.dart ]] && exit 0

cd "${CLAUDE_PROJECT_DIR:-$(dirname "$f")}" || exit 0

dart format "$f" >/dev/null

if ! out=$(dart analyze "$f" 2>&1); then
  echo "dart analyze reported issues in $f — fix them before continuing:" >&2
  echo "$out" >&2
  exit 2
fi
