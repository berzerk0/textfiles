#!/bin/bash

# $1 = file to read from
# $2 = number of runs



# Display error if not enough arguments given
if [ $# -ne 2 ]; then
	printf "Usage: ./bulkResolver.sh [Hosts File] [Number of Iterations]\n \
Where the Hosts File has one host per line, and the number of iterations is \
an integer.\n"
	exit 1
fi

#massdns - fast dns resolver
# https://github.com/blechschmidt/massdns
gotMassDNS=$(command -v massdns 2>/dev/null)
if [ ! "$gotMassDNS" ]; then
	printf "[-] Error: massdns binary not in PATH\n\n"
	exit 1
fi
unset gotMassDNS

# no magic numbers
inputFile="$1"
runs="$2"

# function to make random strings for FNames
randomString ()
{
	tr -dc "a-zA-Z0-9" < /dev/urandom | fold -w 15 | head -1
}

resolversFName=$(randomString)
outFName=$(randomString)

# making the script "PORTABLE"
resolversArray=( "8.8.8.8" "8.8.4.4" "9.9.9.9" "149.112.112.112" \
"208.67.222.222" "208.67.220.220" "1.1.1.1" "1.0.0.1" "185.228.168.9" \
"185.228.169.9" "64.6.64.6" "64.6.65.6" "198.101.242.72" "23.253.163.53" \
"176.103.130.130" "176.103.130.131" "84.200.69.80" "84.200.70.40" \
"8.26.56.26" "8.20.247.20" "205.171.3.66" "205.171.202.166" "81.218.119.11" \
"209.88.198.133" "195.46.39.39" "195.46.39.40" "66.187.76.168" \
"147.135.76.183" "216.146.35.35" "216.146.36.36" "45.33.97.5" "37.235.1.177" \
"77.88.8.8" "77.88.8.1" "91.239.100.100" "89.233.43.71" "74.82.42.42" \
"109.69.8.51" "156.154.70.1" "156.154.71.1" "45.77.165.194" "99.192.182.100" \
"99.192.182.101" )

# bootleg way of writing the resolvers to a file
for i in "${resolversArray[@]}":
do
	echo "$i" >> "$resolversFName.txt"
done



for i in $(seq 1 "$runs")
do

	resultFName="result_$i.txt"


	massdns --processes 2  -r "$resolversFName.txt" -t A -o S \
-w "$outFName.txt" "$inputFile"
#	massdns -r "$resolversFName.txt" -t A -o S -w "$outFName.txt" "$inputFile"
	cat "$outFName.txt"* > "$resultFName"

	done

rm "$resolversFName.txt"

unset resultFName resolversFName
rm "$outFName.txt"*

cat result_*.txt | sort -u > final_result.txt
