#!/usr/bin/env bash
# whiteprint · 渲染：用 headless Chrome 把 deck 每页导成 PNG（供小红书/分享）
# 用法:
#   render.sh <deck.html> [页数] [输出目录] [宽,高]
#   render.sh dist/index.html 6            → 默认 1080x1440 (3:4 小红书竖版)
#   render.sh dist/index.html 6 shots 1920,1080   → 16:9 横版
set -euo pipefail
DECK="${1:?用法: render.sh <deck.html> [页数] [输出目录] [宽,高]}"
PAGES="${2:-6}"
OUT="${3:-$(dirname "$DECK")/shots}"
SIZE="${4:-1080,1440}"

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [ ! -x "$CHROME" ]; then
  CHROME="$(command -v google-chrome || command -v chromium || command -v chrome || true)"
fi
if [ -z "${CHROME:-}" ] || [ ! -x "$CHROME" ]; then
  echo "❌ 未找到 Chrome。请安装 Google Chrome，或把 CHROME 环境变量指向浏览器可执行文件。" >&2
  exit 1
fi

mkdir -p "$OUT"
ABS="$(cd "$(dirname "$DECK")" && pwd)/$(basename "$DECK")"
URL="file://$ABS"

echo "渲染 $PAGES 页 ($SIZE) → $OUT"
for i in $(seq 1 "$PAGES"); do
  "$CHROME" --headless=new --no-sandbox --disable-gpu --disable-dev-shm-usage \
    --hide-scrollbars \
    --window-size="$SIZE" \
    --screenshot="$OUT/slide-$i.png" \
    "$URL#/$i" >/dev/null 2>&1 || { echo "  ⚠️ 第 $i 页渲染失败"; continue; }
  echo "  → $OUT/slide-$i.png"
done
echo "✅ 完成 $PAGES 页 → $OUT"
