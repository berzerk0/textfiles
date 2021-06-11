#!/bin/sh

## clickJackPageGenerator.sh

#This script generates a generic clickjacking test page (just an iframe of a chosen URL)
#The file is saved in the chosen directory and then opened in firefox.

RED="\033[0;31m"
NC="\033[0m"


# Display error if not enough arguments given
if [ $# -ne 2 ]; then
              printf " ${RED}Usage: ${NC} ./clickjackPage.sh [OUTPUT DIRECTORY] \"[URL with http(s)]\"\n"
              exit 1
fi


#output dir from argument 1
cjpage_outputLoc="$1"

#Quit if output directory does not exist
if [ ! -d "$cjpage_outputLoc" ]; then
  	printf " ${RED}ERROR: ${NC} Output Directory does not exist\nExiting now...\n"
	exit 1
fi



#URL from argument 2
cjpage_url="$2"
cj_cleanurl=$(echo "$cjpage_url" | sed -e 's/[\/:=\?\&]/_/g' | tr '.' '_' | tr -s '_')


#Bootleg creation of filename
cjpage_filename=$(printf "%s/TestPageClickJacking_%s.html" "$cjpage_outputLoc" "$cj_cleanurl")

#print the header to the file
printf "<html>\n<head>\n<title>Clickjacking Test Page</title>\n</head>\n\n<body>\n<h1>Clickjacking Test Page</h1>\n\n<br>\n\n" > "$cjpage_filename"


#Bootleg method of assembling the iframe line
cj_p1='<iframe src=\"'
cj_p2='\" width="750" height="750" '
cj_p3='sandbox="allow-forms allow-popups allow-pointer-lock allow-same-origin allow-scripts">'
cj_p4="</iframe>"

#assemble (in a bootleg way) the iframe line and print it to the file
printf "%s<br><br>%s%s%s\n%s\n%s" "$cjpage_url" "$cj_p1" "$cjpage_url" "$cj_p2" "$cj_p3" "$cj_p4"| tr -d '\\' >> "$cjpage_filename"

#print the footer to the file
printf "\n\n</body>\n</html>\n" >> "$cjpage_filename"

#Open the page in firefox
firefox "$cjpage_filename" &

#Cleanup
unset RED NC cjpage_filename cjpage_url cj_p1 cj_p2 cj_p3 cj_p4
