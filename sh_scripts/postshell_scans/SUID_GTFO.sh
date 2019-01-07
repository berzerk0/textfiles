#!/bin/sh

### GTFOBins SUID Finder

#This script looks for SUID files that are on the GTFOBins project

## string containing GTFObins
gtfoString="apt apt-get aria2c ash awk base64 bash busybox cancel cat chmod chown cp cpan cpulimit crontab csh curl cut dash date dd diff dmesg dmsetup docker easy_install ed emacs env expand expect facter file find finger flock fmt fold ftp gdb git grep head ionice irb jjs journalctl jq jrunscript ksh ld.so less ltrace lua mail make man more mount mv mysql nano nc nice nl nmap node od openssl perl pg php pic pico pip puppet python readelf red rlogin rlwrap rpm rpmquery rsync ruby run-mailcap run-parts rvim scp sed setarch sftp shuf smbclient socat sort sqlite3 ssh start-stop-daemon stdbuf strace tail tar taskset tclsh tcpdump tee telnet tftp time timeout ul unexpand uniq unshare vi vim watch wget whois wish xargs xxd zip zsh"



## find SUID binaries
gtfoStandardSuid=$(find / -perm -4000 -type f 2>/dev/null | rev | cut -d '/' -f 1 | rev | sort -u)

## find SUID binaries owned by root
gtfoRootSuid=$(find / -uid 0 -perm -4000 -type f 2>/dev/null | rev | cut -d '/' -f 1 | rev | sort -u)


#print out both standard and array, find matches
gtfoStandardResult=$(echo "$gtfoStandardSuid" "$gtfoString" | tr ' ' '\n' | sort | uniq -c | sort -n -r | egrep '^\s*2' |  tr -s ' ' | cut -d ' ' -f 3)

#print out both root and list, find matches
gtfoRootResult=$(echo "$gtfoRootSuid" "$gtfoString" | tr ' ' '\n' | sort | uniq -c | sort -n -r | egrep '^\s*2' |  tr -s ' ' | cut -d ' ' -f 3)


echo "The following SUID files, belonging to \"$(whoami)\", are found on GTFOBins:"
echo $gtfoStandardResult | tr ' ' '\n' | sed -e 's/^/   /'
echo

if [ "$gtfoRootResult" ]; then
	echo "Of those, the following are owned by root:"
	echo $gtfoRootResult | sed -e 's/^/    /'
	echo
fi

unset gtfoString gtfoStandardSuid gtfoRootSuid gtfoStandardResult gtfoRootResult
