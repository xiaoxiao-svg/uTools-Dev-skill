#!/usr/bin/env bash
# 生成 references/uTools-Dev-Doc.md 顶部的"符号索引"（全部 ##/###/#### 标题 → 起始行号）。
# 索引保证与文档标题一一对应（生成式校验），行号随文档编辑由本脚本刷新。
#
# 用法：
#   bash scripts/build-symbol-index.sh          # 重新生成索引并写回文档
#   bash scripts/build-symbol-index.sh --check  # 仅校验索引是否最新；过期或缺失时退出码 1
set -euo pipefail

DOC="references/uTools-Dev-Doc.md"
START="<!-- SYMBOL-INDEX:START -->"
END="<!-- SYMBOL-INDEX:END -->"
MODE="${1:-build}"

cd "$(dirname "$0")/.."
[ -f "$DOC" ] || { echo "错误：找不到 $DOC" >&2; exit 2; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# 读入时归一化为 LF；写回时按原始行尾还原
if head -c 4000 "$DOC" | grep -q $'\r'; then CRLF=1; else CRLF=0; fi
tr -d '\r' < "$DOC" > "$TMP/src.md"

# 拆分 prefix（索引之前）/ body（索引之后或全文）
if grep -qF "$START" "$TMP/src.md"; then
  sline=$(grep -nF "$START" "$TMP/src.md" | head -1 | cut -d: -f1)
  eline=$(grep -nF "$END" "$TMP/src.md" | head -1 | cut -d: -f1)
  [ "$eline" -gt "$sline" ] || { echo "错误：索引标记顺序异常" >&2; exit 2; }
  sed -n "1,$((sline-1))p" "$TMP/src.md" > "$TMP/prefix.md"
  sed -n "$((eline+1)),\$p" "$TMP/src.md" > "$TMP/body.md"
else
  if [ "$MODE" = "--check" ]; then
    echo "索引缺失：$DOC 中未找到符号索引标记，运行 bash scripts/build-symbol-index.sh 生成" >&2
    exit 1
  fi
  first_h2=$(grep -n "^## " "$TMP/src.md" | head -1 | cut -d: -f1)
  [ -n "$first_h2" ] || { echo "错误：文档中未找到任何 ## 标题作为插入点" >&2; exit 2; }
  sed -n "1,$((first_h2-1))p" "$TMP/src.md" > "$TMP/prefix.md"
  sed -n "${first_h2},\$p" "$TMP/src.md" > "$TMP/body.md"
fi

# 提取标题：local_line \t level \t title
grep -nE "^#{2,4} " "$TMP/body.md" | awk -F: '
  {
    line = $1
    head = substr($0, index($0, ":") + 1)
    match(head, /^#+/)
    lvl = RLENGTH
    title = substr(head, RLENGTH + 1)
    sub(/^ +/, "", title)
    gsub(/\|/, "\\|", title)
    print line "\t" lvl "\t" title
  }
' > "$TMP/headings.tsv"
[ -s "$TMP/headings.tsv" ] || { echo "错误：未提取到任何标题" >&2; exit 2; }

# 索引表头（行数固定）
cat > "$TMP/block-head.md" <<'EOF'
<!-- SYMBOL-INDEX:START -->
<!-- 本区块由 scripts/build-symbol-index.sh 自动生成，请勿手改；编辑本文档后重新运行脚本刷新行号 -->

## 0. 符号索引

查询某 API / 主题是否收录于本文档，**先查本表**，不要直接对全文做关键词检索：

- **命中** → 从"起始行"读起，读到下一行条目之前，即该条目的完整内容；禁止只读半节就下结论
- **未命中** → 不得直接宣布"不存在"：先换关键词（符号名 + 功能同义词）检索，再浏览所属大类章节；仍无才可表述为"本地参考文档未收录"（完整规则见 SKILL.md"查证完成判定"）

| 起始行 | 条目 |
|---|---|
EOF

build_rows() { # $1 = 正文首行在最终文件中的绝对行号 - 1
  awk -F'\t' -v off="$1" '
    {
      line = $1 + off; lvl = $2; title = $3
      if (lvl == 2) { sec = "" ; print "| " line " | " title " |" }
      else if (lvl == 3) { sec = title; sub(/ .*/, "", sec); print "| " line " | " title " |" }
      else if (sec != "") { print "| " line " | " sec " · " title " |" }
      else { print "| " line " | " title " |" }
    }
  ' "$TMP/headings.tsv"
}

# 迭代收敛：索引块自身的行数会影响其后所有标题的绝对行号
prefix_lines=$(wc -l < "$TMP/prefix.md")
head_lines=$(wc -l < "$TMP/block-head.md")
offset=0
for _ in 1 2 3; do
  build_rows "$offset" > "$TMP/rows.md"
  block_lines=$((head_lines + $(wc -l < "$TMP/rows.md") + 2))   # 表头 + 数据行 + 空行 + END 标记
  new_offset=$((prefix_lines + block_lines))
  if [ "$new_offset" -eq "$offset" ]; then break; fi
  offset=$new_offset
done

{ cat "$TMP/prefix.md"; cat "$TMP/block-head.md"; cat "$TMP/rows.md"; printf '\n%s\n' "$END"; cat "$TMP/body.md"; } > "$TMP/out.md"
if [ "$CRLF" -eq 1 ]; then sed 's/$/\r/' "$TMP/out.md" > "$TMP/out-crlf.md"; mv "$TMP/out-crlf.md" "$TMP/out.md"; fi

if [ "$MODE" = "--check" ]; then
  if cmp -s "$TMP/out.md" "$DOC"; then
    echo "符号索引校验通过（$(wc -l < "$TMP/rows.md") 个条目）"
  else
    echo "符号索引已过期：文档标题或行号与索引不一致，运行 bash scripts/build-symbol-index.sh 刷新" >&2
    diff <(tr -d '\r' < "$DOC") "$TMP/out.md" | head -20 >&2 || true
    exit 1
  fi
else
  cp "$TMP/out.md" "$DOC"
  echo "已生成符号索引：$(wc -l < "$TMP/rows.md") 个条目，写入 $DOC"
fi
