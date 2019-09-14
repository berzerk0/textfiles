#!/bin/bash

#$1 = possible usernames, one per line
# This would be way better as a python script that parses json, I'll whip one of those up one day

# The service starts getting annoyed with you very quickly with this script, an alternative
# that uses the API is needed


filename=result_InstagramEnum_$(echo "$1" | rev | cut -d '/' -f 1 | rev).csv
tempFile="tempFileInstagramEnum"

echo "Validating $(wc -l "$1" | cut -d ' ' -f 1) potential Instagram accounts..."

for i in $(cat "$1")
do
	url="https://www.instagram.com/$i/"

	#get http status of possible account
	status=$(curl -H $'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36 Edge/18.17763' -s -o /dev/null -w "%{http_code}" "$url")

	#if account exists, check certain options
	
	if [ "$status" = "200" ]; then
	
		# download response to get request
		curl -H $'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36 Edge/18.17763' -s  "$url" > "$tempFile"

		isPrivate=$(grep -Eo '"is_private":[a-z]{,4}e' "$tempFile")
		isVerified=$(grep -Eo '"is_verified":[a-z]{,4}e' "$tempFile")
		isBusinessAccount=$(grep -Eo '"is_business_account":[a-z]{,4}e' "$tempFile")
		
	
		echo "$status","$i","$isPrivate","$isVerified","$isBusinessAccount","$url" >> "$filename"

		unset isPrivate
		unset isVerified
		unset isBusinessAccount
		rm "$tempFile"

	
	# if status not equal to 200
	else
		if [ "$status" = "404" ]; then 

			echo "$status","$i",404,"$url" >> "$filename"	
		else
			echo "$status","$i",other,"$url" >> "$filename"
		fi
	fi
	
	unset status
	unset url
	
done

sort -u "$filename" > tmp && mv tmp "$filename"

unset filename
