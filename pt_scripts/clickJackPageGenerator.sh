#!/bin/sh

#This script generates a generic clickjacking test page (just an iframe of a chosen URL)
#The file is saved in the chosen directory and then opened in firefox.



RED='\033[0;31m'
NC='\033[0m'


# Display error if not enough arguments given
if [ $# -ne 2 ]; then
              printf " ${RED}Usage: ${NC} ./clickjackPage.sh [OUTPUT DIRECTORY] \"[URL with http(s)]\"\n"
              exit 1
fi


#Quit if output directory does not exist
if [ ! -d "$1" ]; then
  	printf " ${RED}ERROR: ${NC} Output Directory does not exist\nExiting now...\n"
	exit 1
fi

#URL from argument 2
cjpage_url=$2

#Bootleg creation of filename
cjpage_filename="$1/clickJackTest_$(echo -n $2 | sed -e 's/:\/\//_/' | tr '.' '_').html"

#Bootleg method of assembling the iframe line
cj_p1='<iframe src=\"'
cj_p2='\" width="750" height="750"></iframe>'

#print all the constants to the file (yes the newlines are optional)
printf "<html>\n<head>\n<title>Clickjack Test</title>\n</head>\n<body>\n<h1> Clickjacking Test </h1>\n<br>\n" > $cjpage_filename

#assemble the iframe line
echo $cj_p1$cjpage_url$cj_p2 | tr -d '\\' >> $cjpage_filename
printf "</body>\n</head>\n" >> $cjpage_filename

#Open the page in firefox
firefox $cjpage_filename

#Cleanup
unset RED NC cjpage_filename cjpage_url cj_p1 cj_p2
