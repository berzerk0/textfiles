#!/usr/bin/python3

import tldextract, sys

inFile=sys.argv[1]

domains = []
subdomains = []

with open(inFile, "r") as ins:
	for line in ins:

		#(ext.subdomain, ext.domain, ext.suffix)
		a = tldextract.extract(line.rstrip())

		dom = a.registered_domain
		sub = a.subdomain + "."

		if (sub not in subdomains) and (len(sub) > 1): subdomains.append(sub)

		if (dom not in domains) and (len(dom) > 1): domains.append(dom)


#write domains to a file
with open('domains.txt', 'w') as filehandle:
    filehandle.writelines("%s\n" % dom for dom in domains)

#write subdomains to a file
with open('subdomains.txt', 'w') as filehandle:
    filehandle.writelines("%s\n" % sub for sub in subdomains)

#clear arrays
domains = []
subdomains = []

#read from files, write permutations
with open("domains.txt", "r") as domFile:
	for dom_line in domFile:
		dom_line = dom_line.rstrip()

		with open("subdomains.txt", "r") as subFile:
			for sub_line in subFile:

				sub_line = sub_line.rstrip()
				newline = sub_line + dom_line

				print (newline)
