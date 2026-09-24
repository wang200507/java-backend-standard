#!/usr/bin/env bash
# Distribute the rule text from AGENTS.md to each IDE's rule target, and refresh
# the manual copies inside the skill package.
#
# Usage:
#   bash script/sync-agent-rules.sh                      repo-local targets only (English rules)
#   bash script/sync-agent-rules.sh --global             also write user-level global targets
#   bash script/sync-agent-rules.sh --lang zh            distribute the Chinese rules instead
#   bash script/sync-agent-rules.sh --global --lang zh   combine both
#
# Maintenance: edit AGENTS.md (condensed rules) and docs/java-backend-standard.md (full manual),
#              then run this script. Never edit the generated rule files directly -- the next
#              sync overwrites them.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

LANG_MODE="en"
GLOBAL=0
while [ $# -gt 0 ]; do
  case "$1" in
    --global) GLOBAL=1; shift ;;
    --lang)   [ $# -ge 2 ] || { echo "error: --lang requires a value (en|zh)" >&2; exit 1; }
              LANG_MODE="$2"; shift 2 ;;
    --lang=*) LANG_MODE="${1#--lang=}"; shift ;;
    *) echo "unknown argument: $1" >&2; exit 1 ;;
  esac
done

case "$LANG_MODE" in
  zh|zh-CN|zh_CN|cn) LANG_MODE="zh" ;;
  en|en-US|en_US)    LANG_MODE="en" ;;
  *) echo "unsupported language: $LANG_MODE (use en or zh)" >&2; exit 1 ;;
esac

if [ "$LANG_MODE" = "zh" ]; then
  SRC="$ROOT/AGENTS.zh-CN.md"
  DESC='通用 Java 后端开发规范（JDK 17/21 + Spring Boot 3.x + MyBatis-Plus）。编写、评审、重构、生成 Java 后端代码时遵循，含 JDK 17→21 与 Spring Boot 2.7→3.x 迁移要点。'
else
  SRC="$ROOT/AGENTS.md"
  DESC='General Java backend development standard (JDK 17/21 + Spring Boot 3.x + MyBatis-Plus). Follow when writing, reviewing, refactoring or generating Java backend code; includes JDK 17-21 and Spring Boot 2.7-3.x migration guidance.'
fi

SKILL_DIR="$ROOT/skills/java-backend-standard"

if [ ! -f "$SRC" ]; then
  echo "error: cannot find $SRC" >&2
  exit 1
fi

# Trae / Cursor share the same frontmatter fields
fm_rule="---
description: ${DESC}
alwaysApply: true
---
"

# Claude Code / WorkBuddy skill format
fm_skill="---
name: java-backend-standard
description: ${DESC}
agent_created: true
---
"

emit() {
  local target="$1"
  local fm="${2-}"
  mkdir -p "$(dirname "$target")"
  if [ -n "$fm" ]; then
    printf '%s\n' "$fm" > "$target"
  else
    : > "$target"
  fi
  cat "$SRC" >> "$target"
  echo "  -> ${target}"
}

copy_manuals() {
  local dest="$1"
  mkdir -p "$dest"
  for m in "$ROOT/docs/java-backend-standard.md" "$ROOT/docs/java-backend-standard.zh-CN.md"; do
    if [ -f "$m" ]; then
      cp "$m" "$dest/$(basename "$m")"
      echo "  -> $dest/$(basename "$m")"
    fi
  done
}

echo "source: $(basename "$SRC")  (lang=${LANG_MODE})"

echo "[repo-local targets]"
emit "$ROOT/.trae/rules/java-backend-standard.md"          "$fm_rule"
emit "$ROOT/.cursor/rules/java-backend-standard.mdc"       "$fm_rule"
emit "$ROOT/.aiassistant/rules/java-backend-standard.md"   ""
emit "$ROOT/.github/copilot-instructions.md"               ""

# Always mirror BOTH language editions of the manual into the skill package.
copy_manuals "$SKILL_DIR/references"

if [ "$GLOBAL" = "1" ]; then
  echo "[user-level global targets]"
  emit "$HOME/.trae/user_rules/java-backend-standard.md"     "$fm_rule"
  emit "$HOME/.claude/skills/java-backend-standard/SKILL.md" "$fm_skill"

  copy_manuals "$HOME/.claude/skills/java-backend-standard/references"
  copy_manuals "$HOME/.workbuddy/skills/java-backend-standard/references"
fi

echo "done."
