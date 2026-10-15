#!/usr/bin/env bash
# 把 ai-tutor skill 全局装进 Claude Code（以及读 ~/.agents/skills 的 Agent，如 Codex）。
#
#   ./install.sh            装到 ~/.claude/skills 和 ~/.agents/skills
#   ./install.sh claude     只装到 ~/.claude/skills
#
# 装法是软链接：以后 git pull 更新这个文件夹，skill 自动跟着更新。
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$SRC_DIR/skill/ai-tutor"

case "${1:-all}" in
  claude) DIRS=("$HOME/.claude/skills") ;;
  all) DIRS=("$HOME/.claude/skills" "$HOME/.agents/skills") ;;
  -h|--help) sed -n '2,7p' "$0"; exit 0 ;;
  *) echo "用法：./install.sh [claude]" >&2; exit 1 ;;
esac

for dir in "${DIRS[@]}"; do
  link="$dir/ai-tutor"
  mkdir -p "$dir"
  if [[ -L "$link" && "$(readlink "$link")" == "$SKILL_SRC" ]]; then
    echo "· $link 已是最新"
  elif [[ -e "$link" || -L "$link" ]]; then
    echo "! $link 已存在且指向别处，跳过（请手动处理）" >&2
  else
    ln -s "$SKILL_SRC" "$link"
    echo "✓ $link → $SKILL_SRC"
  fi
done

cat <<'MSG'

装好了。打开 Agent 说"我想学 XX"或"教我 XX"就会启用。
注意：skill 是软链接，请不要移动或删除这个 ai-tutor 文件夹。
MSG
