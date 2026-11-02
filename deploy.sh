#!/usr/bin/env bash
# 一键发布：建仓（首次）→ 推送源码到 source 分支 → 发布静态站点到 main 分支 → 开启 Pages
#
# 用法：
#   GITHUB_TOKEN=ghp_xxx ./deploy.sh          # 用 Token（首次会自动建仓）
#   ./deploy.sh                                # 用 SSH 密钥（需先在 GitHub 添加公钥）
set -euo pipefail
cd "$(dirname "$0")"

OWNER="natsumxd"
REPO="natsumxd.github.io"
API="https://api.github.com"

if [ -n "${GITHUB_TOKEN:-}" ]; then
  PUSH_URL="https://x-access-token:${GITHUB_TOKEN}@github.com/${OWNER}/${REPO}.git"
  AUTH=(-H "Authorization: Bearer ${GITHUB_TOKEN}" -H "Accept: application/vnd.github+json")
else
  PUSH_URL="git@github.com:${OWNER}/${REPO}.git"
  AUTH=()
fi

# 推送分支。本机若有只放行 API 域名的强制代理，直连会被拒（CONNECT tunnel/502），
# 这里自动降级为「绕过代理直连」并重试，最多 3 轮。
push_ref() {
  local ref="$1" attempt errfile
  errfile=$(mktemp)
  for attempt in 1 2 3; do
    if git -c http.version=HTTP/1.1 push -f "$PUSH_URL" "$ref" 2>"$errfile"; then
      rm -f "$errfile"; return 0
    fi
    if grep -qiE "CONNECT tunnel|Couldn't connect|Failed to connect|Empty reply|timed out" "$errfile"; then
      echo "    网络受限，改为绕过代理直连（第 $attempt 次）…"
      if env -u HTTP_PROXY -u HTTPS_PROXY -u http_proxy -u https_proxy -u ALL_PROXY \
           git -c http.version=HTTP/1.1 push -f "$PUSH_URL" "$ref" 2>"$errfile"; then
        rm -f "$errfile"; return 0
      fi
    else
      cat "$errfile" >&2; rm -f "$errfile"; return 1
    fi
    sleep 3
  done
  echo "    ❌ 推送失败："
  cat "$errfile" >&2
  rm -f "$errfile"
  return 1
}

echo "==> 1/6 清理临时文件"
rm -f 5qtf8hzu _config.landscape.yml .git/HEAD.lock 2>/dev/null || true
rm -rf .github .deploy_tmp 2>/dev/null || true

echo "==> 2/6 构建站点"
# 先物理清掉旧产物：`hexo clean` 在本机会被 Node 安全垫片拦截且静默失败，
# 一旦残留旧页面，会让已删除的文章继续挂在线上。
rm -rf public db.json
npx hexo generate

if [ -n "${GITHUB_TOKEN:-}" ]; then
  echo "==> 3/6 确认仓库存在"
  code=$(curl -sS --http1.1 -o /dev/null -w '%{http_code}' "${AUTH[@]}" "$API/repos/$OWNER/$REPO" || echo "000")
  if [ "$code" = "404" ]; then
    curl -sS --http1.1 -X POST "${AUTH[@]}" "$API/user/repos" \
      -d "{\"name\":\"$REPO\",\"private\":false,\"description\":\"个人博客\",\"auto_init\":false}" >/dev/null
    echo "    已创建仓库 $OWNER/$REPO"
  elif [ "$code" = "200" ]; then
    echo "    仓库已存在"
  else
    echo "    ⚠️  无法确认仓库状态（HTTP $code），继续尝试推送"
  fi
else
  echo "==> 3/6 跳过建仓（SSH 模式，请先在网页上创建空仓库 $REPO）"
fi

echo "==> 4/6 提交源码到 source 分支"
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  rm -rf .git
  git init -q
fi
git config user.name "natsumxd"
git config user.email "$(git config --global user.email || echo 'natsumxd@users.noreply.github.com')"
git add -A
git -c commit.gpgsign=false commit -q -m "source: $(date '+%Y-%m-%d %H:%M')" || echo "    （无变更）"
push_ref HEAD:source

echo "==> 5/6 发布静态站点到 main 分支"
rm -rf .deploy_tmp
mkdir -p .deploy_tmp
cp -R public/. .deploy_tmp/
touch .deploy_tmp/.nojekyll
pushd .deploy_tmp >/dev/null
git init -q
git config user.name "natsumxd"
git config user.email "natsumxd@users.noreply.github.com"
git add -A
git -c commit.gpgsign=false commit -q -m "deploy: $(date '+%Y-%m-%d %H:%M')"
push_ref HEAD:main
popd >/dev/null
rm -rf .deploy_tmp

if [ -n "${GITHUB_TOKEN:-}" ]; then
  echo "==> 6/6 开启 GitHub Pages"
  curl -sS --http1.1 -X POST "${AUTH[@]}" "$API/repos/$OWNER/$REPO/pages" \
    -d '{"source":{"branch":"main","path":"/"}}' >/dev/null 2>&1 || true
  curl -sS --http1.1 -X PUT "${AUTH[@]}" "$API/repos/$OWNER/$REPO/pages" \
    -d '{"source":{"branch":"main","path":"/"}}' >/dev/null 2>&1 || true
  curl -sS --http1.1 -X POST "${AUTH[@]}" "$API/repos/$OWNER/$REPO/pages/builds" >/dev/null 2>&1 || true
  echo "    Pages 已配置为 main 分支根目录"
else
  echo "==> 6/6 请到仓库 Settings → Pages 确认来源为 main / root"
fi

echo ""
echo "✅ 发布完成。1–2 分钟后访问 https://${OWNER}.github.io"
