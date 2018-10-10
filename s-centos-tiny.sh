#! /bin/bash
# Copyright (c) 2018 flyzy2005

install() {
	service iptables stop
	yum install -y git
        git clone https://github.com/flyzy2005/ss-fly
        ss-fly/ss-fly.sh -i flyzy2005.com
	git clone https://github.com/gyteng/shadowsocks-manager-tiny.git
	curl -sL https://rpm.nodesource.com/setup_6.x | bash -
	yum install -y nodejs
	yum install -y screen
}

start() {
        ps -ef | grep -v grep | grep -i "ssserver" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            ssserver -c /etc/shadowsocks.json -d stop
        fi
        ps -efww|grep -w 'ssmgr'|grep -v grep|cut -c 9-15|xargs kill -9 > /dev/null 2>&1
        ssserver -m aes-256-cfb -p 1001 -k aqwesdfas --manager-address 127.0.0.1:6001 -d start
        cd shadowsocks-manager-tiny && screen -dmS ssmgr node index.js 127.0.0.1:6001 0.0.0.0:4001 $1
}

if [ "$EUID" -ne 0 ]; then
	echo '必需以root身份运行，请使用sudo命令'
	exit 1;
fi


case $1 in 
	-i )
	install
	;;
        -start )
        start $2
        ;;
	* )
	echo 'm-centos-tiny Version 1.0, 2018-01-20, Copyright (c) 2018 flyzy2005'
	exit 0;
	;;
esac
