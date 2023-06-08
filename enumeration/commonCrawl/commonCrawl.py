#!/usr/bin/python3

import requests, sys, dns.resolver
import tldextract, argparse

def parse_args():
    # parse the arguments
    parser = argparse.ArgumentParser(epilog='\tExample: \r\npython ' + sys.argv[0] + " -u example.com")
    parser.error = parser_error
    parser._optionals.title = "OPTIONS"
    parser.add_argument('-u', '--url', help="URL to search for files and directories for", required=True)
    return parser.parse_args()


def resolveTarget(target):
    dnsResolver = dns.resolver.Resolver()

    regDomain = (tldextract.extract(target)).registered_domain

    if len(regDomain) < 1:
        errorMsg = ("\"{s}\" not a valid domain".format(s=target))
        parser_error(errorMsg)
        sys.exit()


    try:
        # older version
        # answers = dnsResolver.query(regDomain,"A")
        
        answers = dnsResolver.resolve(regDomain,"A")

    except:
        errorMsg = ("\"{s}\" did not resolve".format(s=regDomain))
        parser_error(errorMsg)
        sys.exit()

def getCommonCrawlSets():

    cc_sets = []

    r = requests.get("https://index.commoncrawl.org/collinfo.json")

    for i in r.text.split("\n"):
        if "id" in i:
            cc_sets.append(i.split("\"")[3])

    return cc_sets

def getCommonCrawl(targetSite):

    cc_results = []

    a = "https://index.commoncrawl.org/"
    c = "-index?filter=%3Dstatus%3A200&fl=url%2Cstatus&url="

    headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36\
     (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 Edge/16.16299",
      "Connection": "close",
      "Upgrade-Insecure-Requests": "1"
      }

     #get sets
    sets = getCommonCrawlSets()

    if len(sets) < 1:
        errorMsg = ("CommonCrawl data sets not found")
        print (errorMsg)
        sys.exit()


    update = ("Pulling from {s} CommonCrawl indices".format(s=len(sets)))
    print (update)

    for i in sets:
        theURL = (a + i + c + targetSite + "/*")

        r = requests.get(theURL, headers=headers)

        for i in r.text.split("\n"):
            cc_results.append(i.split(" ")[0])

    return set(cc_results)

def parser_error(errmsg):
    print("Usage: python " + sys.argv[0] + " -u [URL]")
    print("Error: " + errmsg)
    sys.exit()

args = parse_args()
targetSite = args.url


#Ensure that target Site exists
resolveTarget(targetSite)


results = getCommonCrawl(targetSite)

if (len(results) == 1) and (list(results)[0] == "No"):
    errorMsg = ("No results found for {s}".format(s=regDomain))
    print (errorMsg)
    sys.exit()

for i in results:
	if i != "No":
		print (i)
