#!/bin/bash

#$1 = possible usernames, one per line



filename=result_twitterEnum_$(echo "$1" | rev | cut -d '/' -f 1 | rev).csv

echo "Validating $(wc -l "$1" | cut -d ' ' -f 1) potential Twitter accounts..."

for i in $(cat "$1")
do
	url="https://twitter.com/$i"

	#get http status of possible account
	status=$(curl -H $'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36 Edge/18.17763' -s -o /dev/null -w "%{http_code}" "$url")

	#if account exists, check if it has tweeted
	if [ "$status" = "200" ]; then

		isInactive=$(curl -H $'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36 Edge/18.17763' -s  "$url" | grep "hasn't Tweeted")
		
		if [ "$isInactive" ]; then
			echo "$status","$i",inactive,"$url" >> "$filename"
		else
			echo "$status","$i",active,"$url" >> "$filename"
		fi

		unset isInactive
	
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
