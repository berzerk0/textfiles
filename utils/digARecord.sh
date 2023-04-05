#!/bin/bash

#take a list of subdomains, dig until an A-record

#i="$1"

getARecords ()
{
# 	dig @1.1.1.1 "$1" | grep "IN" | grep -v ';' | grep -E '\s+A\s+' | \
# cut -d ' ' -f 1 | tr '\t' ',' | sed -e 's/.\s*,//' | sort -u

#   dig @1.1.1.1 "$1" | grep "IN" | grep -v ';' | grep -E '\s+A\s+' | \
# tr '[[:blank:]' ',' | sed -e 's/.,/,/' | sort -u

dig "$1" | grep "IN" | grep -v ';' | grep -E '\s+A\s+' | \
tr '[[:blank:]' ',' | sed -e 's/.,/,/' | sort -u
}

inFile="$1"

for line in $(cat "$inFile")
do

  for i in $(getARecords "$line")

  do
    echo "$line","$i"
  done

done

unset inFile
