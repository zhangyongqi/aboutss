#!/bin/bash

if [[ $(id -u) != "0" ]]; then
    printf "\e[42m\e[31mError: You must be root to run this install script.\e[0m\n"
    exit 1
fi
printf "
####################################################
# This is a shadowsocks-python  install program for centos6                 
# Version: 1.2.                                   
# Author: aboutss QQ:87992687                           
# Website: http://www.aboutss.net  
# Thanks to AnonymousV:http://shadowsocks.blogspot.tw/2015/01/shadowsocks.html                                                               #
####################################################
"
echo "Press any key to continue"
read num
yum install epel-release -y
yum update -y
yum install python-setuptools m2crypto supervisor -y
easy_install pip  
pip install shadowsocks
#config setting
echo "#############################################################"
echo "#"
echo "# Please input your shadowsocks-python server_port and password"
echo "#"
echo "#############################################################"
echo ""
echo "input server_port:"
read sspyserverport
echo "input password:"
read sspypwd
 
# Config shadowsocks
   cat << _EOF_ >/etc/shadowsocks.json
{
    "server":"0.0.0.0",
    "server_port":${sspyserverport},
    "local_port":1080,
    "password":"${sspypwd}",
    "timeout":600,
    "method":"aes-256-cfb"
}
_EOF_

   cat << _EOF_ >/etc/supervisord.conf

[supervisord]
http_port=/var/tmp/supervisor.sock ; (default is to run a UNIX domain socket server)
;http_port=127.0.0.1:9001  ; (alternately, ip_address:port specifies AF_INET)
;sockchmod=0700              ; AF_UNIX socketmode (AF_INET ignore, default 0700)
;sockchown=nobody.nogroup     ; AF_UNIX socket uid.gid owner (AF_INET ignores)
;umask=022                   ; (process file creation umask;default 022)
logfile=/var/log/supervisor/supervisord.log ; (main log file;default $CWD/supervisord.log)
logfile_maxbytes=50MB       ; (max main logfile bytes b4 rotation;default 50MB)
logfile_backups=10          ; (num of main logfile rotation backups;default 10)
loglevel=info               ; (logging level;default info; others: debug,warn)
pidfile=/var/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
nodaemon=false              ; (start in foreground if true;default false)
minfds=1024                 ; (min. avail startup file descriptors;default 1024)
minprocs=200                ; (min. avail process descriptors;default 200)

;nocleanup=true              ; (don't clean up tempfiles at start;default false)
;http_username=user          ; (default is no username (open system))
;http_password=123           ; (default is no password (open system))
;childlogdir=/tmp            ; ('AUTO' child log dir, default $TEMP)
;user=chrism                 ; (default is current user, required if root)
;directory=/tmp              ; (default is not to cd during start)
;environment=KEY=value       ; (key value pairs to add to environment)

[supervisorctl]
serverurl=unix:///var/tmp/supervisor.sock ; use a unix:// URL  for a unix socket
;serverurl=http://127.0.0.1:9001 ; use an http:// url to specify an inet socket
;username=chris              ; should be same as http_username if set
;password=123                ; should be same as http_password if set
;prompt=mysupervisor         ; cmd line prompt (default "supervisor")

; The below sample program section shows all possible program subsection values,
; create one or more 'real' program: sections to be able to control them under
; supervisor.

;[program:theprogramname]
;command=/bin/cat            ; the program (relative uses PATH, can take args)
;priority=999                ; the relative start priority (default 999)
;autostart=true              ; start at supervisord start (default: true)
;autorestart=true            ; retstart at unexpected quit (default: true)
;startsecs=10                ; number of secs prog must stay running (def. 10)
;startretries=3              ; max # of serial start failures (default 3)
;exitcodes=0,2               ; 'expected' exit codes for process (default 0,2)
;stopsignal=QUIT             ; signal used to kill process (default TERM)
;stopwaitsecs=10             ; max num secs to wait before SIGKILL (default 10)
;user=chrism                 ; setuid to this UNIX account to run the program
;log_stdout=true             ; if true, log program stdout (default true)
;log_stderr=true             ; if true, log program stderr (def false)
;logfile=/var/log/cat.log    ; child log path, use NONE for none; default AUTO
;logfile_maxbytes=1MB        ; max # logfile bytes b4 rotation (default 50MB)
;logfile_backups=10          ; # of logfile backups (default 10)
   
[program:shadowsocks]
command=ssserver -c /etc/shadowsocks.json
autostart=true
autorestart=true
user=root
log_stderr=true
logfile=/var/log/shadowsocks.log
_EOF_

   cat << _EOF_ >/etc/rc.local
#!/bin/sh
#
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you don't
# want to do the full Sys V style init stuff.
service supervisord start
touch /var/lock/subsys/local

_EOF_
#start
#autorun
#echo "ssserver -c /etc/config.json" >> /etc/rc.local
echo ""
    echo -e "============================="
    echo -e "Shadowsocks-python install completed!"
    #echo -e "Your Server IP: ${IP}"
    echo -e "Your Server Port: ${sspyserverport}"
    echo -e "Your Password: ${sspypwd}"
    echo -e "Your Encryption Method:aes-256-cfb"
    echo -e "==============================="
echo "Press any key to reboot the system"
read num
reboot
