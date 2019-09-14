#!/bin/bash

# $1 file with list paths to gplay id's, one per line

for i in $(cat "$1")
do

	# make sure the directory is clear
	rm -r "$i*"

	# status update message
	echo "Extracting $i"

	# extract the apk from the play store
	gplaycli -d "$i"

	# use the diggy script (https://github.com/s0md3v/Diggy)
	# to extract endpoints. It just uses grep and apktool
	diggy "$i".apk

	rm -r "$i".apk && rm -r "$i"

done
