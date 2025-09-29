#!/bin/bash
set -e # 遇到错误立即退出

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

recover_update() {
	if [[ $1 == "ubuntu" ]]; then
		if [[ $2 == "24.04" || $2 == "22.04" || $2 == "20.04" || $2 == "18.04" || $2 == "16.04" ]]; then
			# 2. 开机启动
			sudo systemctl enable unattended-upgrades
			sudo systemctl daemon-reload
		elif [[ $os_version == "14.04" ]]; then
			sudo update-rc.d unattended-upgrades defaults
			sudo service unattended-upgrades status
		fi
	fi
}
recover_ubuntu_softwaresource() {
	if sudo cp /etc/apt/sources.list.bak /etc/apt/sources.list; then
		echo "/etc/apt/sources.list 恢复成功"
	else
		echo "恢复失败，退出脚本" >&2
		exit 1
	fi
	sudo apt update
}
uninstall_clash() {
	echo "卸载 Clash for linux "
	if [ -d "clash-for-linux-install" ]; then
		cd clash-for-linux-install
		bash ./uninstall.sh
	fi
	echo "Clash for Linux 卸载完成"
}

sys_check
recover_update "$os_name" "$os_version"
recover_ubuntu_softwaresource
uninstall_clash

# remove_fish() {
# 	case "$1" in
# 	ubuntu | debian | linuxmint | pop | kali)
# 		if dpkg -l | grep -qw fish; then
# 			echo "正在卸载 fish..."
# 			sudo apt remove -y fish
# 			echo "卸载完成"
# 		else
# 			echo "系统未安装 fish"
# 		fi
# 		;;
# 	centos | rhel | almalinux | oraclelinux)
# 		if rpm -q fish >/dev/null 2>&1; then
# 			echo "正在卸载 fish..."
# 			if [[ "$os_version" =~ ^8\. ]]; then
# 				sudo dnf remove -y fish
# 			else
# 				sudo yum remove -y fish
# 			fi
# 			echo "卸载完成"
# 		else
# 			echo "系统未安装 fish"
# 		fi
# 		;;
# 	fedora | rocky)
# 		if rpm -q fish >/dev/null 2>&1; then
# 			echo "正在卸载 fish..."
# 			sudo dnf remove -y fish
# 			echo "卸载完成"
# 		else
# 			echo "系统未安装 fish"
# 		fi
# 		;;
# 	arch | manjaro | endeavouros)
# 		if pacman -Q fish >/dev/null 2>&1; then
# 			echo "正在卸载 fish..."
# 			sudo pacman -Rns --noconfirm fish
# 			echo "卸载完成"
# 		else
# 			echo "系统未安装 fish"
# 		fi
# 		;;
# 	opensuse | sles)
# 		if rpm -q fish >/dev/null 2>&1; then
# 			echo "正在卸载 fish..."
# 			sudo zypper -n remove fish
# 			echo "卸载完成"
# 		else
# 			echo "系统未安装 fish"
# 		fi
# 		;;
# 	*)
# 		echo "不支持的系统: $1"
# 		return 1
# 		;;
# 	esac
# 	return 0
# }
