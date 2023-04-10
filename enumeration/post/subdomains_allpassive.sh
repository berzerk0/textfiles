#!/bin/bash

## "All passive"
## uses DNS requests to public servers and queries to publicly available APIs

## $1 = the "output" name

# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf "Usage: ./subdomains_allpassive.sh '[Output Name]'\n \
Where 'Output Name' is a suffix you want to apply to generated files"
	exit 1
fi

#findomain - for fast subdomain enum
# https://github.com/Edu4rdSHL/findomain
gotFindomain=$(command -v findomain 2>/dev/null)
if [ ! "$gotFindomain" ]; then
	printf "[-] Error: findomain binary not in PATH\n\n"
	exit 1
fi
unset gotFindomain

# amass - for more subdomain enum
# this script used with Amass 3.4.4
# https://github.com/OWASP/Amass
gotAmass=$(command -v amass 2>/dev/null)
if [ ! "$gotAmass" ]; then
	printf " [-] Error: amass binary not in PATH\n \
Using the precompiled Amass binary from GitHub has been more \
reliable than installing with 'apt-get' from Kali repos.\n\n"
	exit 1
fi
unset gotAmass


domainFile="domains_$1.txt"
findomain_RawSubFile="findomain_RawSubdomains_$1.txt"
candidate_SubFile="candidateSubdomains_$1.txt"
amass_RawSubdomainOutput="amass_RawSubdomains_$1"
amass_ResolvedSubdomainOutput="amass_ResolvedSubdomains_$1"
findomainQuestion=$'Would you like to use findomain before amass?

findomain can be used to identify subdomains much more quickly than Amass can
but you will not be able to tell what technique (Scraping, APIs, etc.) was
used to identify subdomains found with findomain.\n
Yes or no: '
tempfile="$(tr -dc 'A-Z0-9a-z' < /dev/urandom | fold -w 12 | head -1)"
allResolved_SubdomainFile="resolvedSubdomains_all_$1.txt"


# does the found domain file exist?
if [ ! -f "$domainFile" ] || [ ! -s "$domainFile" ]
then
    printf "%s domain file not found in current directory, or is empty\n" \
 "$domainFile"
    exit 1
fi

#is a file of existing candidate subdomains present?
# if not, create an empty one
if [ ! -f "$candidate_SubFile" ]
then
	echo "" > "$candidate_SubFile"
else
	printf " [+] Importing %s candidate subdomains from %s\n\n" \
  "$(wc -l "$candidate_SubFile" | cut -d ' ' -f 1)" "$candidate_SubFile"
fi

# has this been run before? if so, add the raw results to the candidate list
if [ -f "$amass_RawSubdomainOutput.txt" ]
then
	cat "$amass_RawSubdomainOutput.txt" >> "$candidate_SubFile"
fi



# ask user if they want to run findomain before amass
# if it finds anything, add it to the candidate list
read -p "$findomainQuestion" findomainFlag

# keep asking if they don't answer yes or no
while [ "$findomainFlag" != "yes" ] && [ "$findomainFlag" != "no" ]
  do
    read -p "$findomainQuestion" findomainFlag
  done

unset findomainQuestion

#if user answered yes, run findomain
if [ "$findomainFlag" == "yes" ]; then
  ## Use findomain to passively get some subdomains faster quicker than amass
  printf " [+] Running findomain for %s domain(s)... \n" \
  "$(wc -l "$domainFile" | cut -d ' ' -f 1)"

  findomain -f "$domainFile" -u "$findomain_RawSubFile"

	if [ -s "$findomain_RawSubFile" ]
	then

		printf "\n [+] findomain identified %s domains \n\n" \
	  "$(wc -l "$findomain_RawSubFile" | cut -d ' ' -f 1)"

		#add the findomain found domains to the candidate subdomains file

		cat "$findomain_RawSubFile" >> "$candidate_SubFile"


	else
		#findomain didn't find anything
		printf "\n [+] findomain identified 0 domains \n\n"
	fi

fi

## sort and uniq candidate subdomains supplied from findomain and elsewhere
sort -u "$candidate_SubFile" > "$tempfile"
mv "$tempfile" "$candidate_SubFile"

printf "\n [+] Passively enumerating subdomains with Amass... \n"
printf " [+] Brute forcing and DNS resolution will NOT be performed at \
this stage... \n"

## use Amass to find more subdomains of the domains supplied
## include those already identified previously and found by findomain
## this step does not include brute forcing or dns resolution

amass enum -passive -oA "$amass_RawSubdomainOutput" -df "$domainFile" \
  -nf "$candidate_SubFile"


printf "\n [+] Amass passively identified %s unverified subdomains \n\n" \
"$(wc -l "$amass_RawSubdomainOutput.txt" | cut -d ' ' -f 1)"


## combine the newly identified results with the existing candidate file
if [ -f "$amass_RawSubdomainOutput.txt" ] && \
[ -s "$amass_RawSubdomainOutput.txt" ]
then
	cat "$amass_RawSubdomainOutput.txt" >> "$candidate_SubFile"
	sort -u "$candidate_SubFile" > "$tempfile"
	mv "$tempfile" "$candidate_SubFile"
fi


printf " [+] Performing subdomain enumeration to find/resolve subdomains \
with Amass... \n"

## the public dns servers here are a top 10
## (and alternate) list from March 2020
dns_servers="8.8.8.8,8.8.4.4,9.9.9.9,149.112.112.112,208.67.222.222,\
208.67.220.220,1.1.1.1,1.0.0.1,185.228.168.9,185.228.169.9,64.6.64.6,\
64.6.65.6,198.101.242.72,23.253.163.53,176.103.130.130,176.103.130.131,\
84.200.69.80,84.200.70.40,8.26.56.26,8.20.247.20,205.171.3.66,205.171.202.166,\
81.218.119.11,209.88.198.133,195.46.39.39,195.46.39.40,66.187.76.168,\
147.135.76.183,216.146.35.35,216.146.36.36,45.33.97.5,37.235.1.177,\
77.88.8.8,77.88.8.1,91.239.100.100,89.233.43.71,74.82.42.42,109.69.8.51,\
156.154.70.1,156.154.71.1,45.77.165.194,99.192.182.100,99.192.182.101"


## Using the passively enumerated subdomains, use amass AGAIN
## to resolve subdomains, and do subdomain bruteforcing
## the noalts flag is used, so no mutation is performed
amass enum -brute -r "$dns_servers" -oA "$amass_ResolvedSubdomainOutput" \
-df "$domainFile" -nf "$candidate_SubFile" -noalts

#print total number of subdomains identified
printf "\n\n [+] Amass found %s total (unresolved and resolved) subdomains, \
see %s \n\n" "$(wc -l "$amass_RawSubdomainOutput.txt" | cut -d ' ' -f 1)" \
"$amass_RawSubdomainOutput.txt"

#print number of resolved subdomains identified
printf " [+] Amass resolved %s of those subdomains, see %s\n\n" \
"$(wc -l "$amass_ResolvedSubdomainOutput.txt" | cut -d ' ' -f 1)" \
"$amass_ResolvedSubdomainOutput.txt"

cat "$amass_ResolvedSubdomainOutput.txt" >> "$allResolved_SubdomainFile"

sort -u "$allResolved_SubdomainFile" > "$tempfile"
mv "$tempfile" "$allResolved_SubdomainFile"

printf " [+] In total, Amass has resolved %s subdomains for this target,\
 see %s\n\n" "$(wc -l "$allResolved_SubdomainFile" | cut -d ' ' -f 1)" \
 "$allResolved_SubdomainFile"


unset amass_RawSubdomainOutput findomainFlag findomain_RawSubFile tempfile
unset domainFile amass_ResolvedSubdomainOutput dns_servers candidate_SubFile
