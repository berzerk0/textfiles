#!/bin/bash
# $1 domains file, one per line

#this is not a particularly reliable method

for i in $(cat "$1")
do

	# get whois record
	whoisRes=$(whois "$i")

	#if record exists (not a comprehensive list)
	foundCheck=$(echo "$whoisRes" | grep -iE 'not found|no match|no entries found|no object found|domain unknown| the queried object does not exist| Domain Status: free')

	# Check for registrant information
	grepCheck=$(echo "$whoisRes" | grep -iE 'REGISTRANT_REGEX_GOES_HERE')

	#if both conditions are met, add to list
	if [ ! "$foundCheck" ] && [ "$grepCheck" ]; then

		echo "$i" >> verified_domains.txt

	fi


done

unset whoisRes
unset foundcheck
unset grepcheck

sort -u verified_domains.txt > tmp; mv tmp verified_domains.txt
