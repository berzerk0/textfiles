#!/bin/bash

#Twitter followertree

usernameFile="$1"
followingFile="followerTree.txt"

# twint didn't like appending to the same follower file each time
# but it didn't mind writing to a new file every time

tempFollowingFile="tempFollowers.txt"

for i in $(cat "$usernameFile")
do
	printf "Finding followers for @%s...\n" "$i"

	# twint didn't like running with supressed output either
	# this script is rather bootleg
	twint -u "$i" --following -o "$tempFollowingFile" &> /dev/null
	cat "$tempFollowingFile" >> "$followingFile"

	rm "$tempFollowingFile"

done

sort -u "$followingFile" | grep -iE '^f\-*secure'


unset tempFollowingFile followingFile
