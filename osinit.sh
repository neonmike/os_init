#!/bin/bash
PS4='+[$BASH_SOURCE:$LINENO] '        # 显示当前脚本文件名和行号，方便调试定位
set -e                                # 遇到错误自动退出
trap "echo '脚本执行过程中发生错误，已退出' >&2" ERR #
os_name="UnknownOS"
os_version="UnknownVersion"

sys_check() {
	echo "权限检查......................................."
	if [ -e /etc/os-release ]; then
		. /etc/os-release # 读取系统发行版信息
	fi
	# 权限检查：确保用户是 root 或具有 sudo 权限
	echo "检测系统名称：${ID},系统版本：${VERSION_ID}..........."
	if [ $(id -u) -ne 0 ] && ! sudo -v >/dev/null 2>&1; then
		echo "请切换为具有 sudo 权限的用户来开启脚本"
		exit 1
	fi
	os_name=${ID}
	os_version=${VERSION_ID}
	if [[ "$os_name" == "UnknownOS" || "$os_version" == "UnknownVersion" ]]; then
		echo "Unknown OS detected: os_name=$os_name, os_version=$os_version. Script exiting with status 1." 
		exit 1
	fi
	echo "System_OS:${os_name} ;System_version:${os_version} ;"
}

install_ubuntu_deps() {
	# 检查是否已安装 curl, git, fish
	if ! command -v curl >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1 || ! command -v fish >/dev/null 2>&1; then
		echo "开始安装 curl, git, fish .........................."
		sudo apt update && sudo apt install curl git fish -y
		echo "依赖安装完成！"
	fi
}
update_ubuntu() {
	if sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak; then
		echo "/etc/apt/sources.list 备份成功"
	else
		echo "备份失败，退出脚本" >&2
		exit 1
	fi
	if [[ "$1" = "14.04" ]]; then
		printf '%s\n' \
			'deb https://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse' \
			'# Not recommended' \
			'# deb https://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse' \
			'# deb-src https://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse' |
			sudo tee /etc/apt/sources.list >/dev/null

	elif [[ "$1" = "16.04" ]]; then
		printf '%s\n' \
			'deb https://mirrors.aliyun.com/ubuntu/ xenial main' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ xenial main' \
			'deb https://mirrors.aliyun.com/ubuntu/ xenial-updates main' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ xenial-updates main' \
			'deb https://mirrors.aliyun.com/ubuntu/ xenial universe' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ xenial universe' \
			'deb https://mirrors.aliyun.com/ubuntu/ xenial-updates universe' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ xenial-updates universe' \
			'deb https://mirrors.aliyun.com/ubuntu/ xenial-security main' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ xenial-security main' \
			'deb https://mirrors.aliyun.com/ubuntu/ xenial-security universe' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ xenial-security universe' |
			sudo tee /etc/apt/sources.list >/dev/null
	elif [[ "$1" = "18.04" ]]; then
		printf '%s\n' \
			'deb https://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse' \
			'# deb https://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse' \
			'# deb-src https://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse' |
			sudo tee /etc/apt/sources.list >/dev/null

	elif [[ "$1" = "20.04" ]]; then
		printf '%s\n' \
			'deb https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse' \
			'# deb https://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse' \
			'# deb-src https://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse' |
			sudo tee /etc/apt/sources.list >/dev/null

	elif [[ "$1" = "22.04" ]]; then
		printf '%s\n' \
			'deb https://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse' \
			'# deb https://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse' \
			'# deb-src https://mirrors.aliyun.com/ubuntu/ jammy-proposed main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse' |
			sudo tee /etc/apt/sources.list >/dev/null
	elif [[ "$1" = "23.04" ]]; then
		printf '%s\n' \
			'deb https://mirrors.aliyun.com/ubuntu/ lunar main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ lunar main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ lunar-security main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ lunar-security main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ lunar-updates main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ lunar-updates main restricted universe multiverse' \
			'# deb https://mirrors.aliyun.com/ubuntu/ lunar-proposed main restricted universe multiverse' \
			'# deb-src https://mirrors.aliyun.com/ubuntu/ lunar-proposed main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ lunar-backports main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ lunar-backports main restricted universe multiverse' |
			sudo tee /etc/apt/sources.list >/dev/null
	elif [[ "$1" = "24.04" ]]; then
		printf '%s\n' \
			'deb https://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse' \
			'# deb https://mirrors.aliyun.com/ubuntu/ noble-proposed main restricted universe multiverse' \
			'# deb-src https://mirrors.aliyun.com/ubuntu/ noble-proposed main restricted universe multiverse' \
			'deb https://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse' \
			'deb-src https://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse' |
			sudo tee /etc/apt/sources.list >/dev/null
	else
		echo "/etc/apt/sources.list 更新失败，退出脚本" >&2
		exit 1
	fi
	sudo apt update
	echo "sources.list 已更新为使用阿里云镜像。"
}

# 禁用自动更新
forbid_update() {
	if [[ $1 == "ubuntu" ]]; then
		if [[ $2 == "24.04" || $2 == "22.04" || $2 == "20.04" || $2 == "18.04" || $2 == "16.04" ]]; then
			# 1. 停止服务
			sudo systemctl stop unattended-upgrades
			# 2. 禁用开机自启
			sudo systemctl disable unattended-upgrades
			sudo systemctl daemon-reload
		elif [[ $os_version == "14.04" ]]; then
			# 1. 停止服务
			sudo service unattended-upgrades stop
			# 2. 禁用开机自启
			sudo update-rc.d unattended-upgrades disable
			# 或者完全移除（更彻底）
			sudo update-rc.d -f unattended-upgrades remove
			# 3. 无需手动重新加载（service命令会自动处理）
			# 4. 查看服务状态
			sudo service unattended-upgrades status
			# 5. 检查开机自启状态
			# sudo update-rc.d unattended-upgrades defaults-disabled
			# 或查看运行级别链接
			# ls -la /etc/rc*.d/*unattended-upgrades*
		fi
	fi
}
# 修改历史命令条数 || 设置系统兼容？
increase_history_file() {
	echo "export HISTFILESIZE=2000" >>~/.bashrc
	shopt -s histappend # 设置追加方式
	source ~/.bashrc
}
install_linuxclash() {
	if [ -d "clash-for-linux-install" ]; then
		sudo rm -rf clash-for-linux-install >/dev/null 2>&1
	fi
	# 安装代理工具
	if ! git clone --branch master --depth 1 https://gh-proxy.com/https://github.com/nelvko/clash-for-linux-install.git; then
		echo "Clash for linux install 下载失败,退出安装 clash"
		rm -rf clash-for-linux-install >/dev/null 2>&1
		exit 1
	fi
	if ! (cd clash-for-linux-install && sudo bash install.sh); then
		sudo rm -rf clash-for-linux-install >/dev/null 2>&1
		echo "Clash for Linux 安装失败，已删除下载目录"
		exit 1
	fi
}
echo "系统检查......................................."
sys_check
echo "系统检查结束..................................."

# if [[ "$NAME" = "Ubuntu" ]]; then
echo "禁止系统软件更新......................................."
forbid_update "$os_name" "$os_version"
echo "禁止系统软件更新结束..................................."

echo "修改历史命令条数......................................."
increase_history_file
echo "修改历史命令条数结束..................................."

echo "更新系统软件源......................................."
update_ubuntu "$os_version"
echo "更新系统软件源结束..................................."

echo "安装系统依赖......................................."
install_ubuntu_deps "$os_name" "$os_version"
echo "安装系统依赖结束..................................."
echo "fish 进入fish的命令行环境......................................."

echo "安装clash for linux(注意:clash脚本不支持非systemd系统,initV 安装失败)......................................."
install_linuxclash
