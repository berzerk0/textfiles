#!/bin/sh

if [ -f "/root/sync_status.txt" ]; then
        touch "/root/sync_status.txt" || return
fi


# --- 7 Feb Updates ---
#Configure WebTools Folder
if [ ! -d "/opt/WebTools" ]; then
        mkdir '/opt/WebTools' || return
fi


#Configure Dirsearch
git clone https://github.com/maurosoria/dirsearch /opt/WebTools/dirsearch
echo 'alias dirsearch="/opt/WebTools/dirsearch/dirsearch.py"' >> ~/.bash_aliases
echo 'alias dirsearch-quick="/opt/WebTools/dirsearch/dirsearch.py --wordlist=/usr/share/wordlists/dirb/common.txt"' >> ~/.bash_aliases
echo 'alias dirsearch-medium="/opt/WebTools/dirsearch/dirsearch.py --wordlist=/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"' >> ~/.bash_aliases



echo "W2dlbmVyYWxdCiN0aHJlYWRzID0gMTAKI2ZvbGxvdy1yZWRpcmVjdHMgPSBGYWxzZQojZXhjbHVk
ZS1zdGF0dXMgPSAyMDAsMzAxCiNyZWN1cnNpdmUgPSBGYWxzZQojc2Nhbm5lci1mYWlsLXBhdGgg
PSBJbnZhbGlkUGF0aDEyMzEyMwojc2F2ZS1sb2dzLWhvbWUgPSBUcnVlCgpbcmVwb3J0c10KYXV0
b3NhdmUtcmVwb3J0ID0gVHJ1ZQphdXRvc2F2ZS1yZXBvcnQtZm9ybWF0ID0gcGxhaW4KCltkaWN0
aW9uYXJ5XQp3b3JkbGlzdCA9IC91c3Ivc2hhcmUvd29yZGxpc3RzL2RpcmJ1c3Rlci9kaXJlY3Rv
cnktbGlzdC0yLjMtc21hbGwudHh0CiNsb3dlcmNhc2UgPSBGYWxzZQoKW2Nvbm5lY3Rpb25dCiN1
c2VyYWdlbnQgPSBNeVVzZXJBZ2VudAojdGltZW91dCA9IDMwCiNtYXgtcmV0cmllcyA9IDUKI2h0
dHAtcHJveHkgPSBsb2NhbGhvc3Q6ODA4MAojcmFuZG9tLXVzZXItYWdlbnRzID0gVHJ1ZQo=" | base64 -d > "/opt/WebTools/dirsearch/default.conf"


#unzip rockyou
if [ -f "/usr/share/wordlists/rockyou.txt.gz" ]; then
        gunzip "/usr/share/wordlists/rockyou.txt.gz" || return
fi

echo "Synched 7 Feb Version at	$(date)" >> "/root/sync_status.txt"

echo "USB 3.0 Controller"
echo "Change the vmdir alias to '/media/root/THUMBERKO/OSCP-PWK/Share_PWK'"
echo "https://addons.mozilla.org/en-US/firefox/addon/uaswitcher/?src=search"
