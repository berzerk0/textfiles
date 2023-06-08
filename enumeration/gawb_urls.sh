#!/bin/sh

# wrapper script to run gau and waybackurls at the same time
# often, these two tools produce redundant results. 
# sometimes they don't, so we'll just use both

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf "\n ${RED}Error: ${NC} No target provided \n\n"
  exit 1
fi

### CHECK FOR BINARIES

#gau - https://github.com/lc/gau
gotGau=$(command -v  gau 2>/dev/null)
if [ ! "$gotGau" ]; then
	printf " ${RED}Error: ${NC} ${YELLOW}gau${NC} binary not in PATH\n"
	exit 1
fi
unset gotGau

#waybackurls - https://github.com/tomnomnom/waybackurls
gotWaybackurls=$(command -v  waybackurls 2>/dev/null)
if [ ! "$gotWaybackurls" ]; then
	printf " ${RED}Error: ${NC} ${YELLOW}waybackurls${NC} binary not in PATH\n"
	exit 1
fi
unset gotWaybackurls

#no magic numbers
targetURL="$1"


#filename for the output files
timeNow=$(date "+%e%B%Y_%H%M" | tr -d ' ')
fileNameStub=$(echo "$targetURL"| tr '.' '_') #name for the output files
resultFileName=$(echo gawburls-"$fileNameStub"-"$timeNow".txt)

printf " [+] Running gau and waybackurls for ${YELLOW}%s${NC} in parallel...\n" "$targetURL"

# gau
# does _not_ look for subs, but it is possible to do so with the --subs flag
gau  "$targetURL" --o "$fileNameStub"-gau-scrapedURLs-"$timeNow".txt 1>/dev/null &

# waybackurls
# does _not_ look for subs, since we _DID_ add the -no-subs flag
waybackurls "$targetURL" -no-subs > "$fileNameStub"-waybackurls-scrapedURLs-"$timeNow".txt &

# wait until both processes have finished before sorting and 
wait 

#sort the output file for easier "comm" commands later
sort -o "$fileNameStub"-gau-scrapedURLs-"$timeNow".txt "$fileNameStub"-gau-scrapedURLs-"$timeNow".txt

#sort the output file for easier "comm" commands later
sort -o "$fileNameStub"-waybackurls-scrapedURLs-"$timeNow".txt "$fileNameStub"-waybackurls-scrapedURLs-"$timeNow".txt

# slap them together and sort them
cat "$fileNameStub"*-scrapedURLs-"$timeNow".txt | sort -u > "$resultFileName"

printf " [+] Done!\n\n"
printf "Found %s URLs for ${YELLOW}%s ${NC}\n" "$(wc -l "$resultFileName" | cut -d ' ' -f 1)" "$targetURL"

unset fileNameStub timenow resultFileName RED YELLOW NC


