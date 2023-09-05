#!/bin/bash

# thanks https://gist.github.com/dualfade/7a7c88398ca04ebb1aaf669df897e242!


RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
ORANGE='\033[0;33m'
NC='\033[0m'



# $1 = file to read from
# no magic numbers
inputFile="$1"


# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf "Usage: ./resolveAndCheckForWeb.sh [Hosts File] \n \
Where the Hosts File has one domain/subdomain per line \n"
	exit 1
fi

# #NOTE: check for go --
# if test go; then
#     if [[ -z ${GOPATH} ]]; then
#         echo "=> \$GOPATH is not set"
#         echo "=> please set \$GOPATH"
#         echo "=> mkdir -p \$HOME/Workspace ; export GOPATH=\$HOME/Workspace"
#         echo "=> export PATH=\$PATH:\$GOPATH/bin"
#         echo "=> you may want to set these permanently in your ~/.bashrc or ~/.zshrc"
#         exit
#     fi
# else
#     echo "=> go not found"
#     echo "=> please install go"
#     exit
# fi

#NOTE: required binaries --
# if test httpx || test dnsx || test jq || true; then


#dnsx check
# go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
if [[ ! $(command -v dnsx) ]]; then
    printf "[${RED}FTL${NC}] Error: ${YELLOW}dnsx${NC} binary not in PATH\n\n"
    echo "=> install dnsx -> go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
    exit
fi

#httpx check
# go install -v github.com/projectdiscovery/httpx/v2/cmd/httpx@latest
if [[ ! $(command -v httpx) ]]; then
    printf "[${RED}FTL${NC}] Error: ${YELLOW}httpx${NC}  binary not in PATH\n\n"
    exit
fi


#jq check
if [[ ! $(command -v jq) ]]; then
    printf "[${RED}FTL${NC}] Error: ${YELLOW}jq${NC} binary not in PATH\n\n"
    # echo "=> install jq -> sudo apt install jq"
    # echo "=> install jq -> sudo pacman -Sy jq"
    exit
fi


#set some constants for filenames
the_date=$(date "+%e%B%Y_%H%M")

#dnsx filenames
dnsx_full_json=${PWD}/dnsx-$inputFile_${the_date}_full.json
dnsx_subdos_txt=${PWD}/dnsx-$inputFile_${the_date}_subdos.txt
dnsx_ips_txt=${PWD}/dnsx-$inputFile_${the_date}_ips.txt
dnsx_cnames_json=${PWD}/dnsx-$inputFile_${the_date}_cnames.json

httpx_full_json=${PWD}/httpx-$inputFile_${the_date}_full.json
httpx_urls_txt=${PWD}/httpx-$inputFile_${the_date}_urls.txt


#RATE LIMIT OR GET IN TROUBLE!
rate="25"

inputFileLength=$(wc -l "$inputFile" | cut -d ' ' -f 1)


#perform DNS resolution to see if the hosts have IPs
printf "Attempting to resolve ${YELLOW}%s${NC} domains with dnsx...\n" "$inputFileLength"

dnsx_status=$(dnsx -l "$inputFile" -rl "$rate" -silent -a -cname -json -o "${dnsx_full_json}")
  if [[ "$dnsx_status" == 0 ]]; then
      printf " [${RED}FTL${NC}] Error: ${YELLOW}dnsx${NC} failed! :(\n\n"
      exit 1
  else
  	#parse out subdomains using jq and .host
  	jq '.host' -r < "$dnsx_full_json" | sort -u > "$dnsx_subdos_txt"
  	#parse out ips using jq and .a
  	jq '.a' -r < "$dnsx_full_json" | sort -u > "$dnsx_ips_txt"
  	#parse out cnames using jq and .cname
  	jq '.cname' -r < "$dnsx_full_json" | sort -u > "$dnsx_cnames_json"

  	#how many resolved hosts?
  	numResolvedHosts=$(wc -l "$dnsx_full_json" | cut -d ' ' -f 1)

    printf "${GREEN}[+]${NC} dnsx resolved ${GREEN}%s${NC} hosts out of ${YELLOW}%s${NC} provided\n" "$numResolvedHosts" "$inputFileLength"

    printf "  ${GREEN}[+]${NC} Wrote ${GREEN}full${NC} results to ${GREEN}%s${NC}\n" "$dnsx_full_json"
    printf "  ${GREEN}[+]${NC} Wrote list of ${CYAN}subdomains${NC} to ${CYAN}%s${NC}\n" "$dnsx_subdos_txt"
    printf "  ${GREEN}[+]${NC} Wrote list of IP addresses to %s\n" "$dnsx_ips_txt"
    printf "  ${GREEN}[+]${NC} Wrote list of ${ORANGE}CNAME'd hosts${NC} addresses to ${ORANGE}%s${NC}\n" "$dnsx_cnames_json"

  fi


#identify webservers at the resolved domains with httpx
printf "\n\nIdentifying webservers on ${YELLOW}%s${NC} resolved domains with httpx...\n" "$numResolvedHosts"

# look like a regular browser
Edge_UA="User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36 Edge/18.19582"

httpx_status=$(httpx -l "$dnsx_subdos_txt" -silent -rl "$rate" -H "$Edge_UA" -json -o "$httpx_full_json")
  if [[ "$httpx_status" == 0 ]]; then
      printf " [${RED}FTL${NC}] Error: ${YELLOW}httpx${NC} failed! :(\n\n"
      exit 1
  else
  	#parse out urls using jq and .url
  	jq '.url' -r < "$httpx_full_json" | sort -u > "$httpx_urls_txt"
  	# #parse out ips using jq and .a
  	# jq '.a' -r < "${httpx_full_json}" | sort -u > "$httpx_ips_txt"

  	#how many URLs?
  	numURLs=$(wc -l "$httpx_full_json" | cut -d ' ' -f 1)

      printf "${GREEN}[+]${NC} httpx identified ${GREEN}%s${NC} URLs from the ${YELLOW}%s${NC} domains resolved\n" "$numURLs"  "$numResolvedHosts"
      printf "  ${GREEN}[+]${NC} Wrote ${RED}full${NC} results to ${RED}%s${NC}\n" "$httpx_full_json"
      printf "  ${GREEN}[+]${NC} Wrote list of ${CYAN}URLs${NC} to ${YELLOW}%s${NC}\n" "$httpx_urls_txt"

  fi



