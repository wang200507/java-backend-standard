#!/usr/bin/env bash
# 把 AGENTS.md 的规则正文分发到各 IDE 的规则落点，并同步规范手册的副本。
#
# 用法：
#   bash script/sync-agent-rules.sh            只写本仓库内落点
#   bash script/sync-agent-rules.sh --global   额外写用户级全局落点（~/.trae、~/.claude、~/.workbuddy）
#
# 维护约定：只修改 AGENTS.md（精简规则）与 docs/java-backend-standard.md（完整手册），
#          然后运行本脚本。不要直接编辑生成出来的规则文件 —— 下次同步会被覆盖。

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/AGENTS.md"
MANUAL="$ROOT/docs/java-backend-standard.md"
SKILL_DIR="$ROOT/skills/java-backend-standard"

if [ ! -f "$SRC" ]; then
  echo "错误：找不到 $SRC" >&2
  exit 1
fi

DESC='通用 Java 后端开发规范（JDK 17/21 + Spring Boot 3.x + MyBatis-Plus）。编写、评审、重构、生成 Java 后端代码时遵循，含 JDK 17→21 与 Spring Boot 2.7→3.x 迁移要点。'

# Trae / Cursor 共用同一套 frontmatter 字段
fm_rule="---
description: ${DESC}
alwaysApply: true
---
"

# Claude Code / WorkBuddy 技能格式
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

echo "同步来源：AGENTS.md"

echo "[仓库内落点]"
emit "$ROOT/.trae/rules/java-backend-standard.md"          "$fm_rule"
emit "$ROOT/.cursor/rules/java-backend-standard.mdc"       "$fm_rule"
emit "$ROOT/.aiassistant/rules/java-backend-standard.md"   ""
emit "$ROOT/.github/copilot-instructions.md"               ""

if [ -f "$MANUAL" ]; then
  mkdir -p "$SKILL_DIR/references"
  cp "$MANUAL" "$SKILL_DIR/references/java-backend-standard.md"
  echo "  -> $SKILL_DIR/references/java-backend-standard.md"
fi

if [ "${1-}" = "--global" ]; then
  echo "[用户级全局落点]"
  emit "$HOME/.trae/user_rules/java-backend-standard.md"          "$fm_rule"
  emit "$HOME/.claude/skills/java-backend-standard/SKILL.md"      "$fm_skill"

  if [ -f "$MANUAL" ]; then
    mkdir -p "$HOME/.claude/skills/java-backend-standard/references"
    cp "$MANUAL" "$HOME/.claude/skills/java-backend-standard/references/java-backend-standard.md"
    echo "  -> $HOME/.claude/skills/java-backend-standard/references/java-backend-standard.md"

    mkdir -p "$HOME/.workbuddy/skills/java-backend-standard/references"
    cp "$MANUAL" "$HOME/.workbuddy/skills/java-backend-standard/references/java-backend-standard.md"
    echo "  -> $HOME/.workbuddy/skills/java-backend-standard/references/java-backend-standard.md"
  fi
fi

echo "完成。"
