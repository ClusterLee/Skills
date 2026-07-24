#!/usr/bin/env bash
# whiteprint · 脚手架：从模板生成一个自包含的 HTML 实例
# 用法:
#   new-deck.sh <目标目录>                 → 默认 deck 模式, 3:4 竖版(小红书)
#   new-deck.sh <目标目录> deck [3:4|16:9|1:1]
#   new-deck.sh <目标目录> webpage
set -euo pipefail
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="${1:?用法: new-deck.sh <目标目录> [deck|webpage] [3:4|16:9|1:1]}"
MODE="${2:-deck}"
FORMAT="${3:-3:4}"

mkdir -p "$DEST"
cp -R "$SKILL_DIR/assets" "$DEST/assets"

if [ "$MODE" = "webpage" ]; then
  cp "$SKILL_DIR/templates/webpage.html" "$DEST/index.html"
else
  cp "$SKILL_DIR/templates/deck.html" "$DEST/index.html"
  # 设置画布格式
  sed -i '' "s/data-format=\"3:4\"/data-format=\"$FORMAT\"/" "$DEST/index.html" 2>/dev/null \
    || sed -i "s/data-format=\"3:4\"/data-format=\"$FORMAT\"/" "$DEST/index.html"
fi

# 模板里引用 ../assets/（便于模板直接预览）；实例改为 ./assets/ 使其自包含
sed -i '' 's#\.\./assets/#./assets/#g' "$DEST/index.html" 2>/dev/null \
  || sed -i 's#\.\./assets/#./assets/#g' "$DEST/index.html"

echo "✅ 已创建 $MODE 实例: $DEST/index.html  (格式: $FORMAT)"
echo "   本地预览: open \"$DEST/index.html\""
if [ "$MODE" != "webpage" ]; then
  echo "   渲染图片: bash \"$SKILL_DIR/scripts/render.sh\" \"$DEST/index.html\" <页数>"
fi
