#!/bin/bash

#1 = png
imgFile="$1"

# does the host file exist?
# show error if not
if [ ! -f "$imgFile" ] || [ ! -s "$imgFile" ]
then
    printf "\n [-] Error: %s img file not found in current directory,\
 or is empty\n"  "$imgFile"
    exit 1
fi

imageString=$(base64 < "$imgFile" | tr -d '\n')
fileName=$(echo data-"$imgFile".txt)

printf "data:image/png;base64,%s" "$imageString" > "$fileName"

unset imgFile imageString fileName
