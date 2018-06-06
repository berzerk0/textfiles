#!/bin/bash


# create a random string using hardware random
# Don't bet your life on its true randomness.

# if a length argument is given, assign length.
if [ $# -eq 1 ]; then
	length=$1;

#if not, use a random length between 16 and 26
else
	length=$(( (RANDOM % 10) +16 ));
fi


tr -dc 'A-Za-z0-9+_\.' < /dev/urandom | fold -w$length | head -n 1
