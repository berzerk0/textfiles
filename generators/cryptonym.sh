word_source=sources/parts_of_speech/nouns.txt
letter_source=sources/parts_of_speech/alphabet.txt


count=$(wc -l < sources/parts_of_speech/nouns.txt);

choose_word=$((RANDOM%$count+0));
choose_letone=$((RANDOM%26+0));
choose_lettwo=$((RANDOM%26+0));

word=$(head -n $choose_word $word_source | tail -n 1);
letone=$(head -n $choose_letone $letter_source | tail -n 1);
lettwo=$(head -n $choose_lettwo $letter_source | tail -n 1);


echo Cryptonym: $letone$lettwo"-"$word

