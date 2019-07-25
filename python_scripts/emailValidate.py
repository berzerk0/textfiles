#!/usr/bin/python
import sys
from sys import argv
from validate_email import validate_email

#Usage error message and exit if invalid syntax
if len(argv) < 2:
    print ("""Usage: emailValidate.py filename.txt
filenames must have one email per line""")
    sys.exit()
    
in_file_name = str((argv[1]))

#iterate over lines in file to extract addresses
with open(in_file_name) as infile: 

    for line in infile:
        email=line.strip('\n') #remove newlines

	#if email is valid, print to standard output
	# emailValidate.py filename.txt >> valid_Emails.txt
        if (validate_email(email,verify=True)): print (email)
