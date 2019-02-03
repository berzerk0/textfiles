#!/bin/sh

FIRST=sources/misc/dothack_A.txt
SECOND=sources/misc/dothack_B.txt
THIRD=sources/misc/dothack_C.txt

count_first=$(wc -l < $FIRST);
count_second=$(wc -l < $SECOND);
count_third=$(wc -l < $THIRD);

choose_first=$((RANDOM%count_first+0));
choose_second=$((RANDOM%count_second+0));
choose_third=$((RANDOM%count_third+0));

first_word=$(head -n $choose_first $FIRST | tail -n 1);
second_word=$(head -n $choose_second $SECOND | tail -n 1);
third_word=$(head -n $choose_third $THIRD | tail -n 1);

echo " "
echo $first_word
echo $second_word
echo $third_word
echo " "
