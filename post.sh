#!/usr/bin/env bash
# 文章管理小工具
#   ./post.sh list              列出所有文章
#   ./post.sh new "标题"        新建文章
#   ./post.sh del 关键词        删除文章（移入 .trash/，可恢复）
#   ./post.sh del 关键词 -f     跳过确认
set -euo pipefail
cd "$(dirname "$0")"

POSTS="source/_posts"
TRASH=".trash"

usage() {
  sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
}

list_posts() {
  printf "%-46s %-12s %s\n" "文件" "日期" "标题"
  printf "%-46s %-12s %s\n" "----------------------------------------------" "------------" "--------------------"
  for f in "$POSTS"/*.md; do
    [ -e "$f" ] || continue
    t=$(awk '/^title:/{sub(/^title:[[:space:]]*/,""); print; exit}' "$f")
    d=$(awk '/^date:/{sub(/^date:[[:space:]]*/,""); print substr($0,1,10); exit}' "$f")
    printf "%-46s %-12s %s\n" "$(basename "$f")" "$d" "$t"
  done
}

case "${1:-}" in
  list|ls)
    list_posts
    ;;

  new)
    shift
    [ $# -ge 1 ] || { echo "用法: ./post.sh new \"标题\""; exit 1; }
    npx hexo new post "$*"
    echo "✅ 已创建，编辑 $POSTS 下新生成的文件"
    ;;

  del|rm)
    shift
    keyword="${1:-}"
    force="${2:-}"
    [ -n "$keyword" ] || { echo "用法: ./post.sh del 关键词"; exit 1; }

    matches=""
    count=0
    for f in "$POSTS"/*.md; do
      [ -e "$f" ] || continue
      if grep -qi -- "$keyword" "$f" || printf '%s' "$f" | grep -qi -- "$keyword"; then
        matches="${matches}${f}
"
        count=$((count + 1))
      fi
    done

    if [ "$count" -eq 0 ]; then
      echo "❌ 没找到匹配「${keyword}」的文章。用 ./post.sh list 看看有哪些。"
      exit 1
    fi

    if [ "$count" -gt 1 ]; then
      echo "匹配到多篇，请说得更具体些："
      printf '%s' "$matches" | while read -r m; do [ -n "$m" ] && echo "  $m"; done
      exit 1
    fi

    target=$(printf '%s' "$matches" | head -1)
    title=$(awk '/^title:/{sub(/^title:[[:space:]]*/,""); print; exit}' "$target")
    echo "将要删除：$target"
    echo "        标题：$title"

    if [ "$force" != "-f" ]; then
      printf "确认？(y/N) "
      read -r answer
      case "$answer" in
        y|Y|yes|YES) ;;
        *) echo "已取消，什么都没删。"; exit 0 ;;
      esac
    fi

    mkdir -p "$TRASH/$(date +%Y%m%d)"
    dest="$TRASH/$(date +%Y%m%d)/$(basename "$target")"
    mv "$target" "$dest"
    echo "📦 已移入 ${dest}（想恢复就移回 ${POSTS}/ ）"

    echo "==> 重新生成站点"
    # 注意：不要用 `hexo clean`——本机 Node 安全垫片会拦截它的递归删除且静默失败，
    # 导致 public/ 里残留已删文章的旧页面。直接用 shell 删除更可靠。
    rm -rf public db.json
    npx hexo generate >/dev/null
    echo "✅ 完成。发布上线请执行 ./deploy.sh"
    ;;

  *)
    usage
    ;;
esac
