#!/bin/bash

script_1() {
    # 更新包列表并安装常用工具
    apt update
    apt install -y socat iperf3 mtr wget curl nano sudo net-tools cron ipset unzip p7zip-full python3-pip flex bison
    echo "脚本1执行完成：已安装指定软件包"
}

script_2() {
    # 安装Docker
    bash <(curl -sSL https://cdn.jsdelivr.net/gh/SuperManito/LinuxMirrors@main/DockerInstallation.sh)
    echo "脚本2执行完成：Docker安装完成"
}

script_3() {
    # 获取并配置XrayR配置文件
    wget -O config.zip https://raw.githubusercontent.com/xhd0926/Xray-examples/main/VLESS-gRPC-REALITY/config.zip
    sudo mkdir -p /etc/xrayR
    unzip -P "X.2023" -o config.zip -d /etc/xrayR
    rm config.zip
    echo "脚本3执行完成：XrayR配置文件已获取并解压到 /etc/xrayR"
}

script_4() {
    # 使用Docker安装和运行XrayR
    docker rm -f xrayR
    docker pull teddysun/xray
    docker run -d --name xrayR --restart always --net host -v /etc/xrayR:/etc/xray teddysun/xray
    echo "脚本4执行完成：XrayR已在Docker中运行"
}

script_5() {
    # 安装gost
    wget --no-check-certificate -O gost.sh https://raw.githubusercontent.com/KANIKIG/Multi-EasyGost/master/gost.sh
    chmod +x gost.sh
    ./gost.sh
    rm gost.sh
    echo "脚本5执行完成：gost已安装"
}

script_6() {
    # 安装哪吒监控agent
    curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o nezha.sh
    chmod +x nezha.sh
    sudo ./nezha.sh install_agent
    rm nezha.sh
    echo "脚本6执行完成：哪吒监控agent已安装"
}

script_7() {
    # 测试流媒体解锁（URL待确认，临时替换为常见脚本）
    bash <(curl -sL https://github.com/lmc999/RegionRestrictionCheck/raw/main/check.sh)
    echo "脚本7执行完成：流媒体解锁测试已完成"
}

script_8() {
    # 开启BBR
    wget http://sh.nekoneko.cloud/tools.sh -O tools.sh
    bash tools.sh
    rm tools.sh
    echo "脚本8执行完成：BBR已开启"
}

script_9() {
    # 修改SSH端口
    wget https://www.moerats.com/usr/down/sshport.sh -O sshport.sh
    chmod +x sshport.sh
    bash sshport.sh
    rm sshport.sh
    echo "脚本9执行完成：SSH端口已修改"
}

script_10() {
    # 重启SSH服务
    service sshd restart
    echo "脚本10执行完成：SSH服务已重启"
}

while true; do
    echo -e "\n请选择要执行的脚本："
    echo "1 - 安装常用工具"
    echo "2 - 安装Docker"
    echo "3 - 获取XrayR配置文件"
    echo "4 - Docker安装XrayR"
    echo "5 - 安装gost"
    echo "6 - 安装哪吒监控"
    echo "7 - 测试流媒体解锁"
    echo "8 - 开启BBR"
    echo "9 - 修改SSH端口"
    echo "10 - 重启SSH服务"
    echo "0 - 退出"
    
    read -p "请输入你的选择（0-10）：" choice
    
    case $choice in
        0)
            echo "程序退出"
            exit 0
            ;;
        1)
            script_1
            ;;
        2)
            script_2
            ;;
        3)
            script_3
            ;;
        4)
            script_4
            ;;
        5)
            script_5
            ;;
        6)
            script_6
            ;;
        7)
            script_7
            ;;
        8)
            script_8
            ;;
        9)
            script_9
            ;;
        10)
            script_10
            ;;
        *)
            echo "无效输入，请输入0-10之间的数字"
            ;;
    esac
done