#!/bin/bash

printf "Beginning ${GREEN}GET and 404 Request${NC} gathering...\n\n"


if [ ! -f "aquatone_urls.txt" ]; then
    printf 'aquatone urls file not found\n Request gathering cancelled'
		exit 1
fi

if [ ! -d "GET_requests" ]; then
	mkdir "GET_requests"
fi

if [ ! -d "404_requests" ]; then
	mkdir "404_requests"
fi

#split into two lines because line length limits and scrubbery
UA_A="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, "
UA_B="like Gecko) Chrome/74.0.3729.169 Safari/537.36"
ranString=$(tr -dc 'a-zA-Z\_\-0-9' < /dev/urandom | fold -w10 | head -1)


for i in $(cat aquatone_urls.txt);
do

	getFileName=$(echo -n "$i" | tr -d '/' | tr '.:' '_')

	http --verify=no -v "$i" User-Agent:"$UA_A$UA_B" Referer:"$i" \
> GET_requests/"$getFileName"

	http --verify=no -v "$i$ranString" User-Agent:"$UA_A$UA_B" Referer:"$i" \
> 404_requests/"$getFileName-404"

done


unset getFileName
unset UA_A
unset UA_B
unset ranString
