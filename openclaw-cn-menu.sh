#!/usr/bin/env bash

CONFIG="$HOME/.config/openclaw-menu/install_url"

check_openclaw() {
if ! command -v openclaw >/dev/null 2>&1; then
echo "未检测到 OpenClaw"
exit 1
fi
}

pause() {
read -p "按回车返回菜单..."
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

esac

pause

done

}

model_menu(){

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

openclaw models set "$MODEL"

;;

4) openclaw models status --probe ;;
5) break ;;

esac

pause

done

}

channel_menu(){

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

esac

pause

done

}

plugin_menu(){

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

PLUGIN=$(whiptail --inputbox "输入插件路径或URL" 10 60 3>&1 1>&2 2>&3)

openclaw plugins install "$PLUGIN"

;;

3) ls ~/.openclaw/skills ;;

4) break ;;

esac

pause

done

}

backup_menu(){

CONFIG_FILE=~/.openclaw/openclaw.json

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

esac

pause

done

}

system_menu(){

while true
do

CHOICE=$(whiptail --title "系统工具" --menu "选择操作" 20 60 10 \
1 "OpenClaw 版本" \
2 "Node 版本" \
3 "OpenClaw 路径" \
4 "打开 OpenClaw CLI" \
5 "更新运维菜单" \
6 "返回" 3>&1 1>&2 2>&3)

case $CHOICE in

1) openclaw --version ;;
2) node -v ;;
3) which openclaw ;;
4) openclaw ;;
5)

if [ -f "$CONFIG" ]; then

URL=$(cat "$CONFIG")

curl -fsSL "$URL" | bash

else

echo "未找到安装地址"

fi

;;

6) break ;;

esac

pause

done

}

check_openclaw

while true
do

CHOICE=$(whiptail --title "【鸿祺龙虾】运维菜单" --menu "请选择功能" 20 60 10 \
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

esac

done