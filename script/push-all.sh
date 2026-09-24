#!/usr/bin/env bash
# 一次性把本仓库推送到 GitHub / Gitee / GitCode 等多个代码平台。
#
# 用法：
#   bash script/push-all.sh <仓库URL> [仓库URL ...]
#
# 示例：
#   bash script/push-all.sh \
#     https://github.com/<用户名>/java-backend-standard.git \
#     https://gitee.com/<用户名>/java-backend-standard.git \
#     https://gitcode.com/<用户名>/java-backend-standard.git
#
# 说明：
#   - 远端名称按域名自动识别（github / gitee / gitcode），识别不出则用 remote1、remote2…
#   - 远端已存在时自动更新地址，可反复执行。
#   - 假设三个平台都已创建**空仓库**（不要勾选自动生成 README，以免首次推送冲突）。
#
# 后续单独推送：
#   git push github main
#   git push gitee  main
#   git push gitcode main

set -euo pipefail

BRANCH="${PUSH_BRANCH:-main}"

usage() {
  cat <<'EOF'
用法：bash script/push-all.sh <仓库URL> [仓库URL ...]

示例：
  bash script/push-all.sh \
    https://github.com/用户名/java-backend-standard.git \
    https://gitee.com/用户名/java-backend-standard.git \
    https://gitcode.com/用户名/java-backend-standard.git

可先用环境变量指定分支（默认 main）：
  PUSH_BRANCH=master bash script/push-all.sh <URL...>
EOF
}

remote_name_for() {
  local url="$1"
  case "$url" in
    *github.com*)  echo "github" ;;
    *gitee.com*)   echo "gitee" ;;
    *gitcode.com*|*gitcode.net*) echo "gitcode" ;;
    *) echo "" ;;
  esac
}

if [ "$#" -eq 0 ] || [ "${1-}" = "-h" ] || [ "${1-}" = "--help" ]; then
  usage
  exit 0
fi

if [ ! -d .git ]; then
  echo "错误：当前目录不是 git 仓库，请先执行 git init。" >&2
  exit 1
fi

if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  echo "错误：还没有任何提交，请先 git add . && git commit。" >&2
  exit 1
fi

idx=0
for url in "$@"; do
  idx=$((idx + 1))

  name="$(remote_name_for "$url")"
  if [ -z "$name" ]; then
    name="remote${idx}"
    echo "提示：无法识别域名，使用远端名 ${name}"
  fi

  if git remote get-url "$name" >/dev/null 2>&1; then
    git remote set-url "$name" "$url"
    echo "[${name}] 已更新地址 -> ${url}"
  else
    git remote add "$name" "$url"
    echo "[${name}] 已添加远端 -> ${url}"
  fi

  echo "[${name}] 推送 ${BRANCH} ..."
  if git push -u "$name" "HEAD:${BRANCH}"; then
    echo "[${name}] ✅ 推送成功"
  else
    echo "[${name}] ❌ 推送失败，请检查：仓库是否已创建、账号是否已登录、是否有推送权限" >&2
  fi
  echo
done

echo "=== 当前远端列表 ==="
git remote -v
