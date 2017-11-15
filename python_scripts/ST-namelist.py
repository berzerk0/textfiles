##  Short script to generate a few variations of a username into a wordlist.

import sys
from sys import argv
import itertools

if len(argv) < 2:
	print ("""
	usage: ST-Namelist.py filename.txt
	filenames must have one username per line
		""")
	sys.exit()
	
in_file_name = str((argv[1]))

with open(in_file_name) as infile: #for current file
	for line in infile:
		username=line.strip('\n')

		
		userlist=[]
		#userlist.extend(["".join(perm) for perm in itertools.permutations(username)]) #this is overkill

		userlist.append(username.lower())
		userlist.append(username.title())
		userlist.append(username.upper())
		userlist.append(username.swapcase())
		
		#Get unique values
		userlist = list(set(userlist))
		
		#Create reversals
		for i in range(len(userlist)): userlist.append(userlist[i][::-1])
		
		#Get unique values
		userlist = list(set(userlist))
		
		out_file_name=username+'_STWL.txt'
		
		outfile=open(out_file_name, 'w+')
		outfile.truncate()
		
		for i in userlist:
			outfile.writelines(i + '\n')
			
		outfile.close()
		
		
		
		

		
