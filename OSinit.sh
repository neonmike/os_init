#!/bin/bash

PS4='+[$BASH_SOURCE:$LINENO] ' # 显示当前脚本文件名和行号，方便调试定位

set -e # 遇到错误就退出

if [ -f /etc/os-release ]; then
	. /etc/os-release # 读取系统发行版信息
fi

echo "权限检查......................................."
# 权限检查：确保用户是 root 或具有 sudo 权限
if [ $(id -u) -ne 0 ] && ! sudo -v >/dev/null 2>&1; then
	echo "请切换为具有 sudo 权限的用户来开启脚本"
	exit 1
fi

install_deps() {
	os_version=$1
	# os_version_num=$2
	if [ "$os_version" = "Ubuntu" ]; then
		sudo apt update >/dev/null 2>&1
		if ! command -v curl >/dev/null 2>&1; then
			sudo apt install curl -y
			echo "安装依赖 install curl ......................... "
		fi
		if ! command -v git >/dev/null 2>&1; then
			echo "install git..................................."
			sudo apt install git -y
			echo "git 安装完成..................................."
		fi
		if ! command -v fish >/dev/null 2>&1; then
			echo "开始安装fish SHELL  ............................."
			if sudo apt install fish -y >/dev/null 2>&1; then
				echo "fish SHELL install 完成 ！！ "
			else
				echo "fish SHELL install 失败 "
				sudo apt install fish -y # 再显示错误信息帮助调试
			fi
		fi

	fi
}

set_ubuntu() {

	# 1. 停止服务
	sudo systemctl stop unattended-upgrades
	# 2. 禁用开机自启
	sudo systemctl disable unattended-upgrades
	# 应该返回 "disabled"
	sudo systemctl daemon-reload
	# 3. （可选）查看状态确认已禁用
	systemctl is-enabled unattended-upgrades

	#修改历史命令条数
	echo "export HISTFILESIZE=2000" >>~/.bashrc
	shopt -s histappend # 设置追加方式
	source ~/.bashrc

	os_version=$1

	if [[ "$os_version" = "14.04" ]]; then
		echo "备份source.list 文件到sources.list.bak....."
		sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
		if [ $? -eq 0 ]; then
			echo "备份成功"
		else
			echo "备份失败，退出脚本" >&2
			exit 1
		fi
		sudo tee /etc/apt/sources.list >/dev/null <<'EOF'
deb https://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb https://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse

## Not recommended
# deb https://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
EOF

	elif [[ "$os_version" = "20.04" ]]; then
		echo "系统版本：Ubuntu 22.04 版本"
		echo "备份source.list 文件"
		sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
		if [ $? -eq 0 ]; then
			echo "备份成功"
		else
			echo "备份失败，退出脚本" >&2
			exit 1
		fi
		sudo tee /etc/apt/sources.list >/dev/null <<'EOF'
deb https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse

# deb https://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse

EOF
	elif [[ "$os_version" = "22.04" ]]; then
		echo "系统版本：Ubuntu 22.04 版本"
		echo "备份source.list 文件"
		sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
		if [ $? -eq 0 ]; then
			echo "备份成功"
		else
			echo "备份失败，退出脚本" >&2
			exit 1
		fi
		sudo tee /etc/apt/sources.list >/dev/null <<'EOF'
deb https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse

# deb https://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse

EOF
	elif [[ "$os_version" = "24.04" ]]; then
		echo "系统版本：Ubuntu 24.04 版本"
		echo "备份source.list 文件"
		sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
		if [ $? -eq 0 ]; then
			echo "备份成功"
		else
			echo "备份失败，退出脚本" >&2
			exit 1
		fi
		sudo tee /etc/apt/sources.list >/dev/null <<'EOF'
deb https://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse

# deb https://mirrors.aliyun.com/ubuntu/ noble-proposed main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ noble-proposed main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse

EOF
	else
		echo "不被支持的Ubuntu 系统版本，仅支持，
        ubuntu 14.04 LTS
        ubuntu 16.04 LTS (xenial) (EOL) 
        ubuntu 18.04 LTS (bionic)
        ubuntu 20.04 LTS (focal) 
        ubuntu 22.04 LTS (jammy) 
        ubuntu 23.04 (lunar) 
        ubuntu 24.04 (noble)  
        "
	fi

}
echo "检测系统名称：${ID},系统版本：${VERSION_ID}..........."

if [[ "$NAME" = "Ubuntu" ]]; then
	set_ubuntu "$VERSION_ID"
fi

install_deps "$NAME"

## 在ubuntu 中登录shell和非登录shell启动的是不同的配置文件：.profile .bashrc  文件

# 尝试连接 GitHub，使用 -I 选项获取 HTTP 头
echo "检查网络连接性是否可以访问 www.gh-proxy.com......"
set -x
netconn_response=$(curl -sSL -I https://gh-proxy.com)
# echo "$netconn_response"
# 提取 HTTP 状态码
netconn_statcode=$(echo "$netconn_response" | head -n 1 | awk '{print $2}')

# 判断状态码是否为 200(表示成功连接)
if [[ "$netconn_statcode" -eq 200 ]]; then

	echo -e "检查完未发现异常..............................\n开始安装的clash for linux install ............"
	if [[ -e clash-for-linux-install ]]; then
		:
	else
		# 安装代理工具
		git clone --branch master --depth 1 https://gh-proxy.com/https://github.com/nelvko/clash-for-linux-install.git >/dev/null 2>&1
		if [[ "$?" -ne 0 ]]; then
			echo "Clash for linux install 下载失败"
			git clone --branch master --depth 1 https://gh-proxy.com/https://github.com/nelvko/clash-for-linux-install.git #显示执行错误的结果
			exit 1
		fi
	fi

	if cd clash-for-linux-install && sudo bash install.sh; then
		cat <<EOF
Clash for Linux 安装成功:
	clashon 开启
	clashoff 关闭代理
	clashtun on 开始tun模式
	clashtun off 关闭tun模式
more realted content:https://github.com/nelvko/clash-for-linux-install
EOF

	fi
else
	echo "无法连接到 GitHub，状态码：$netconn_statcode"
	echo "跳过安装clash for linux install 内容"
fi
set +x
