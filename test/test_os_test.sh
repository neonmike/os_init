#!/bin/bash

# 检测操作系统类型和版本
detect_os() {
    local os_name=""
    local os_version=""

    if [ -f /etc/os-release ]; then
        # 使用标准的os-release文件
        . /etc/os-release
        os_name=$(echo "$ID" | tr '[:upper:]' '[:lower:]')
        os_version="$VERSION_ID"
    elif [ -f /etc/redhat-release ]; then
        # 兼容 Red Hat 系列系统（如 CentOS、RHEL）
        os_name=$(cat /etc/redhat-release | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
        os_version=$(cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+|[0-9]+' | head -n 1)
    elif [ -f /etc/lsb-release ]; then
        # 兼容部分基于 Debian 的系统
        . /etc/lsb-release
        os_name=$(echo "$DISTRIB_ID" | tr '[:upper:]' '[:lower:]')
        os_version="$DISTRIB_RELEASE"
    else
        echo "错误: 无法检测操作系统类型" >&2
        return 1
    fi

    # 验证变量是否设置
    if [ -z "$os_name" ] || [ -z "$os_version" ]; then
        echo "错误: 无法获取操作系统信息" >&2
        return 1
    fi

    echo "$os_name|$os_version"
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
echo "$os_name"
echo "$os_version"
