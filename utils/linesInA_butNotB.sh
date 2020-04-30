#!/bin/bash



# $1 = "big" file
# $2 = "little" file

bigFilename=$(echo "$1" | rev | cut -d '/' -f 1 | rev)
littleFileName=$(echo "$2" | rev | cut -d '/' -f 1 | rev)


filename=$(echo linesIn"$littleFileName"_not"$bigFilename".txt)

awk 'NR==FNR{a[$0];next}!($0 in a)' $2 $1 > "$filename"
