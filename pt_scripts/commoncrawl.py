#!/usr/bin/python3

import requests, sys, dns.resolver
import tldextract

def resolveTarget(target):
    dnsResolver = dns.resolver.Resolver()

    regDomain = (tldextract.extract(target)).registered_domain

    if len(regDomain) < 1:
        errorMsg = ("{s} not a valid domain".format(s=target))
        print (errorMsg)
        sys.exit()


    try:
        answers = dnsResolver.query(regDomain,"A")

    except:
        errorMsg = ("{s} not found".format(s=regDomain))
        print (errorMsg)
        sys.exit()



#https://index.commoncrawl.org/CC-MAIN-2016-22-index?filter=%3Dstatus%3A200&fl=url%2Cstatus&url=%2A.mwrinfosecurity.com

#https://otx.alienvault.com/api/v1/indicators/domain/mwrinfosecurity.com/url_list


targetSite = sys.argv[1]


resolveTarget(targetSite)



def getCommonCrawl(targetSite):

    cc_results = []

    a = "https://index.commoncrawl.org/"
    c= "-index?filter=%3Dstatus%3A200&fl=url%2Cstatus&url="

    headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36\
     (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 Edge/16.16299",
      "Connection": "close",
      "Upgrade-Insecure-Requests": "1"
      }

    sets = [
        'CC-MAIN-2019-35','CC-MAIN-2019-30','CC-MAIN-2019-26','CC-MAIN-2019-22',
        'CC-MAIN-2019-18','CC-MAIN-2019-13','CC-MAIN-2019-09','CC-MAIN-2019-04',
        'CC-MAIN-2018-51','CC-MAIN-2018-47','CC-MAIN-2018-43','CC-MAIN-2018-39',
        'CC-MAIN-2018-34','CC-MAIN-2018-30','CC-MAIN-2018-26','CC-MAIN-2018-22',
        'CC-MAIN-2018-17','CC-MAIN-2018-13','CC-MAIN-2018-09','CC-MAIN-2018-05',
        'CC-MAIN-2017-51','CC-MAIN-2017-47','CC-MAIN-2017-43','CC-MAIN-2017-39',
        'CC-MAIN-2017-34','CC-MAIN-2017-30','CC-MAIN-2017-26','CC-MAIN-2017-22',
        'CC-MAIN-2017-17','CC-MAIN-2017-13','CC-MAIN-2017-09','CC-MAIN-2017-04',
        'CC-MAIN-2016-50','CC-MAIN-2016-44','CC-MAIN-2016-40','CC-MAIN-2016-36',
        'CC-MAIN-2016-30','CC-MAIN-2016-26','CC-MAIN-2016-22','CC-MAIN-2016-18',
        'CC-MAIN-2016-07','CC-MAIN-2015-48','CC-MAIN-2015-40','CC-MAIN-2015-35',
        'CC-MAIN-2015-32','CC-MAIN-2015-27','CC-MAIN-2015-22','CC-MAIN-2015-18',
        'CC-MAIN-2015-14','CC-MAIN-2015-11','CC-MAIN-2015-06','CC-MAIN-2014-52',
        'CC-MAIN-2014-49','CC-MAIN-2014-42','CC-MAIN-2014-41','CC-MAIN-2014-35',
        'CC-MAIN-2014-23','CC-MAIN-2014-15','CC-MAIN-2014-10','CC-MAIN-2013-48',
        'CC-MAIN-2013-20','CC-MAIN-2012','CC-MAIN-2009-2010','CC-MAIN-2008-2009'
          ]

    update = ("Pulling from {s} CommonCrawl indices".format(s=len(sets)))
    print (update)

    for i in sets:
        theURL = (a + i + c + targetSite + "/*")

        #update = ("Fetching results within {s}".format(s=i))
        #print (update)

        r = requests.get(theURL, headers=headers)

        for i in r.text.split("\n"):
            cc_results.append(i.split(" ")[0])

    return set(cc_results)



results = getCommonCrawl(targetSite)

if (len(results) == 1) and (list(results)[0] == "No"):
	print ("No results found for " + targetSite)
	sys.exit()

for i in results:
	if i != "No":
		print (i)
