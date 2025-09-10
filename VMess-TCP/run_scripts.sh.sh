#!/bin/bash

# 检查是否以 root 权限运行
if [ "$EUID" -ne 0 ]; then
  echo "请以 root 权限运行此脚本（使用 sudo）。"
  exit 1
fi

# 检查网络连接
if ! ping -c 1 github.com &> /dev/null; then
  echo "无法连接到 GitHub，请检查网络！"
  exit 1
fi

# 检查 wget 或 curl 是否存在
if ! command -v wget &> /dev/null && ! command -v curl &> /dev/null; then
  echo "需要安装 wget 或 curl！"
  exit 1
fi

# 显示菜单
echo "请选择要执行的操作："
echo "1. 安装依赖"
echo "2. 安装 xrayR"
echo "3. 安装 xrayS"
echo "4. 安装 xrayT"
echo "5. 关闭 IPv6"
echo "6. 修改 SSH 端口"
echo "7. 开启 BBR"
echo "8. 安装 Gost"
echo "0. 退出"
read -p "请输入序号（0-8）： " choice

case $choice in
  1)
    echo "正在安装依赖..."
    apt update || { echo "apt update 失败！"; exit 1; }
    apt install -y socat iperf3 mtr wget curl nano sudo net-tools cron ipset unzip p7zip-full python3-pip flex bison docker.io || { echo "依赖安装失败！"; exit 1; }
    echo "依赖安装完成！"
    ;;
  2)
    echo "正在安装 xrayR..."
    wget -O config.zip https://raw.githubusercontent.com/xhd0926/Xray-examples/main/VLESS-gRPC-REALITY/config.zip || { echo "下载 config.zip 失败！"; exit 1; }
    mkdir -p /etc/xrayR
    unzip -P "X.2023" -o config.zip -d /etc/xrayR || { echo "解压 config.zip 失败！"; exit 1; }
    rm config.zip
    docker rm -f xrayR
    docker pull teddysun/xray || { echo "拉取 xray 镜像失败！"; exit 1; }
    docker run -d --name xrayR --restart always --net host -v /etc/xrayR:/etc/xray teddysun/xray || { echo "启动 xrayR 容器失败！"; exit 1; }
    echo "xrayR 安装完成！"
    ;;
  3)
    echo "正在安装 xrayS..."
    wget -O config.zip https://raw.githubusercontent.com/xhd0926/Xray-examples/main/Shadowsocks-2022/config.zip || { echo "下载 config.zip 失败！"; exit 1; }
    mkdir -p /etc/xrayS
    7z x -p"X.2023" -o/etc/xrayS config.zip || { echo "解压 config.zip 失败！"; exit 1; }
    rm config.zip
    docker rm -f xrayS
    docker pull teddysun/xray || { echo "拉取 xray 镜像失败！"; exit 1; }
    docker run -d --name xrayS --restart always --net host -v /etc/xrayS:/etc/xray teddysun/xray || { echo "启动 xrayS 容器失败！"; exit 1; }
    echo "xrayS 安装完成！"
    ;;
  4)
    echo "正在安装 xrayT..."
    wget -O config.zip https://raw.githubusercontent.com/xhd0926/Xray-examples/main/VLESS-TCP/config.zip || { echo "下载 config.zip 失败！"; exit 1; }
    mkdir -p /etc/xrayT
    unzip -P "X.2023" -o config.zip -d /etc/xrayT || { echo "解压 config.zip 失败！"; exit 1; }
    rm config.zip
    docker rm -f xrayT
    docker pull teddysun/xray || { echo "拉取 xray 镜像失败！"; exit 1; }
    docker run -d --name xrayT --restart always --net host -v /etc/xrayT:/etc/xray teddysun/xray || { echo "启动 xrayT 容器失败！"; exit 1; }
    echo "xrayT 安装完成！"
    ;;
  5)
    echo "正在关闭 IPv6..."
    sh -c 'echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.d/99-disable-ipv6.conf && sysctl --system && cat /proc/sys/net/ipv6/conf/all/disable_ipv6' || { echo "关闭 IPv6 失败！"; exit 1; }
    echo "IPv6 已关闭！"
    ;;
  6)
    echo "正在修改 SSH 端口..."
    sed -i 's/^#*Port .*/Port 12369/' /etc/ssh/sshd_config || { echo "修改 SSH 配置文件失败！"; exit 1; }
    systemctl restart ssh || { echo "重启 SSH 服务失败！"; exit 1; }
    echo "SSH 端口已修改为 12369！"
    ;;
  7)
    echo "正在开启 BBR..."
    cat > /etc/sysctl.conf << EOF
fs.file-max = 6815744
net.ipv4.tcp_no_metrics_save=1
net.ipv4.tcp_ecn=0
net.ipv4.tcp_frto=0
net.ipv4.tcp_mtu_probing=0
net.ipv4.tcp_rfc1337=0
net.ipv4.tcp_sack=1
net.ipv4.tcp_fack=1
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_adv_win_scale=1
net.ipv4.tcp_moderate_rcvbuf=1
net.core.rmem_max=33554432
net.core.wmem_max=33554432
net.ipv4.tcp_rmem=4096 87380 33554432
net.ipv4.tcp_wmem=4096 16384 33554432
net.ipv4.udp_rmem_min=8192
net.ipv4.udp_wmem_min=8192
net.ipv4.ip_forward=1
net.ipv4.conf.all.route_localnet=1
net.ipv4.conf.all.forwarding=1
net.ipv4.conf.default.forwarding=1
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
net.ipv6.conf.all.forwarding=1
net.ipv6.conf.default.forwarding=1
EOF
    sysctl -p || { echo "应用 sysctl 配置失败！"; exit 1; }
    sysctl --system || { echo "加载 sysctl 配置失败！"; exit 1; }
    echo "BBR 已开启！"
    ;;
  8)
    echo "正在安装 Gost..."
    wget --no-check-certificate -O gost.sh https://raw.githubusercontent.com/KANIKIG/Multi-EasyGost/master/gost.sh || { echo "下载 gost.sh 失败！"; exit 1; }
    chmod +x gost.sh
    ./gost.sh || { echo "运行 gost.sh 失败！"; exit 1; }
    echo "Gost 安装完成！"
    ;;
  0)
    echo "退出脚本。"
    exit 0
    ;;
  *)
    echo "无效的输入，请输入 0-8 之间的数字。"
    exit 1
    ;;
esac
done
