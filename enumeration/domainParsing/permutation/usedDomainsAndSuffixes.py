#!/usr/bin/python3

import tldextract, sys

inFile=sys.argv[1]

domains = []
suffixes = []

with open(inFile, "r") as ins:
	for line in ins:

		#(ext.subdomain, ext.domain, ext.suffix)
		a = tldextract.extract(line.rstrip())

		suff = "." + a.suffix
		dom = a.domain

		if (suff not in suffixes) and (len(suff) > 1): suffixes.append(suff)

		if (dom not in domains) and (len(dom) > 1): domains.append(dom)


# add domains to file


with open('domains.txt', 'w') as filehandle:
    filehandle.writelines("%s\n" % dom for dom in domains)

with open('suffixes.txt', 'w') as filehandle:
    filehandle.writelines("%s\n" % suff for suff in suffixes)

domains = []
suffixes = []

with open("domains.txt", "r") as domFile:
	for dom_line in domFile:
		dom_line = dom_line.rstrip()

		with open("suffixes.txt", "r") as suffFile:
			for suff_line in suffFile:

				suff_line = suff_line.rstrip()
				newline = dom_line + suff_line

				print (newline)
