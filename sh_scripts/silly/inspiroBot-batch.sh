#!/bin/bash



# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf "Usage: ./inspiroBot-batch.sh [Number of Images to fetch]\n"
	exit 1
fi

#1 = number of runs
# no magic numbers
iterations="$1"




# check to see that a directory called "GET_requests" exists in the current dir
# if not, create one
if [ ! -d "fetched_images" ]; then
	mkdir "fetched_images"
fi

UA=$'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36'

printf "Fetching %s images...\n" "$iterations"

for runs in $(seq 1 "$iterations")
do

  url=$(curl --http2 -sk -X $'GET' -H $'Host: inspirobot.me' -H $'Accept: */*' \
  -H "$UA" -H $'Referer: https://inspirobot.me/' \
  -H $'Accept-Language: en-US,en;q=0.9' -H $'Connection: close' \
  $'https://inspirobot.me/api?generate=true')

  wget -q -P "fetched_images" "$url"

done
