# frps 一键安装脚本
## 支持系统 Centos 7+ Debian 8+
```
wget -N --no-check-certificate git.io/f.sh && chmod +x f.sh && bash f.sh install
```

## 一键修改 token
```
bash f.sh token
```


# 【常用命令】

---

---

## 一键修改 bind_port
```
bash f.sh bind_port
```

## 一键修改 vhost_http_port
```
bash f.sh vhost_http_port
```

## 一键修改 vhost_https_port
```
bash f.sh vhost_https_port
```


# 【备用命令】

---

---

## 一键修改 dashboard_port
```
bash f.sh dashboard_port
```

## 一键修改 dashboard_user
```
bash f.sh dashboard_user
```

## 一键修改 dashboard_pwd
```
bash f.sh dashboard_pwd
```

## 一键修改 bind_udp_port
```
bash f.sh bind_udp_port
```

## 一键修改 kcp_bind_port
```
bash f.sh kcp_bind_port
```

## 一键修改 subdomain_host （用于泛解析子域名）
```
bash f.sh subdomain_host
```

## 一键卸载 frps
```
bash f.sh uninstall
```


# 【注意事项】

---

---

## 一键关闭 apache2、防火墙，释放 80 端口
```
bash f.sh unapache2
```

## 注意，除http(s)以外，客户端 frpc.ini 内任何端口修改时须在以下范围内：
```
默认端口 白名单：2000-3000,3001,3003,4000-50000
```

## 转发远程桌面时，需先在本机开启允许远程协助
```
我的电脑（此电脑）-右键属性-远程设置
```

## 需要注意 frpc 所在机器和 frps 所在机器的时间相差不能超过 15 分钟
