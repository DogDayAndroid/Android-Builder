# LXC Docker 配置

## 一、安装Termux

首先，你需要下载并安装 [Termux](https://github.com/termux/termux-app/releases)。

然后，打开 `Termux`，执行以下命令：

```bash
apt update
apt upgrade
```

## 二、安装必要的依赖

在Termux中执行以下命令：

```bash
pkg install root-repo
pkg install tsu docker
```

## 三、启动 `Docker`

### 1. 挂载 `cgroup`

```bash
sudo mount -t tmpfs -o uid=0,gid=0,mode=0755 cgroup /sys/fs/cgroup
```

### 2. 启动 `Docker` 守护进程，并让它在后台运行

下面的运行策略二选一即可。如果你不清楚其中的具体区别，请选择第一种:

```bash
sudo dockerd --iptables=false &>/dev/null &
# or
sudo ip route add default via 192.168.1.1 dev wlan0
sudo ip rule add from all lookup main pref 30000
sudo dockerd &>/dev/null &
```

### 3. 测试 `Docker` 是否工作

```bash
sudo docker run hello-world
```

看到 `hello world from docker` 字样即表示 `Docker` 正常工作

## 常见问题

### 1. 容器内无网络

```bash
echo "nameserver 8.8.8.8" > /etc/resolv.conf
groupadd -g 3003 aid_inet && usermod -G nogroup -g aid_inet _apt
```

## Reference

- [wu17481748/lxc-docker](https://github.com/wu17481748/lxc-docker)
- [Flyme66/LXC-DOCKER-KernelSU_Action](https://github.com/Flyme66/LXC-DOCKER-KernelSU_Action)
- [手机运行Docker: 从修改内核到刷入原生Linux](https://yzddmr6.com/posts/android-run-docker/)
