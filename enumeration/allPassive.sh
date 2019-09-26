#!/bin/bash

## All passive, just DNS requests to public servers and HTTP GET requests
## $1 = the "output" name

# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	echo "Usage: ./allPassive.sh 'Output Name'"
  echo "Where 'Output Name' is a suffix you want to apply to generated files"
	exit 1
fi

## starter domains - the 'seed' domains with which to start with

foundDomainFile="found_Domains_$1.txt"
amassDomainFile="amass_Domains_$1.txt"
amassDomainLog="amass_Domains_$1.log"
findomain_RawSubFile="findomain_RawSubdomains_$1.txt"
amass_RawSubdomainOutput="amass_RawSubdomains_$1"
amass_LiveSubdomainOutput="amass_LiveSubdomains_$1"


## amass intel to find domains

/opt/amass/amass_v3.1.6_linux_amd64/amass intel -whois -df starter_domains.txt \
-log "$amassDomainLog" -dir "$(pwd)" -src && mv amass.txt "$amassDomainFile" \
&& tr -s ' ' < "$amassDomainFile" | cut -d ' ' -f 2 >> "$foundDomainFile"


# Copy and paste results from ViewDNS.info since I am new to webscraping
# and manually fetch viewDNS domains

vDNS_file="VDNS_rWhois_$1.txt"

if [[ -f "$vDNS_file" ]]; then
    cat "$vDNS_file" >> "$foundDomainFile"
fi

unset vDNS_file



## concatenate found domains
sort -u "$foundDomainFile" > tmp && mv tmp "$foundDomainFile"

## Use findomain to grab some subdomains a little bit quicker than amass will
findomain -f "$foundDomainFile" -u "$findomain_RawSubFile"

## using found domains, use Amass to find more subdomains
## include those already found by findomain
## this step does not include brute forcing subdomains
## Use this when going purely passive
/opt/amass/amass_v3.1.6_linux_amd64/amass enum -passive -oA \
"$amass_RawSubdomainOutput" -df "$foundDomainFile" -nf "$findomain_RawSubFile"

## Using the passively enumerated subdomains, use amass AGAIN
## to resolve subdomains, and do subdomain bruteforcing
/opt/amass/amass_v3.1.6_linux_amd64/amass enum -brute --public-dns -oA \
"$amass_LiveSubdomainOutput" -df "$foundDomainFile" \
-nf "$amass_RawSubdomainOutput.txt"



## aquatone - not purely passive, seems to require portscanning
# cat "$amass_LiveSubdomainOutput.txt" | /opt/aquatone/aquatone -ports "xlarge"

## Eyewitness as an alternative, worst case scenario we get "unable to screenshot"
## Use this if  no portscanning allowed

python /opt/EyeWitness/EyeWitness.py --web --max-retries 3 \
-d "$(pwd)/Eyewitness_Report" -f "$amass_LiveSubdomainOutput.txt" --prepend-https

unset foundDomainFile
unset amassDomainFile
unset amassDomainLog
unset findomain_RawSubFile
unset amass_RawSubdomainOutput
unset amass_LiveSubdomainOutput
