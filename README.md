# os_init

**定位**  
面向熟悉 Linux 系统的开发者，提供一键初始化系统环境的工具，方便快速搭建开发环境，尤其适用于虚拟机（VMware、VirtualBox）镜像。

**目标**  
1. 一键配置常用开发需求  
2. 自动修改系统配置，优化使用体验  
3. 针对虚拟机镜像快速初始化，保证环境可复现

---

## 支持的镜像源脚本
- [VMimage](https://www.linuxvmimages.com/)  
- [osboxes](https://www.osboxes.org/virtualbox-images/)

---

## 开发与提交
- 所有开发与提交请在 `dev` 分支完成  
- 项目采用不定时更新策略  

---

## 当前进展
1. 已在 Ubuntu 系统上完成基础测试  
2. 完成 Ubuntu 集成测试  

---

## 功能列表
### 系统配置
- 持久化 History 记录  
- 禁用系统自动更新，防止开机启动  
- 修改软件源为阿里云镜像，优化国内网络访问  

### 工具安装
- 安装 `fish` shell  
- 下载并安装国内用户优化的代理工具 [Clash for Linux](https://github.com/Dreamacro/clash-for-linux)  

---

## 相关链接
- [Clash for Linux Install](https://github.com/Dreamacro/clash-for-linux)  
- [Fish Shell](https://github.com/fish-shell/fish-shell)  

---

## 状态
- 项目处于持续维护中，功能和兼容性将不定期更新  
