#!/bin/bash

#====================================================
#	System Request: Centos 7+ Debian 8+
#	Author: dylanbai8
#	* 一键安装 Frps
#	* 开源地址：https://github.com/dylanbai8/frpspro
#	Blog: https://oo0.bid
#====================================================


# 获取frps最新版本号
get_version(){
	api_url="https://api.github.com/repos/fatedier/frp/releases/latest"

	new_ver=`curl ${PROXY} -s ${api_url} --connect-timeout 10| grep 'tag_name' | cut -d\" -f4`

	touch ./version.txt
	cat <<EOF > ./version.txt
${new_ver}
EOF

	sed -i 's/v//g' ./version.txt
	get_releases=$(cat ./version.txt)

	releases_url=https://github.com/fatedier/frp/releases/download/${new_ver}/frp_${get_releases}_linux_amd64.tar.gz
	windows_url=https://github.com/fatedier/frp/releases/download/${new_ver}/frp_${get_releases}_windows_amd64.zip
	rm -rf ./version.txt
}


# 安装frps
install_frps(){
	wget -N --no-check-certificate ${releases_url}

	tar -zxvf frp*.tar.gz

	rm -rf /usr/local/frps
	mkdir /usr/local/frps

	mv ./frp*/frps /usr/local/frps/frps
	mv ./frp*/frps_full.ini /usr/local/frps/frps.ini

	rm -rf ./frp*
}


# 添加开机自启动
add_auto_run(){
	touch /etc/systemd/system/frps.service
	cat <<EOF > /etc/systemd/system/frps.service
[Unit]
Description=frps server
After=network.target
Wants=network.target
[Service]
Type=simple
PIDFile=/var/run/frps.pid
ExecStart=/usr/local/frps/frps -c /usr/local/frps/frps.ini
RestartPreventExitStatus=23
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOF
}


# 启动frps
run_frps(){
	systemctl daemon-reload
	systemctl enable frps >/dev/null 2>&1
	systemctl start frps
}


# 卸载frps
uninstall_frps(){
	systemctl stop frps
	systemctl disable frps
	rm -rf /usr/local/frps
	rm -rf /etc/systemd/system/frps.service
}


# 展示菜单
load_menu(){
local_ip=`curl -4 ip.sb`
clear
echo ""
echo -e "--------------------安装完成----------------------"
echo -e "管理面板：http://${local_ip}:7500"
echo -e "用户名：admin  密码：admin"
echo -e "默认 bind_port：7000"
echo -e "默认 token：12345678"
echo ""
echo -e "默认 vhost_http_port：80"
echo -e "默认 vhost_https_port：443"
echo ""
echo -e "默认 bind_udp_port：7001"
echo -e "默认 kcp_bind_port：7000"
echo -e "默认 allow_ports：2000-3000,3001,3003,4000-50000"
echo ""
echo -e "Windows客户端：${windows_url}"
echo -e "--------------------------------------------------"
}


# 各种设置项
# ====================================

set_bind_port(){
	get_value=""
	echo -e "你正在设置 bind_port "

	read -e -p "请输入：" get_value
	[[ -z ${get_value} ]] && get_value="none"
	if [ "${get_value}" = "none" ];then
	set_bind_port
	else
	echo -e "你设置的值为：${get_value}"
	fi

	sed -i '/^bind_port/c\bind_port = ${get_value}' /usr/local/frps/frps.ini
	systemctl restart frps
	echo -e "设置成功！"
}


set_bind_udp_port(){
	get_value=""
	echo -e "你正在设置 bind_udp_port "

	read -e -p "请输入：" get_value
	[[ -z ${get_value} ]] && get_value="none"
	if [ "${get_value}" = "none" ];then
	set_bind_udp_port
	else
	echo -e "你设置的值为：${get_value}"
	fi

	sed -i '/^bind_udp_port/c\bind_udp_port = ${get_value}' /usr/local/frps/frps.ini
	systemctl restart frps
	echo -e "设置成功！"
}


set_kcp_bind_port(){
	get_value=""
	echo -e "你正在设置 kcp_bind_port "

	read -e -p "请输入：" get_value
	[[ -z ${get_value} ]] && get_value="none"
	if [ "${get_value}" = "none" ];then
	set_kcp_bind_port
	else
	echo -e "你设置的值为：${get_value}"
	fi

	sed -i '/^kcp_bind_port/c\kcp_bind_port = ${get_value}' /usr/local/frps/frps.ini
	systemctl restart frps
	echo -e "设置成功！"
}


set_vhost_http_port(){
	get_value=""
	echo -e "你正在设置 vhost_http_port "

	read -e -p "请输入：" get_value
	[[ -z ${get_value} ]] && get_value="none"
	if [ "${get_value}" = "none" ];then
	set_vhost_http_port
	else
	echo -e "你设置的值为：${get_value}"
	fi

	sed -i '/^vhost_http_port/c\vhost_http_port = ${get_value}' /usr/local/frps/frps.ini
	systemctl restart frps
	echo -e "设置成功！"
}


set_vhost_https_port(){
	get_value=""
	echo -e "你正在设置 vhost_https_port "

	read -e -p "请输入：" get_value
	[[ -z ${get_value} ]] && get_value="none"
	if [ "${get_value}" = "none" ];then
	set_vhost_https_port
	else
	echo -e "你设置的值为：${get_value}"
	fi

	sed -i '/^vhost_https_port/c\vhost_https_port = ${get_value}' /usr/local/frps/frps.ini
	systemctl restart frps
	echo -e "设置成功！"
}


set_dashboard_port(){
	get_value=""
	echo -e "你正在设置 dashboard_port "

	read -e -p "请输入：" get_value
	[[ -z ${get_value} ]] && get_value="none"
	if [ "${get_value}" = "none" ];then
	set_dashboard_port
	else
	echo -e "你设置的值为：${get_value}"
	fi

	sed -i '/^dashboard_port/c\dashboard_port = ${get_value}' /usr/local/frps/frps.ini
	systemctl restart frps
	echo -e "设置成功！"
}


set_dashboard_user(){
	get_value=""
	echo -e "你正在设置 dashboard_user "

	read -e -p "请输入：" get_value
	[[ -z ${get_value} ]] && get_value="none"
	if [ "${get_value}" = "none" ];then
	set_dashboard_user
	else
	echo -e "你设置的值为：${get_value}"
	fi

	sed -i '/^dashboard_user/c\dashboard_user = ${get_value}' /usr/local/frps/frps.ini
	systemctl restart frps
	echo -e "设置成功！"
}



set_dashboard_pwd(){
	get_value=""
	echo -e "你正在设置 dashboard_pwd "

	read -e -p "请输入：" get_value
	[[ -z ${get_value} ]] && get_value="none"
	if [ "${get_value}" = "none" ];then
	set_dashboard_pwd
	else
	echo -e "你设置的值为：${get_value}"
	fi

	sed -i '/^dashboard_pwd/c\dashboard_pwd = ${get_value}' /usr/local/frps/frps.ini
	systemctl restart frps
	echo -e "设置成功！"
}


set_token(){
	get_value=""
	echo -e "你正在设置 token "

	read -e -p "请输入：" get_value
	[[ -z ${get_value} ]] && get_value="none"
	if [ "${get_value}" = "none" ];then
	set_token
	else
	echo -e "你设置的值为：${get_value}"
	fi

	sed -i '/^token/c\token = ${get_value}' /usr/local/frps/frps.ini
	systemctl restart frps
	echo -e "设置成功！"
}


set_subdomain_host(){
	get_value=""
	echo -e "你正在设置 subdomain_host "

	read -e -p "请输入：" get_value
	[[ -z ${get_value} ]] && get_value="none"
	if [ "${get_value}" = "none" ];then
	set_subdomain_host
	else
	echo -e "你设置的值为：${get_value}"
	fi

	sed -i '/^subdomain_host/c\subdomain_host = ${get_value}' /usr/local/frps/frps.ini
	systemctl restart frps
	echo -e "设置成功！"
}

# ====================================


# 安装流程
install(){
	get_version
	install_frps
	add_auto_run
	run_frps
	load_menu
}


# 脚本菜单
case "$1" in
	bind_port|bind_udp_port|kcp_bind_port|vhost_http_port|vhost_https_port|dashboard_port|dashboard_user|dashboard_pwd|token|subdomain_host|install|uninstall)
	set_$1
	;;
	*)
	echo "缺少参数,更多教程请访问：https://github.com/dylanbai8/kmspro"
	;;
esac


# 转载请保留版权：https://github.com/dylanbai8/frpspro