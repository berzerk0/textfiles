#!/bin/bash

#1 = number of images to fetch

for i in $(seq 1 $1)
do
	fname="$(date | cut -d ' ' -f 2,3,5 | tr ' ' '_' | sed -e 's/_//' | tr -d ':').jpg"

	wget https://thispersondoesnotexist.com/image -U "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0" -O $fname

	unset fname
done

