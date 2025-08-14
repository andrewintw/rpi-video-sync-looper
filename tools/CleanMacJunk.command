#!/bin/bash
# 取得腳本所在目錄（USB 根目錄）
DIR="$(cd "$(dirname "$0")"; pwd)"

echo "=== macOS USB 清理工具 ==="
echo "位置：$DIR"
echo

# 找出所有 macOS 隱藏檔
JUNK=$(find "$DIR" \( -name "._*" -o -name ".DS_Store" -o -name ".Trashes" -o -name ".Spotlight-V100" -o -name ".fseventsd" \))

if [ -z "$JUNK" ]; then
    echo "沒有發現隱藏檔，USB 很乾淨！"
else
    echo "發現以下隱藏檔："
    echo "$JUNK"
    echo
    read -p "要刪除這些檔案嗎？(y/N) " CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
        find "$DIR" -name "._*" -delete
        rm -rf "$DIR/.DS_Store" "$DIR/.Trashes" "$DIR/.Spotlight-V100" "$DIR/.fseventsd"
        echo "✅ 已刪除！"
    else
        echo "❌ 已取消刪除。"
    fi
fi

echo
echo "=== USB 目前檔案列表 ==="
ls -la "$DIR"

echo
read -n 1 -s -r -p "按任意鍵關閉視窗..."