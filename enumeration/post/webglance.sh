#!/bin/bash

## "All passive"
## uses DNS requests to public servers and queries to publicly available APIs

## $1 = the "output" name

# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf "Usage: ./webglance.sh '[Output Name]'\n \
Where 'Output Name' is a suffix you want to apply to generated files"
	exit 1
fi


# amass - for more subdomain enum
# this script used with Amass 3.4.4
# https://github.com/OWASP/Amass
gotEyeWitness=$(command -v eyewitness 2>/dev/null)
if [ ! "$gotEyeWitness" ]; then
	printf " [-] Error: EyeWitness binary not in PATH\n \
On Kali, it can be installed via apt-get install eyewitness'\n\n"
	exit 1
fi
unset gotEyeWitness


amass_ResolvedSubdomainOutput="amass_ResolvedSubdomains_$1.txt"
eyewitnessDir="$(pwd)/EyeWitness_Report_$1"

# does the found domain file exist?
if [ ! -f "$amass_ResolvedSubdomainOutput" ] || \
[ ! -s "$amass_ResolvedSubdomainOutput" ]
then
    printf "\n [-] Error: %s host file not found in current directory,\
 or is empty\n"  "$amass_ResolvedSubdomainOutput"
    exit 1
fi


if [ -d "$eyewitnessDir" ]; then

  printf "\n [-] Error: The %s directory already exists. \n\
 Please rename or remove it to continue.\n\n" "$eyewitnessDir"
exit 1
fi

## Eyewitness as an alternative, worst case scenario we get "unable to screenshot"
## Use this if no portscanning allowed

eyewitness --web --max-retries 3 -d "$eyewitnessDir" \
-f "$amass_ResolvedSubdomainOutput" --prepend-https --no-prompt


firefox "$eyewitnessDir/report.html" &

unset amass_RawSubdomainOutput eyewitnessDir
