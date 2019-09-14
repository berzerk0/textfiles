#!/bin/bash

#$1 = possible page names, one per line



filename=result_facebookEnum_$(echo "$1" | rev | cut -d '/' -f 1 | rev).csv

echo "Validating $(wc -l "$1" | cut -d ' ' -f 1) potential Facebook pages..."

for i in $(cat "$1")
do
	url="https://www.facebook.com/$i"

	#get http status of possible page
	status=$(curl -H $'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.140 Safari/537.36 Edge/18.17763' -s -o /dev/null -w "%{http_code}" "$url")

	if [ "$status" = "200" ]; then
		echo "$status","$i",active,"$url" >> "$filename"
	
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
