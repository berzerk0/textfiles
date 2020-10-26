#!/bin/bash

# $1 = number of digits

# Display error if not enough arguments given
if [ $# -ne 1 ]; then
	printf " ./digits.sh [length, an integer]\n"
	exit 1
fi


tr -dc '0-9' < /dev/urandom | fold -w "$1" | head -1
