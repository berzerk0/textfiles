#!/usr/bin/python3

import tldextract, sys, requests

url = "https://index.commoncrawl.org/CC-MAIN-2016-22-index?filter=%3Dstatus%3A200&fl=url%2Cstatus&url=*.mwrinfosecurity.com"

def fetchCrawl(sourceSet,targetSite):

    headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36\
     (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 Edge/16.16299",
     }

    r = requests.get("https://index.commoncrawl.org/"+sourceSet+"-index?filter=%3Dstatus%3A200&fl=url%2Cstatus&url="+targetSite, headers=headers)
    return (((r.text).replace(" 200",'')).split('\n'))


a = fetchCrawl("CC-MAIN-2019-35","*.mwrinfosecurity.com")

reg_domains = []
withSubdomains = []

for i in fetchCrawl("CC-MAIN-2019-35","*.mwrinfosecurity.com"):
    #a = tldextract.extract(i)
    #reg_domains.append(a.registered_domain)
    #print ('.'.join(tldextract.extract(i)))
    withSubdomains.append('.'.join(tldextract.extract(i)))

for i in set(withSubdomains):
    print (i)



# ext = tldextract.extract(url)
#
# print (ext)
# print (ext.subdomain + " subdomain")
# print (ext.domain + " domain")
# print (ext.suffix + " suffix")
# print (ext.registered_domain + " registered_domain")

#ext.subdomain, ext.domain, ext.suffix
