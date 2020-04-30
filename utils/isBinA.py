#!/usr/bin/python3

#takes a list of subdomains (file B) and checks to see it
# contains domains provided (file A)

import sys,os

usageMessage= """
python3 isAinB.py [Big File] [Little File] [Logic Choice]
Big File = path to file to be referenced
Little File = path to file to be checked against the Big file
Logic Choice = "i" for inclusive, "v" for exclusive
    i - look for lines in both big and little files
    v - look for lines that are in the little file, but NOT in the big file

Note that this uses GREP - so PARTIAL MATCHES ARE CONSIDERED

"""

if (len(sys.argv) != 4):
    print ("Error: Missing arguments")
    print (usageMessage)
    sys.exit()

bigFile=sys.argv[1]
littleFile=sys.argv[2]
choice=sys.argv[3]


if ((choice != "i") and (choice != "v")):
    print ("Invalid logic choice. Enter i or v")
    print (usageMessage)
    sys.exit()

# no redundant grep flags
if choice == "i": choice = ""

searchMe = []

with open(bigFile, "r") as ins:
    for line in ins:

        val = (line.rstrip()).replace(".","\.")
        searchMe.append(val)


grepMe= '\|'.join(searchMe[:])

#yes this is privescy
command= ("grep -i" + choice +"  \'" + grepMe + "\' " + littleFile)

##print (command)

os.system(command)
