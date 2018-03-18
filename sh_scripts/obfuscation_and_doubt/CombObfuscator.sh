#Combination Obfuscator CombOfuscator
#Requires OWASP-ZSC https://github.com/viraintel/OWASP-ZSC
#and pyminifier - pip install minifier


#######################################################
# HOW TO RUN:
# chmod u+x CombObfuscator.sh; ./CombObfuscator.sh script.py
#######################################################

#This only works on python scripts!

RED='\033[0;31m'
enc_options=(simple_ascii simple_hex_rev simple_base64_rev); #Obfuscation operations
OUTFILE=$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | fold -w$(( (RANDOM % 15) +10 )) | head -n 1)

cp $1 $OUTFILE #creates randomly named copy for outfile

if [ $# -ne 1 ]; then
	printf " ${RED}Usage: ${NC} ./CombObfuscator.sh script.py\n"
	exit 1
fi

#Function to choose obfuscation method at random, then minify.
obfuscateAndMinify () {
	lines=$(expr $(wc -l < $OUTFILE) + 4) #Count lines in file, add 4

	#Call ZSC for obfuscation
	zsc -p python/${enc_options[$((RANDOM % 1 ))]} -i $OUTFILE >> /dev/null #call ZSC for obfuscation

	#Remove un-obfuscated lines, save in temp file.
	cat $OUTFILE | tail +$lines > NAzQ31tFT9EzIYrX8Xqtempfile

	#Minify adding obfuscation and aliases.
	#pyminifier -O --replacement-length=$(( (RANDOM % 10) +1 )) NAzQ31tFT9EzIYrX8Xqtempfile | grep -vi 'pyminifier' > $OUTFILE

	#Repeat process
	lines=$(expr $(wc -l < $OUTFILE) + 4)
	zsc -p python/${enc_options[$((RANDOM % 1 ))]} -i $OUTFILE >> /dev/null #call ZSC for obfuscation
	cat $OUTFILE | tail +$lines > NAzQ31tFT9EzIYrX8Xqtempfile

	mv NAzQ31tFT9EzIYrX8Xqtempfile $OUTFILE
}

obfuscateAndMinify #run function (Put in function so it can be looped)


# add random "Comments" at beggining of script
for i in $(seq 1 $(( (RANDOM % 5) + 5 )));
	do echo $"# $(cat /dev/urandom | tr -dc 'A-Za-z0-9!@#%^&*()_+-=' | fold -w$(( (RANDOM % 51) +10 )) | head -n 1))" >> NAzQ31tFT9EzIYrX8Xqtempfile;
done

#add random "Comments" at end of script, and an a random md5sum for no reason.
echo $'\n' >> qE2wNc8386Dep4BSBRYdtempfile
echo $"# $(cat /dev/urandom | tr -dc 'A-Za-z0-9!@#$%^&*()_+-=][.,<>/?' | fold -w$(( (RANDOM % 50) +10 )) | head -n 1 | md5sum | cut -d ' ' -f 1)" >> qE2wNc8386Dep4BSBRYdtempfile
for i in $(seq 1 $(( (RANDOM % 3) + 3 )));
	do echo $"# $(cat /dev/urandom | tr -dc 'A-Za-z0-9!@#%^&*()_+-=' | fold -w$(( (RANDOM % 51) +10 )) | head -n 1)" >> qE2wNc8386Dep4BSBRYdtempfile;
done


#Finalize
echo $'\n' | cat NAzQ31tFT9EzIYrX8Xqtempfile - $OUTFILE qE2wNc8386Dep4BSBRYdtempfile > zDeiyUNsbwtempfile && mv zDeiyUNsbwtempfile $OUTFILE

printf "CombObfuscator created $OUTFILE at $(date | cut -d ' ' -f 5) \n"



#Remove tempfiles
rm NAzQ31tFT9EzIYrX8Xqtempfile qE2wNc8386Dep4BSBRYdtempfile
