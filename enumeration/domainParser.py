#!/usr/bin/python3

import tldextract, sys

inFile=sys.argv[1]

domains = []

with open(inFile, "r") as ins:
	for line in ins:
		#a = ((tldextract.extract(line.rstrip())).registered_domain)
		#b = a.registered_domain
	
		domains.append(((tldextract.extract(line.rstrip())).registered_domain))

for i in set(domains):
	print (i)
