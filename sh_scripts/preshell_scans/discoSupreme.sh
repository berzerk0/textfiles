#!/bin/bash

#Fyodor's discoverer supreme
# takes a list of hosts (-iL) in nmap, and tries Fyodor's best discovery methods

# $1 = filepath to host list, one host per line

fileName=$(date | cut -d ' ' -f 2-3,5-6 | tr ':' '_' | tr -d ' ')

hostList=$1

nmap -sn -PE -PP -PS21,22,23,25,80,113,31339 -PA80,113,443,10042 -PU53,161,51234 --source-port 53 --data-length 32 -iL $hostList -oA discoSupreme_$fileName

unset hostlist
unset fileName
