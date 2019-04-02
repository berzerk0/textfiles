#!/bin/bash


count_first=$(wc -l < $1);


choose_first=$((RANDOM%count_first+0));


first_word=$(head -n $choose_first $1 | tail -n 1);


echo " "
echo $first_word
echo " "
