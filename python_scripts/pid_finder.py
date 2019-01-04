#!/usr/bin/python3

#Created by "Mr. Options" himself, Steven

# This program is good for catching processes as the spawn on linux hosts
# Created to catch cron jobs from the root user in particular

# For a default ubuntu install, use '/cmdline'
# For other distros, try '/psinfo'


# TODO: Add a command line argument to allow reading of different proc files
#       For example, 'cmdline' vs 'psinfo'. Would allow for easy switching between distros

# Imports
import os
import re
import datetime

old_pids = []

print ("Getting PIDs")
while True:
    pids = [pid for pid in os.listdir('/proc') if pid.isdigit()]

    for p in pids:
        if p not in old_pids:
            # read the command name
            try:
                f = open('/proc/{0}/cmdline'.format(p), 'r')
                print ('[{0}] {1}: {2}'.format(datetime.datetime.now().time(), p, re.findall("[^\x00-\x1F\x7F-\xFF]{4,}", f.read())) )
            except:
                print ("Error opening file for PID: {0}".format(p))

            # add to old pids
            old_pids.append(p)

