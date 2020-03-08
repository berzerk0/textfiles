#!/bin/bash
# $1 domains file, one per line

#this is NOT a particularly reliable method


## Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf "Usage: ./domainVerify.sh 'INPUTFILE' \n\
Where the input file has one domain per line \n\
Note that the registrant regex will need to be adjusted on line 54"
	exit 1
fi

verifiedFile="verified_domains.txt"
tempfile="$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 12 | head -1)"

inFile="$1"

# does the domain file exist?
if [ ! -f "$inFile" ] || [ ! -s "$inFile" ]
then
    printf "\nError: %s domain file not found in current directory, \
or is empty\n" "$inFile"
    exit 1
fi

# does the verified domain file already exist?
if [ -f "$verifiedFile" ]
then
  printf "\nError: The %s file already exists. \n\
Please rename or remove it to continue.\n\n" "$verifiedFile"
exit 1
fi



printf "Attempting to verify %s domains from %s...\n\n" \
"$(wc -l "$inFile" | cut -d ' ' -f 1)" "$inFile"

#iterate though input file
for i in $(cat "$inFile")
do

	# get whois record
	# > /dev/null 2>&1 breaks the script
	whoisRes=$(whois "$i")

	#if record exists (not a comprehensive list)
	#this logic looks for records that do NOT exist
	foundCheck=$(echo "$whoisRes" | grep -iE 'not found|no match|no entries found|no object found|domain unknown| the queried object does not exist| Domain Status: free')

	# Check for registrant information
	regex="REGISTRANT_REGEX_GOES_HERE"
	grepCheck=$(echo "$whoisRes" | grep -iE "$regex")


	#if both conditions are met, add to list
	if [ ! "$foundCheck" ] && [ "$grepCheck" ]
	then

		#write record to file
		echo "$i" >> "$verifiedFile"
	fi

done

#if no domains could be verified
if [ ! -f "$verifiedFile" ] || [ ! -s "$verifiedFile" ]
then
	printf "\nNo domains from %s could be verified.\nCheck the regex on line 54\n\n"\
	 "$inFile"
	exit 1

else
	#remove duplicates
	sort -u "$verifiedFile" > "$tempfile"
	mv "$tempfile" "$verifiedFile"

	printf "\n%s domains from %s were verified.\n\nSee %s\n\n" \
  "$(wc -l "$verifiedFile" | cut -d ' ' -f 1)" "$inFile" "$verifiedFile"
fi


unset whoisRes foundcheck grepcheck tempfile inFile verifiedFile regex
