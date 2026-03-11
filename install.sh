#!/usr/bin/env bash
set -e

BASE_URL="https://raw.githubusercontent.com/sonpjz/hongqi/main"

INSTALL_DIR="$HOME/openclaw-tools"
BIN_LINK="/usr/local/bin/openclaw-menu"
APP_DIR="$HOME/.local/share/applications"
CONFIG_DIR="$HOME/.config/openclaw-menu"
DESKTOP_DIR="$HOME/桌面"
DESKTOP_FILE_NAME="【鸿龙】运维菜单.desktop"

echo
echo "【鸿龙】运维菜单 安装 / 更新程序"
echo

if ! command -v openclaw >/dev/null 2>&1; then
  echo "未检测到 OpenClaw，请先安装 OpenClaw"
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "未检测到 curl，请先安装 curl"
  exit 1
fi

if ! command -v whiptail >/dev/null 2>&1; then
  echo "正在安装 whiptail..."
  sudo apt update
  sudo apt install -y whiptail
fi

mkdir -p "$INSTALL_DIR"
mkdir -p "$APP_DIR"
mkdir -p "$CONFIG_DIR"

echo "下载最新文件..."

curl -fsSL "$BASE_URL/openclaw-cn-menu.sh" -o "$INSTALL_DIR/openclaw-cn-menu.sh"
curl -fsSL "$BASE_URL/openclaw-menu.desktop" -o "$INSTALL_DIR/openclaw-menu.desktop"
curl -fsSL "$BASE_URL/version.txt" -o "$CONFIG_DIR/version.txt"

chmod +x "$INSTALL_DIR/openclaw-cn-menu.sh"
chmod +x "$INSTALL_DIR/openclaw-menu.desktop"

echo "创建系统命令..."
sudo ln -sf "$INSTALL_DIR/openclaw-cn-menu.sh" "$BIN_LINK"
sudo chmod +x "$BIN_LINK" 2>/dev/null || true

echo "创建应用菜单启动器..."
cp -f "$INSTALL_DIR/openclaw-menu.desktop" "$APP_DIR/openclaw-menu.desktop"
chmod +x "$APP_DIR/openclaw-menu.desktop"

if [ -d "$DESKTOP_DIR" ]; then
  echo "创建桌面启动器..."
  cp -f "$INSTALL_DIR/openclaw-menu.desktop" "$DESKTOP_DIR/$DESKTOP_FILE_NAME"
  chmod +x "$DESKTOP_DIR/$DESKTOP_FILE_NAME"
  gio set "$DESKTOP_DIR/$DESKTOP_FILE_NAME" metadata::trusted true 2>/dev/null || true
fi

echo "$BASE_URL/install.sh" > "$CONFIG_DIR/install_url"
echo "$BASE_URL/version.txt" > "$CONFIG_DIR/version_url"

update-desktop-database "$APP_DIR" 2>/dev/null || true

echo
echo "安装 / 更新完成！"
echo
echo "运行方式："
echo "1. 终端输入：openclaw-menu"
echo "2. 桌面双击：$DESKTOP_FILE_NAME"
echo