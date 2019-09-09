#!/usr/bin/python3

import requests
#https://index.commoncrawl.org/CC-MAIN-2016-22-index?filter=%3Dstatus%3A200&fl=url%2Cstatus&url=%2A.mwrinfosecurity.com

results = []

def getResult(dataset,targetSite):
    a = "https://index.commoncrawl.org/"
    c= "-index?filter=%3Dstatus%3A200&fl=url%2Cstatus&url="

    theURL = (a + dataset + c + targetSite)

    headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36\
     (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36 Edge/16.16299",
      "Connection": "close",
      "Upgrade-Insecure-Requests": "1"
      }

    r = requests.get(theURL, headers=headers)
    for i in r.text.split("\n"):
            results.append(i.split(" ")[0])


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
test_sets = ['CC-MAIN-2016-30','CC-MAIN-2016-26','CC-MAIN-2016-22']

for i in sets:
    getResult(i,"*.mwrinfosecurity.com")

print (set(results))
