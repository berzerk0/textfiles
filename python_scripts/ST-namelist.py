
import sys
from sys import argv

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
		userfile=username + '_STWL.txt'
		
		userlist=[]
		userlist.append(username.title())
		userlist.append(username.)
		
		

		
