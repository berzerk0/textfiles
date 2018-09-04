#!/bin/sh

# $1 = hosts file, one hostname per line

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'


# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf " ${RED}Usage: ${NC} ./tlspair.sh HOSTSFILE\nHosts file must have one hostname per line.\n"
	exit 1
fi

if [ ! -f $1 ]; then
printf " ${RED}Error: ${NC} Hosts file not found\n"
	exit 1
fi



tlspair_thisdir=$(pwd)/tlspair_results

if [ -d "$tlspair_thisdir" ]; then
	printf " ${RED}Error: ${NC} Directory already exists.\n Delete${YELLOW} $tlspair_thisdir\n${NC}"
	exit 1
fi

tlspair_numOfHosts=$(egrep -v '^\s*$' $1 | wc -l | cut -d ' ' -f 1)

mkdir $tlspair_thisdir

printf "Beginning ${GREEN}sslscan${NC} on ${GREEN}$tlspair_numOfHosts${NC} target(s):\n\n"

# Run sslscan on targets
for i in $(cat $1 | egrep -v '^\s*$'); 
do
	tlspair_url=$i #URL 
	tlspair_cleanname=$(echo $i | tr '.' '_') #name for files/dirs (no dits)
	printf "   Running sslscan on ${YELLOW}$tlspair_url${NC}...\n"

	mkdir $tlspair_thisdir/$tlspair_cleanname # create host results directory

	#Run sslcan, save output to hosts cleanname
	sslscan --no-colour $tlspair_url > $tlspair_thisdir/$tlspair_cleanname/sslscan_$tlspair_cleanname.txt;
done

printf "\n--------sslscans Complete---------\n"
printf "\nBeginning ${GREEN}testssl${NC} on ${GREEN}$tlspair_numOfHosts${NC} target(s):\n\n"



#Run testssl on targets, save html and "log" style output
for i in $(cat $1 | egrep -v '^\s*$');
do
	tlspair_url=$i #URL 
	tlspair_cleanname=$(echo $i | tr '.' '_') #name for files/dirs (no dits)
	printf "   Running testssl on ${YELLOW}$tlspair_url${NC}...\n" 
	
	# Run testssl, save html and "log" outputs in host results directory
	testssl -oL $tlspair_thisdir/$tlspair_cleanname/testssl_$tlspair_cleanname.log -oH $tlspair_thisdir/$tlspair_cleanname/testssl_$tlspair_cleanname.html $tlspair_url > /dev/null 2>&1
done

printf "\n--------testssl scans Complete---------\n"

unset tlspair_thisdir
unset tlspair_url
unset tlspair_cleanname

printf "\n--------Process Completed---------\n"
