#!/bin/bash

# This script queries the inspiroBot.me API with curl
# obtains a URL and fetches the image with wget
# call it from the command line,
# giving it the number of images you want as an argument

#This script was thrown together in a few mins so its not "robust"

# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf "Usage: ./inspiroBot-batch.sh [Number of Images to fetch]\n"
	exit 1
fi

#1 = number of iterations
# no magic numbers
iterations="$1"

# check to see that a directory called "fetched_images" exists in the current dir
# if not, create one
if [ ! -d "fetched_images" ]; then
	mkdir "fetched_images"
fi

#User agent, not curl
UA=$'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36'

printf "Fetching %s images...\n" "$iterations"

# main loop
for runs in $(seq 1 "$iterations")
do

#thanks, Burpsuite's "Copy as Curl Request feature"
# obtains URL using curl
  url=$(curl --http2 -sk -X $'GET' -H $'Host: inspirobot.me' -H $'Accept: */*' \
  -H "$UA" -H $'Referer: https://inspirobot.me/' \
  -H $'Accept-Language: en-US,en;q=0.9' -H $'Connection: close' \
  $'https://inspirobot.me/api?generate=true')

  # downloads the iamge from the obtained url, saving it to ./fetched_images
  wget -q -P "fetched_images" "$url"

done
