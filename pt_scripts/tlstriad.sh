#!/bin/sh

# $1 = hosts file, one hostname per line

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'


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
	printf " ${RED}Error: ${NC} Directory already exists.\n Delete${YELLOW} $tlstriad_thisdir\n${NC}"
	exit 1
fi

# Create host directories
tlstriad_numOfHosts=$(egrep -v '^\s*$' $1 | wc -l | cut -d ' ' -f 1)


mkdir $tlstriad_thisdir

tlstriad_hosts

for i in $(cat $1 | egrep -v '^\s*$');
do
		tlstriad_url=$i #URL
    tlstriad_cleanname=$(echo $i | tr '.' '_') #name for files/dirs (no dits)
		mkdir $tlstriad_thisdir/$tlstriad_cleanname # create host results directory
done


printf "\nRetrieving TLS certificates from ${GREEN}$tlstriad_numOfHosts${NC} target(s):\n\n"

# Fetch SSL certificates for each
for i in $(cat $1 | egrep -v '^\s*$');
do
	tlstriad_url=$i #URL
  tlstriad_cleanname=$(echo $i | tr '.' '_') #name for files/dirs (no dits)

	printf "   Retrieving  ${YELLOW}$tlstriad_url${NC}'s TLS certificate...\n"
  echo | openssl s_client -showcerts -servername $i -connect $i:443 2>/dev/null | openssl x509 -inform pem -noout -text 2>/dev/null > $tlstriad_thisdir/$tlstriad_cleanname/sslcert_$tlstriad_cleanname.txt
done

printf "\n--------Certificate Retrieval Complete---------\n"


#for i in $(cat $1 | egrep -v '^\s*$');
#do
#	tlstriad_url=$i #URL
#	tlstriad_cleanname=$(echo $i | tr '.' '_') #name for files/dirs (no dits)
#	printf "   Checking for HSTS on ${YELLOW}$tlstriad_url${NC}...\n"

#	#Run sslcan, save output to hosts cleanname
#	tlstriad_HSTS=$(curl -s -D- $tlstriad_url  | grep -Ei  '^strict')

#	if [ "tlstriad_HSTS" ]; then
#		printf "   HSTS ${GREEN} found ${NC} on ${YELLOW}$tlstriad_url${NC}...\n"
#	else
#		printf "   HSTS ${RED} not found ${NC} on ${YELLOW}$tlstriad_url${NC}...\n"
#	fi


#done


printf "\nBeginning ${GREEN}sslscan${NC} on ${GREEN}$tlstriad_numOfHosts${NC} target(s):\n\n"

# Run sslscan on targets
for i in $(cat $1 | egrep -v '^\s*$');
do
	tlstriad_url=$i #URL
	tlstriad_cleanname=$(echo $i | tr '.' '_') #name for files/dirs (no dits)
	printf "   Running sslscan on ${YELLOW}$tlstriad_url${NC}...\n"

	#Run sslcan, save output to hosts cleanname
	sslscan --no-colour $tlstriad_url > $tlstriad_thisdir/$tlstriad_cleanname/sslscan_$tlstriad_cleanname.txt
done

printf "\n--------sslscans Complete---------\n"
printf "\nBeginning ${GREEN}testssl${NC} on ${GREEN}$tlstriad_numOfHosts${NC} target(s):\n\n"



#Run testssl on targets, save html and "log" style output
for i in $(cat $1 | egrep -v '^\s*$');
do
	tlstriad_url=$i #URL
	tlstriad_cleanname=$(echo $i | tr '.' '_') #name for files/dirs (no dits)
	printf "   Running testssl on ${YELLOW}$tlstriad_url${NC}...\n"

	# Run testssl, save html and "log" outputs in host results directory
	testssl -oL $tlstriad_thisdir/$tlstriad_cleanname/testssl_$tlstriad_cleanname.log -oH $tlstriad_thisdir/$tlstriad_cleanname/testssl_$tlstriad_cleanname.html $tlstriad_url > /dev/null 2>&1
done

printf "\n--------testssl scans Complete---------\n"

unset tlstriad_thisdir
unset tlstriad_url
unset tlstriad_cleanname

printf "\n--------Process Completed---------\n"
