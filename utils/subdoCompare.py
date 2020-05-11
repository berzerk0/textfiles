#!/usr/bin/python3

#takes a list of subdomains (file B) and checks to see it
# contains domains provided (file A)

import sys,os

usageMessage= """
python3 isAinB.py [domain file] [subdomain file] [Logic Choice]
domain file = path to file to be referenced
subdomain file = path to file to be checked against the domain file
Logic Choice = "i" for inclusive, "v" for exclusive
    i - look for lines in both big and subdomain files
    v - look for lines that are in the subdomain file, but NOT in the domain file

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

        val = "\.*" + (line.rstrip()).replace(".","\.") + "\\s*$"
        searchMe.append(val)


grepMe= '|'.join(searchMe[:])

#yes this is privescy
command= ("grep -iE" + choice +"  \'" + grepMe + "\' " + littleFile)

#print (command)

os.system(command)
