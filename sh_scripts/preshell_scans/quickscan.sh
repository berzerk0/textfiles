#!/bin/bash

# $1 = ip

echo "Running unicornscan on $1..."

unicornscan -i tap0 -r 1500 -I -p $1:a | tee unicorn_tcp

found_ports=$(grep 'from' unicorn_tcp  | cut -d ']' -f 1 | cut -d '[' -f 2 | tr -d ' ' | tr '\n' ',' | rev | cut -d ',' -f 2- | rev)


echo "Identified ports $found_ports"
echo "$found_ports" > found_tcp_ports

echo "Running 'nmap -sV -sC -p$found_ports $1 -A -oA full_tcp'"

nmap -sV -sC -p$found_ports $1 -A -oA full_tcp

unset found_ports
