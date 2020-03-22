#!/usr/bin/python3
import tldextract, sys, twint
from urlextract import URLExtract

if (len(sys.argv) != 2):
    print ("Usage: twintGetLinks.py [Username File] \nOne username per line")
    sys.exit()

#input and output files
inFile=sys.argv[1]
outFile="twintScraped_subdomains_"+inFile


# configuration for twint
twintConfig=twint.Config()
twintConfig.Hide_output = True #quiet mode
twintConfig.Links = "yes" #only fetch tweets with links
twintConfig.Store_object = True #store findings

tweetsWithLinks = [] #array to store to
twintConfig.Store_object_tweets_list = tweetsWithLinks #store findings to array

#URL extractor object to use later
urlExt = URLExtract()

##uncomment to generate a list of registered domains
#regDomains = []

#array to populate with subdomains
withSubdomains = []

# array to store usernames
usernames = []

# read usernames from file
with open(inFile, "r") as ins:
    for line in ins:

        #append usernames to array
        name = line.rstrip()

        #no duplicates
        if name not in usernames:
            usernames.append(name)


# get tweets for all users
for username in usernames:
    twintConfig.Username= username
    print ("Retrieving tweets from @%s..." %(username))

    twint.run.Search(twintConfig)




# iterate through tweets and pick out links
for tweet in tweetsWithLinks:
    links = urlExt.find_urls(tweet.tweet)

    for link in links:

        #pick out the subdomains and domains
        val = (tldextract.extract(link.lower()))
        #regDomain = val.registered_domain # don't need these here
        withSubdomain = '.'.join(val[:])

        #tldextract sometimes grabs domains that start with a dot
        if withSubdomain[0] == ".": withSubdomain = withSubdomain[1:]

        # # uncomment to generate a list of registered domains
        # if regDomain not in regDomains:
        #     regDomains.append(regDomain)

        if withSubdomain not in withSubdomains:
            withSubdomains.append(withSubdomain)

with open (outFile, 'w') as out:
    for item in withSubdomains:
        out.write('%s\n' % item)

print ("Wrote %d subdomains to %s" % (len(withSubdomains), outFile))
