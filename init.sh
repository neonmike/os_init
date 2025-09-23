#!/bin/bash
PS4='+$LINENO: '  # 显示行号
. /etc/os-release # 读取系统资源

# if [ "$(id -u)" -eq 0 || ]; then
#     echo "当前是 root 用户执行"
# else
#     echo "当前不是 root 用户执行"
#     exit 1
# fi

# if [ "$(id -u)" -ne 0 && ! sudo -v ] >/dev/null 2>&1; then
# 	echo "请切换用的sudo 权限用户开启脚本"
# 	exit 1
# fi
#输出用户uid 数值，并且看看有没有的sudo 权限
if [ $(id -u) -ne 0 ] && ! sudo -v >/dev/null 2>&1; then
	echo "请切换为具有 sudo 权限的用户来开启脚本"
	exit 1
fi

install_deps() {
	# set -x
	os_version=$1
	# os_version_num=$2
	if [ "$os_version" = "Ubuntu" ]; then
		sudo apt update
		if ! command -v curl >/dev/null 2>&1; then
			sudo apt install curl -y
			echo "安装依赖 install curl "
		fi
		if ! command -v git >/dev/null 2>&1; then
			sudo apt install git -y
			echo " install git......."
		fi
	fi
	# set +x
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

	if [ x"$os_version" = x"14.04" ]; then
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

		echo "获取阿里巴巴的项目包索引更新........"
		sudo apt-get update
	elif [ x"$os_version" = x"22.04" ]; then
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

		echo "获取阿里巴巴的项目包索引更新"
		sudo apt-get update
	elif [ x"$os_version" = x"24.04" ]; then
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

if [ x"$NAME" = x"Ubuntu" ]; then
	set_ubuntu "$VERSION_ID"
	install_deps "$NAME"
fi

# if [ "$NAME" = "Centos" ]; then
#     sudo yum check-upate
# fi
# 修改root 默认密码 neon

# echo "root:neon" | sudo chpasswd
# if [[ $? -eq 0 ]]; then
# 	echo "密码修改成功"
# else
# 	echo "密码修改失败"
# 	exit 1
# fi

## 在ubuntu 中登录shell和非登录shell启动的是不同的配置文件：.profile .bashrc  文件

# 尝试连接 GitHub，使用 -I 选项获取 HTTP 头

netconn_response=$(curl -sSL -I https://github.com)
echo "$netconn_response"
# 提取 HTTP 状态码
netconn_statcode=$(echo "$netconn_response" | head -n 1 | awk '{print $2}')

# 判断状态码是否为 200（表示成功连接）
if [[ "$netconn_statcode" -eq 200 ]]; then
	echo "开始安装的clash for linux "
	# 安装代理工具
	ret=$(git clone --branch master --depth 1 https://gh-proxy.com/https://github.com/nelvko/clash-for-linux-install.git)
	if [[ "$ret" -ne 0 && "$ret" -ne 128 ]]; then
		echo "Clash for linux install 下载失败"
		exit 1
	fi
	if cd clash-for-linux-install && sudo bash install.sh; then

		cat <<EOF
Clash for Linux 安装成功
clashon 开启
clashoff 关闭代理
clashtun on 开始tun模式
clashtun off 关闭tun模式
more realted content:https://github.com/nelvko/clash-for-linux-install
EOF
	else
		echo "Clash for Linux 安装失败"
		exit 1
	fi
else
	echo "无法连接到 GitHub，状态码：$netconn_statcode"
	echo "跳过安装此部分内容"
fi
