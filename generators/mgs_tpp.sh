#!/bin/sh

FIRST=sources/misc/mgs_tpp_A.txt
SECOND=sources/misc/mgs_tpp_B.txt


count_first=$(wc -l < $FIRST);
count_second=$(wc -l < $SECOND);

choose_first=$((RANDOM%count_first+0));
choose_second=$((RANDOM%count_second+0));


first_word=$(head -n $choose_first $FIRST | tail -n 1);
second_word=$(head -n $choose_second $SECOND | tail -n 1);


echo " "
echo "$first_word"
echo "$second_word"
echo " "
