#!/usr/bin/python3
import tldextract, sys

inFile=sys.argv[1]

domains = []

with open(inFile, "r") as ins:
	for line in ins:

		regDomain = ((tldextract.extract(line.rstrip())).registered_domain)

		if (len(regDomain) > 1) and (regDomain not in domains):
			domains.append(regDomain)
			print (regDomain)
