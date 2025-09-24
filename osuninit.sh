#!/bin/bash

# 检测操作系统类型，然后删除 fish shell

set -e # 遇到错误立即退出
os_name=""
os_version=""	


# 检测操作系统类型和版本
detect_os() {
	local temp_name=""
	local temp_version=""

	if [ -f /etc/os-release ]; then
		# 使用标准的 /etc/os-release 文件
		. /etc/os-release 2>/dev/null
		temp_name=$(echo "$ID" | tr '[:upper:]' '[:lower:]')
		temp_version="$VERSION_ID"
	elif [ -f /etc/redhat-release ]; then
		# 兼容 Red Hat 系列系统（如 CentOS、RHEL）
		temp_name=$(cat /etc/redhat-release | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
		temp_version=$(cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+|[0-9]+' | head -n 1)
	elif [ -f /etc/lsb-release ]; then
		# 兼容部分基于 Debian 的系统
		. /etc/lsb-release 2>/dev/null
		temp_name=$(echo "$DISTRIB_ID" | tr '[:upper:]' '[:lower:]')
		temp_version="$DISTRIB_RELEASE"
	else
		echo "错误: 无法检测操作系统类型" >&2
		return 1
	fi

	# 验证变量是否设置
	if [ -z "$temp_name" ] || [ -z "$temp_version" ]; then
		echo "错误: 无法获取操作系统信息" >&2
		return 1
	fi

	echo "$temp_name|$temp_version"
	return 0
}

# 使用函数
os_info=$(detect_os)

if [ $? -eq 0 ]; then
	os_name=$(echo "$os_info" | cut -d '|' -f 1)
	os_version=$(echo "$os_info" | cut -d '|' -f 2)
	echo "检测到操作系统: $os_name, 版本: $os_version"
else
	echo "操作系统检测失败"
	exit 1
fi
echo "检测到系统: $os_name $os_version"

remove_fish() {
	case "$1" in
	ubuntu | debian | linuxmint | pop | kali)
		if dpkg -l | grep -qw fish; then
			echo "正在卸载 fish..."
			sudo apt remove -y fish
			echo "卸载完成"
		else
			echo "系统未安装 fish"
		fi
		;;
	centos | rhel | almalinux | oraclelinux)
		if rpm -q fish >/dev/null 2>&1; then
			echo "正在卸载 fish..."
			if [[ "$os_version" =~ ^8\. ]]; then
				sudo dnf remove -y fish
			else
				sudo yum remove -y fish
			fi
			echo "卸载完成"
		else
			echo "系统未安装 fish"
		fi
		;;
	fedora | rocky)
		if rpm -q fish >/dev/null 2>&1; then
			echo "正在卸载 fish..."
			sudo dnf remove -y fish
			echo "卸载完成"
		else
			echo "系统未安装 fish"
		fi
		;;
	arch | manjaro | endeavouros)
		if pacman -Q fish >/dev/null 2>&1; then
			echo "正在卸载 fish..."
			sudo pacman -Rns --noconfirm fish
			echo "卸载完成"
		else
			echo "系统未安装 fish"
		fi
		;;
	opensuse | sles)
		if rpm -q fish >/dev/null 2>&1; then
			echo "正在卸载 fish..."
			sudo zypper -n remove fish
			echo "卸载完成"
		else
			echo "系统未安装 fish"
		fi
		;;
	*)
		echo "不支持的系统: $1"
		return 1
		;;
	esac
	return 0
}

# 文件检测示例

FILE_PATH="./clash-for-linux-install"

# 检查文件是否存在，若存在则输出提示信息并删除该文件
if [[ -f "$FILE_PATH" ]]; then
	printf "文件存在：%s\n" "$FILE_PATH"
	if rm -rf "$FILE_PATH"; then
		printf "已成功删除文件：%s\n" "$FILE_PATH"
	else
		printf "删除文件 %s 失败\n" "$FILE_PATH" >&2
		exit 1
	fi
else
	printf "文件不存在：%s\n" "$FILE_PATH"
fi
# 恢复默认的软件源
recover_softwaresource() {
	# 检查是否已定义 os_name 变量
	if [ -z "$1" ]; then
		echo "错误: 未检测到操作系统信息" >&2
		return 1
	fi

	case "$1" in
	ubuntu | debian | linuxmint | pop | kali)
		# 恢复 apt 软件源
		if [ -f "/etc/apt/sources.list.bak" ]; then
			echo "正在恢复默认软件源..."
			sudo cp "/etc/apt/sources.list.bak" "/etc/apt/sources.list"
			if [ $? -eq 0 ]; then
				echo "软件源恢复完成"
			else
				echo "软件源恢复失败" >&2
				return 1
			fi
		else
			echo "未找到备份的软件源文件" >&2
			return 1
		fi
		;;
	centos | rhel | almalinux | oraclelinux)
		# 恢复 yum/dnf 软件源逻辑可根据实际备份情况添加
		echo "当前未实现 $1 的软件源恢复功能" >&2
		return 1
		;;
	fedora | rocky)
		# 恢复 dnf 软件源逻辑可根据实际备份情况添加
		echo "当前未实现 $1 的软件源恢复功能" >&2
		return 1
		;;
	arch | manjaro | endeavouros)
		# 恢复 pacman 软件源逻辑可根据实际备份情况添加
		echo "当前未实现 $os_name 的软件源恢复功能" >&2
		return 1
		;;
	opensuse | sles)
		# 恢复 zypper 软件源逻辑可根据实际备份情况添加
		echo "当前未实现 $1 的软件源恢复功能" >&2
		return 1
		;;
	*)
		echo "不支持的系统: $1" >&2
		return 1
		;;
	esac
	return 0
}

if ! remove_fish "$os_name"; then
	echo "卸载 fish 失败" >&2
	exit 1
fi
# 调用 recover_softwaresource 函数以恢复默认的软件源
if ! recover_softwaresource "$os_name"; then
	echo "恢复默认软件源失败" >&2
	exit 1
fi
