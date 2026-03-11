#!/usr/bin/env bash

MENU_VERSION="1.0.0"

CONFIG_DIR="$HOME/.config/openclaw-menu"
INSTALL_URL_FILE="$CONFIG_DIR/install_url"
VERSION_URL_FILE="$CONFIG_DIR/version_url"

pause() {
  read -p "按回车返回菜单..."
}

check_openclaw() {
  if ! command -v openclaw >/dev/null 2>&1; then
    echo "未检测到 OpenClaw"
    exit 1
  fi
}

service_menu() {
  while true
  do
    CHOICE=$(whiptail --title "服务管理" --menu "选择操作" 20 60 10 \
    1 "查看状态" \
    2 "启动 OpenClaw" \
    3 "停止 OpenClaw" \
    4 "重启 OpenClaw" \
    5 "实时日志" \
    6 "健康检查" \
    7 "返回" 3>&1 1>&2 2>&3)

    case $CHOICE in
      1) openclaw gateway status ;;
      2) openclaw gateway start ;;
      3) openclaw gateway stop ;;
      4) openclaw gateway restart ;;
      5) openclaw logs --follow ;;
      6) openclaw doctor ;;
      7) break ;;
      *) break ;;
    esac

    pause
  done
}

model_menu() {
  while true
  do
    CHOICE=$(whiptail --title "模型管理" --menu "选择操作" 20 60 10 \
    1 "模型状态" \
    2 "模型列表" \
    3 "设置默认模型" \
    4 "模型连接测试" \
    5 "返回" 3>&1 1>&2 2>&3)

    case $CHOICE in
      1) openclaw models status ;;
      2) openclaw models list ;;
      3)
        MODEL=$(whiptail --inputbox "输入 provider/model\n例如 openai/gpt-5" 10 60 3>&1 1>&2 2>&3)
        [ -n "$MODEL" ] && openclaw models set "$MODEL"
        ;;
      4) openclaw models status --probe ;;
      5) break ;;
      *) break ;;
    esac

    pause
  done
}

channel_menu() {
  while true
  do
    CHOICE=$(whiptail --title "通道管理" --menu "选择操作" 20 60 10 \
    1 "通道列表" \
    2 "添加 Telegram 机器人" \
    3 "添加 飞书 机器人" \
    4 "通道登录" \
    5 "删除通道" \
    6 "通道测试" \
    7 "返回" 3>&1 1>&2 2>&3)

    case $CHOICE in
      1) openclaw channels list ;;
      2) openclaw channels add --channel telegram ;;
      3) openclaw channels add --channel feishu ;;
      4) openclaw channels login ;;
      5) openclaw channels remove ;;
      6) openclaw channels status --probe ;;
      7) break ;;
      *) break ;;
    esac

    pause
  done
}

plugin_menu() {
  while true
  do
    CHOICE=$(whiptail --title "插件 / 技能" --menu "选择操作" 20 60 10 \
    1 "插件列表" \
    2 "安装插件" \
    3 "查看技能目录" \
    4 "返回" 3>&1 1>&2 2>&3)

    case $CHOICE in
      1) openclaw plugins list ;;
      2)
        PLUGIN=$(whiptail --inputbox "输入插件路径或 URL" 10 60 3>&1 1>&2 2>&3)
        [ -n "$PLUGIN" ] && openclaw plugins install "$PLUGIN"
        ;;
      3) ls ~/.openclaw/skills ;;
      4) break ;;
      *) break ;;
    esac

    pause
  done
}

backup_menu() {
  CONFIG_FILE="$HOME/.openclaw/openclaw.json"

  while true
  do
    CHOICE=$(whiptail --title "配置与备份" --menu "选择操作" 20 60 10 \
    1 "查看配置路径" \
    2 "备份配置" \
    3 "恢复备份" \
    4 "编辑配置" \
    5 "返回" 3>&1 1>&2 2>&3)

    case $CHOICE in
      1) echo "$CONFIG_FILE" ;;
      2) cp "$CONFIG_FILE" "$CONFIG_FILE.bak" && echo "备份完成" ;;
      3) cp "$CONFIG_FILE.bak" "$CONFIG_FILE" && echo "恢复完成" ;;
      4) nano "$CONFIG_FILE" ;;
      5) break ;;
      *) break ;;
    esac

    pause
  done
}

openclaw_update_menu() {
  while true
  do
    CHOICE=$(whiptail --title "OpenClaw 更新管理" --menu "选择操作（防误触二级菜单）" 20 70 10 \
    1 "检测是否有新版" \
    2 "执行 OpenClaw 更新" \
    3 "预演更新" \
    4 "返回" 3>&1 1>&2 2>&3)

    case $CHOICE in
      1) openclaw update status ;;
      2)
        if whiptail --yesno "确认更新 OpenClaw？" 10 60; then
          openclaw update
          echo
          openclaw doctor
        else
          echo "已取消"
        fi
        ;;
      3) openclaw update --dry-run ;;
      4) break ;;
      *) break ;;
    esac

    pause
  done
}

check_panel_update() {
  if ! command -v curl >/dev/null 2>&1; then
    echo "未检测到 curl，无法检查更新"
    return
  fi

  if [ ! -f "$VERSION_URL_FILE" ]; then
    echo "未找到远程版本地址配置"
    return
  fi

  VERSION_URL=$(cat "$VERSION_URL_FILE")
  REMOTE_VERSION=$(curl -fsSL "$VERSION_URL" 2>/dev/null | tr -d '\r' | head -n 1)

  if [ -z "$REMOTE_VERSION" ]; then
    echo "获取远程版本失败"
    return
  fi

  echo "当前面板版本：$MENU_VERSION"
  echo "远程面板版本：$REMOTE_VERSION"
  echo

  if [ "$REMOTE_VERSION" = "$MENU_VERSION" ]; then
    echo "当前已经是最新版本"
    return
  fi

  echo "检测到新版本，可以升级"

  if whiptail --yesno "检测到运维面板有新版本：$REMOTE_VERSION\n当前版本：$MENU_VERSION\n\n现在立即升级吗？" 12 70; then
    if [ ! -f "$INSTALL_URL_FILE" ]; then
      echo "未找到安装脚本地址配置"
      return
    fi

    INSTALL_URL=$(cat "$INSTALL_URL_FILE")
    echo "开始升级运维面板..."
    curl -fsSL "$INSTALL_URL" | bash
    echo
    echo "运维面板升级完成"
  else
    echo "已取消升级"
  fi
}

system_menu() {
  while true
  do
    CHOICE=$(whiptail --title "系统工具" --menu "选择操作" 20 70 10 \
    1 "OpenClaw 版本" \
    2 "Node 版本" \
    3 "OpenClaw 路径" \
    4 "打开 OpenClaw CLI" \
    5 "检查并更新运维面板" \
    6 "OpenClaw 更新管理" \
    7 "显示面板版本" \
    8 "返回" 3>&1 1>&2 2>&3)

    case $CHOICE in
      1) openclaw --version ;;
      2) node -v ;;
      3) which openclaw ;;
      4) openclaw ;;
      5) check_panel_update ;;
      6) openclaw_update_menu ;;
      7) echo "当前运维面板版本：$MENU_VERSION" ;;
      8) break ;;
      *) break ;;
    esac

    pause
  done
}

check_openclaw

while true
do
  CHOICE=$(whiptail --title "【鸿祺龙虾】运维菜单 v$MENU_VERSION" --menu "请选择功能" 20 60 10 \
  1 "服务管理" \
  2 "模型管理" \
  3 "通道管理" \
  4 "插件 / 技能管理" \
  5 "配置与备份" \
  6 "系统工具" \
  7 "退出" 3>&1 1>&2 2>&3)

  case $CHOICE in
    1) service_menu ;;
    2) model_menu ;;
    3) channel_menu ;;
    4) plugin_menu ;;
    5) backup_menu ;;
    6) system_menu ;;
    7) exit ;;
    *) exit ;;
  esac
done