FIRST=sources/locations/Qual_Cities.txt
SECOND=sources/parts_of_speech/nouns_of_assembly.txt

count_first=$(wc -l < $FIRST);
count_second=$(wc -l < $SECOND);

choose_first=$((RANDOM%count_first+0));
choose_second=$((RANDOM%count_second+0));

first_word=$(head -n $choose_first $FIRST | tail -n 1);
second_word=$(head -n $choose_second $SECOND | tail -n 1);


echo "Qual Group: $first_word $second_word"

unset FIRST count_first choose_first first_word
unset SECOND count_second choose_second second_word
