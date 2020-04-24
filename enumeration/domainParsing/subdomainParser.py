#!/usr/bin/python3
import tldextract, sys

inFile=sys.argv[1]

subdomains = []

with open(inFile, "r") as ins:
	for line in ins:

		val = (tldextract.extract(line.rstrip()))
		subdomain = '.'.join(val[:])


		if (len(subdomain) > 1) and (subdomain not in subdomains):
			subdomains.append(subdomain)
			print (subdomain)
