#!/bin/bash

## $1 = the "output" name

# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf "Usage: ./webglance.sh '[Output Name]'\n \
Where 'Output Name' is a suffix you want to apply to generated files.\n"
	exit 1
fi


## is the EyeWitness binary present?
##
gotEyeWitness=$(command -v eyewitness 2>/dev/null)
if [ ! "$gotEyeWitness" ]
then
	printf " [-] Error: EyeWitness binary not in PATH\n \
On Kali, it can be installed via apt-get install eyewitness'\n\n"
	exit 1
fi
unset gotEyeWitness


amass_RawSubdomainOutput="amass_ResolvedSubdomains_$1.txt"
eyewitnessDir="$(pwd)/EyeWitness_Report_$1"


## assumes that in the input file comes from "subdomains_allpassive.sh"
hostFile="$amass_RawSubdomainOutput"
#change this to use a different file

# does the host file exist?
if [ ! -f "$hostFile" ] || [ ! -s "$hostFile" ]
then
    printf "\n [-] Error: %s host file not found in current directory,\
 or is empty\nCheck the host file on line 30\n"  "$hostFile"
    exit 1
fi


if [ -d "$eyewitnessDir" ]; then

  printf "\n [-] Error: The %s directory already exists. \n\
 Please rename or remove it to continue.\n\n" "$eyewitnessDir"
exit 1
fi

## Eyewitness worst case scenario we get "unable to screenshot"
## Use this if no portscanning allowed
eyewitness --web --max-retries 3 -d "$eyewitnessDir" \
-f "$hostFile" --prepend-https --no-prompt


printf "\n [+] EyeWitness complete!\n Find the report at\n %s\n" \
"$eyewitnessDir/report.html"

## open the html report
#firefox "$eyewitnessDir/report.html" &

unset amass_RawSubdomainOutput eyewitnessDir hostFile
