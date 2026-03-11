#!/usr/bin/env bash

set -e

BASE_URL="https://raw.githubusercontent.com/sonpjz/hongqi/main"
INSTALL_DIR="$HOME/openclaw-tools"
BIN_LINK="/usr/local/bin/openclaw-menu"
DESKTOP_FILE="$INSTALL_DIR/openclaw-menu.desktop"
APP_DIR="$HOME/.local/share/applications"
CONFIG_DIR="$HOME/.config/openclaw-menu"

echo "【鸿祺龙虾】运维菜单 安装 / 更新程序"
echo

# 检查 openclaw
if ! command -v openclaw >/dev/null 2>&1; then
echo "未检测到 OpenClaw，请先安装 OpenClaw"
exit 1
fi

# 安装 whiptail
if ! command -v whiptail >/dev/null 2>&1; then
echo "正在安装 whiptail..."
sudo apt update
sudo apt install -y whiptail
fi

mkdir -p "$INSTALL_DIR"
mkdir -p "$APP_DIR"
mkdir -p "$CONFIG_DIR"

echo "下载最新脚本..."

curl -fsSL "$BASE_URL/openclaw-cn-menu.sh" -o "$INSTALL_DIR/openclaw-cn-menu.sh"
curl -fsSL "$BASE_URL/openclaw-menu.desktop" -o "$INSTALL_DIR/openclaw-menu.desktop"

chmod +x "$INSTALL_DIR/openclaw-cn-menu.sh"
chmod +x "$INSTALL_DIR/openclaw-menu.desktop"

echo "创建系统命令..."

sudo ln -sf "$INSTALL_DIR/openclaw-cn-menu.sh" "$BIN_LINK"

echo "创建桌面启动器..."

ln -sf "$INSTALL_DIR/openclaw-menu.desktop" "$APP_DIR/openclaw-menu.desktop"

if [ -d "$HOME/桌面" ]; then
ln -sf "$INSTALL_DIR/openclaw-menu.desktop" "$HOME/桌面/【鸿祺龙虾】运维菜单.desktop"
fi

echo "$BASE_URL/install.sh" > "$CONFIG_DIR/install_url"

update-desktop-database "$APP_DIR" 2>/dev/null || true

echo
echo "安装完成！"
echo
echo "运行方式："
echo "终端输入：openclaw-menu"
echo "或者桌面双击：【鸿祺龙虾】运维菜单"
echo