#!/bin/sh

# $1 = hosts file, one hostname per line

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
NC="\033[0m"


# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf " ${RED}Usage: ${NC} ./tlstriad.sh HOSTSFILE\nHosts file must have one hostname per line.\n"
	exit 1
fi

if [ ! -f "$1" ]; then
printf " ${RED}Error: ${NC} Hosts file not found\n"
	exit 1
fi


tlstriad_thisdir=$(pwd)/tlstriad_results

if [ -d "$tlstriad_thisdir" ]; then
	printf " ${RED}Error: ${NC} Directory already exists.\n Delete${YELLOW} %s\n${NC}" "$tlstriad_thisdir"
	exit 1
fi

# Create host directories
#tlstriad_numOfHosts=$(grep -Evc '^\s*$' "$1" | cut -d ' ' -f 1)
tlstriad_numOfHosts=$(grep -Evc '^\s*$' "$1")

mkdir "$tlstriad_thisdir"

#tlstriad_hosts

#for i in $(cat "$1"| grep -Ev '^\s*$');
grep -Ev '^\s*$' "$1" | while IFS= read -r line
do
		tlstriad_url="$line"  #URL
    tlstriad_cleanname=$(echo "$line" | tr '.' '_') #name for files/dirs (no dits)
		mkdir "$tlstriad_thisdir"/"$tlstriad_cleanname" # create host results directory
done


printf "\nRetrieving TLS certificates from ${GREEN}%s${NC} target(s):\n\n" "$tlstriad_numOfHosts"

# Fetch SSL certificates for each
#grep -Ev '^\s*$' "$1" | while IFS= read -r line
grep -Ev '^\s*$' "$1" | while IFS= read -r line
do
	tlstriad_url="$line" #URL
  tlstriad_cleanname=$(echo "$line" | tr '.' '_') #name for files/dirs (no dits)

	printf "   Retrieving  ${YELLOW}%s${NC}'s TLS certificate...\n" "$tlstriad_url"
  echo | openssl s_client -showcerts -servername "$line" -connect "$line":443 2>/dev/null  | openssl x509 -inform pem -noout -text 2>/dev/null > "$tlstriad_thisdir"/"$tlstriad_cleanname"/certSSL_"$tlstriad_cleanname".txt

done

printf "\n--------Certificate Retrieval Complete---------\n"

printf "\nBeginning ${GREEN}sslscan${NC} on ${GREEN}%s${NC} target(s):\n\n" "$tlstriad_numOfHosts"

# Run sslscan on targets
grep -Ev '^\s*$' "$1" | while IFS= read -r line
do
	tlstriad_url="$line" #URL
	tlstriad_cleanname=$(echo "$line" | tr '.' '_') #name for files/dirs (no dits)
	printf "   Running sslscan on ${YELLOW}%s${NC}...\n" "$tlstriad_url"

	#Run sslcan, save output to hosts cleanname
	sslscan --no-colour "$tlstriad_url" > "$tlstriad_thisdir"/"$tlstriad_cleanname"/scan_sslscan_"$tlstriad_cleanname".txt
done

printf "\n--------sslscans Complete---------\n"


printf "\nBeginning ${GREEN}sslyze${NC} on ${GREEN}%s${NC} target(s):\n\n" "$tlstriad_numOfHosts"



#Run sslyze on targets, save html and "log" style output
grep -Ev '^\s*$' "$1" | while IFS= read -r line
do
	tlstriad_url="$line"  #URL
	tlstriad_cleanname=$(echo "$line" | tr '.' '_') #name for files/dirs (no dits)
	printf "   Running sslyze on ${YELLOW}%s${NC}...\n" "$tlstriad_url"


	sslyze --regular "$tlstriad_url" > "$tlstriad_thisdir"/"$tlstriad_cleanname"/yze_sslyze_"$tlstriad_cleanname".txt

done

printf "\n--------sslyze scans Complete---------\n"





# printf "\nBeginning ${GREEN}testssl${NC} on ${GREEN}%s${NC} target(s):\n\n" "$tlstriad_numOfHosts"
#
#
#
# #Run testssl on targets, save html and "log" style output
# for i in $(cat "$1"| grep -Ev '^\s*$');
# do
# 	tlstriad_url="$line"  #URL
# 	tlstriad_cleanname=$(echo $i | tr '.' '_') #name for files/dirs (no dits)
# 	printf "   Running testssl on ${YELLOW}%s${NC}...\n" "$tlstriad_url"
#
# 	# Run testssl, save html and "log" outputs in host results directory
# 	 /opt/Web_Tools/testssl.sh/testssl.sh -oL $tlstriad_thisdir/$tlstriad_cleanname/testssl_$tlstriad_cleanname.log -oH $tlstriad_thisdir/$tlstriad_cleanname/testssl_$tlstriad_cleanname.html $tlstriad_url > /dev/null 2>&1
# 	#/opt/Web_Tools/testssl.sh/testssl.sh -oL $tlstriad_thisdir/$tlstriad_cleanname/testssl_$tlstriad_cleanname.log -oH $tlstriad_thisdir/$tlstriad_cleanname/testssl_$tlstriad_cleanname.html $tlstriad_url
# done
#
# printf "\n--------testssl scans Complete---------\n"

unset tlstriad_thisdir tlstriad_url tlstriad_cleanname

printf "\n--------Process Completed---------\n"
