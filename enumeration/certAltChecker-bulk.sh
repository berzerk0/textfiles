#!/bin/bash


inFile="$1"


# check to see that a directory called "certAlts" exists in the current dir
# if not, create one
if [ ! -d "certAlts" ]; then
        mkdir "certAlts"
fi

while read -r domain
	do
		fileName=$(echo "$domain" | tr -d '/' | tr '.:' '_')
		#echo "$domain"


		echo | openssl s_client -showcerts -servername "$domain" -connect "$domain":443 2>/dev/null \
		| openssl x509 -inform pem -noout -ext subjectAltName \
		| grep 'DNS' | tr -s ' ' | tr ' ' '\n' \
		| tr -d ',' | cut -d ':' -f 2 | grep -E '[a-z]' | sort -u >> certAlts/"$fileName" 2>/dev/null
	done < "${1:-/dev/stdin}"

unset infile domain fileName