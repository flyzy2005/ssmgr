#! /bin/bash
# Copyright (c) 2018 flyzy2005

install() {
	service iptables stop
	yum install -y python-setuptools && easy_install pip
	yum install -y git
	pip install git+https://github.com/shadowsocks/shadowsocks.git@master
	ssserver -m aes-256-cfb -p 1001 -k aqwesdfas --manager-address 127.0.0.1:6001 -d start
	git clone https://github.com/gyteng/shadowsocks-manager-tiny.git
	curl -sL https://rpm.nodesource.com/setup_6.x | bash -
	yum install -y nodejs
	yum install -y screen
	screen -dmS ssmgr node shadowsocks-manager-tiny/index.js 127.0.0.1:6001 0.0.0.0:4001 $1
}


if [ "$EUID" -ne 0 ]; then
	echo '必需以root身份运行，请使用sudo命令'
	exit 1;
fi


case $1 in 
	-i )
	install $2
	;;
	* )
	echo 'm-centos-tiny Version 1.0, 2018-01-20, Copyright (c) 2018 flyzy2005'
	exit 0;
	;;
esac
