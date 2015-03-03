# aboutss
shadowsocks-python版本一键安装For Centos6


一、说明

1、本教程完全按照Anonymous V大神的教程来做的，教程网址为
http://shadowsocks.blogspot.sg/2015/01/shadowsocks.html 
2、本安装程序安装的版本为Python版本
3、建议全新安装，对于本安装程序带来的其它问题，本人概不负责。
4、本安装程序在DO的Centos6.5 x64上测试通过
 在搬瓦工的3.99美元一年的，Centos6.0上测试通过
5、安装完成后，shadowsocks的端口号为8388，连接密码为：www.aboutss.net
加密方式为：aes-256-cfb
如需修改，请修改/etc/shadowsocks.json文件

二、安装步骤

1、 用ssh登陆VPS,复制命令执行
 yum install wget -y  && rm -f ss.sh &&  wget http://106.185.27.165/ss.sh  && chmod 777 ss.sh &&  bash ss.sh

2、出现提示信息，按任意键继续


3、 出现提示信息，按任意键重启VPS
