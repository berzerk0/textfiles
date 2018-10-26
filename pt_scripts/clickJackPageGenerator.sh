#!/bin/sh

RED='\033[0;31m'
NC='\033[0m'


# Display error if not enough arguments given
if [ $# -ne 2 ]; then
              printf " ${RED}Usage: ${NC} ./clickjackPage.sh [OUTPUT DIRECTORY] \"[URL with http(s)]\"\n"
              exit 1
fi


if [ ! -d "$1" ]; then
  	printf " ${RED}ERROR: ${NC} Output Directory does not exist\nExiting now...\n"
	exit 1
fi


cjpage_url=$2

cjpage_filename="$1/clickJackTest_$(echo -n $2 | sed -e 's/:\/\//_/' | tr '.' '_').html"

cj_p1='<iframe src=\"'
cj_p2='\" width="750" height="750"></iframe>'

printf "<html>\n<head>\n<title>Clickjack Test</title>\n</head>\n<body>\n<h1> Clickjacking Test </h1>\n<br>\n" > $cjpage_filename
echo $cj_p1$cjpage_url$cj_p2 | tr -d '\\' >> $cjpage_filename
printf "</body>\n</head>\n" >> $cjpage_filename

firefox $cjpage_filename

unset RED GREEN cjpage_filename cjpage_url cj_p1 cj_p2
