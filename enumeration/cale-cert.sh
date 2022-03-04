#!/bin/sh

# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf "\n ${RED}Error: ${NC} No domain provided \n\n"
  exit 1
fi

### CHECK FOR BINARIES

#Pup - # https://github.com/EricChiang/pup
gotPup=$(which pup 2>/dev/null)
if [ ! "$gotPup" ]; then
	printf " ${RED}Error: ${NC} ${YELLOW}pup${NC} binary not in PATH\n"
	exit 1
fi
unset gotPup

curl "https://crt.sh/?q=%25.$1" -s | pup 'tr tr td text{}' | grep "$1" | sort -u
