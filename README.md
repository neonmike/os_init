
# os_init 

想法当Linux 开发者在是对系统的有了足够的熟悉的情况下

1. 可以一键设置对应的需求
2. 默认可以自动修改系统配置方便使用
3. 针对windows vmware、virtualbox 等虚拟机，使用的VMimage等镜像快速使用，保证环境的快速创建。

## 支持的脚本
- 镜像脚本修改：[VMimage](https://www.linuxvmimages.com/)
- 镜像脚本修改：[osboxes](https://www.osboxes.org/virtualbox-images/)

## 提交

请在dev 分支开发提交

## 项目进展


[1] 仅仅测试了在Ubuntu上相关的设置方式
[2] ubuntu 集成测试 

## 功能
初始化以下内容
- 设置的History 记录、长线保持
- 禁止系统更新，保证开机不启动
- 修改软件源 以 阿里镜像仓库地址 为默认地址
- 安装 fish 工具
- 下载默认代理工具：clash for linux install (针对的国内用户实现系统代理)

## 相关地址
- [clash for linux install](https://github.com/Dreamacro/clash-for-linux)
- [fish-shell](https://github.com/fish-shell/fish-shell)

---
## status 
此项目的不定时维护更新！
