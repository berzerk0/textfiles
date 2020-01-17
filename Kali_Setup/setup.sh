#!/bin/bash

## MUST BE RUN IN HOME DIRECTORY

apt-get update -y && apt-get upgrade -y && apt-get autoremove
apt-get install p7zip sakura ncat shellcheck python-pip

# Get EICAR test file
if [ ! -d "$HOME/eicar" ]; then
	mkdir ~/eicar
fi

cd ~/eicar || echo "cd failure at eicar" && exit
wget http://www.eicar.org/download/eicar.com
cd $HOME


# configure metasploit db
msfdb init


####WORDLISTS

#my handy wordlists
if [ ! -d "~/Wordlists" ]; then
	mkdir ~/Wordlists
fi

cd ~/Wordlists
wget https://github.com/berzerk0/textfiles/raw/master/some_wordlists.tar.gz
tar xzf some_wordlists.tar.gz && rm some_wordlists.tar.gz
cd $HOME


#payloads and strings
if [ ! -d "/opt/Payloads_And_Strings" ]; then
	mkdir /opt/Payloads_And_Strings
fi

cd /opt/PayloadsAndStrings
git clone https://github.com/danielmiessler/SecLists
git clone https://github.com/swisskyrepo/PayloadsAllTheThings
git clone https://github.com/berzerk0/Probable-Wordlists
git clone https://github.com/fuzzdb-project/fuzzdb
cd $HOME


#### FTP/TFTPD Setup

apt-get install vsftpd atftpd
cp /etc/vsftpd.conf /etc/vsftpd.conf.orig
wget https://raw.githubusercontent.com/berzerk0/textfiles/master/reference_txts/anonymous_vsftpd.conf -O /etc/vsftpd.conf

#### EXPLOIT TOOLS

if [ ! -d "/opt/Exploit_Tools" ]; then
	mkdir /opt/Exploit_Tools
fi

cd /opt/Exploit_Tools
git clone https://github.com/1N3/BruteX
git clone https://github.com/1N3/Findsploit && sh /opt/Exploit_Tools/Findsploit/install.sh
git clone https://github.com/1N3/PrivEsc

cd $HOME



#### OSINT Tools

# note that EyeWitness does NOT go into the OSINT_Tools directory

cd /opt && git clone https://github.com/FortyNorthSecurity/EyeWitness && sh /opt/EyeWitness/setup/setup.sh
cd $HOME

if [ ! -d "/opt/OSINT_Tools" ]; then
	mkdir /opt/OSINT_Tools
fi

## Domain OSINT

if [ ! -d "/opt/OSINT_Tools/Domain_OSINT" ]; then
	mkdir /opt/OSINT_Tools/Domain_OSINT
fi

cd /opt/OSINT_Tools/Domain_OSINT

git clone https://github.com/1N3/Sn1per
git clone https://github.com/aboul3la/Sublist3r
cd $HOME

## Twitter OSINT

if [ ! -d "/opt/OSINT_Tools/Twitter_OSINT" ]; then
	mkdir /opt/OSINT_Tools/Twitter_OSINT
fi

cd /opt/OSINT_Tools/Twitter_OSINT

git clone https://github.com/twintproject/twint

#### STEGO TOOLS

if [ ! -d "/opt/Stego_Tools" ]; then
	mkdir /opt/Stego_Tools
fi

cd /opt/Stego_Tools

git clone https://github.com/alexadam/img-encode
wget http://www.caesum.com/handbook/Stegsolve.jar -O stegsolve.jar && chmod +x stegsolve.jar
git clone https://github.com/jes/chess-steg

cd $HOME

#### Passwording Tools

if [ ! -d "/opt/Password_Credential_Tools" ]; then
	mkdir /opt/Password_Credential_Tools
fi
cd /opt/PasswordCrendential_Tools

git clone https://github.com/berzerk0/BEWGor
mkdir /opt/Password_Credential_Tools/mutator && cd /opt/PasswordCredential_Tools/mutator
wget https://bitbucket.org/alone/mutator/downloads/mutator_release-v0.2.2-1-gc29ce2b.tar.gz && tar xzf mutator_release-v0.2.2-1-gc29ce2b.tar.gz && rm mutator_release-v0.2.2-1-gc29ce2b.tar.gz

cd $HOME

#### Web Tools

apt-get install sslscan gobuster


if [ ! -d "/opt/Web_Tools" ]; then
	mkdir /opt/Web_Tools
fi
cd /opt/Web_Tools

git clone https://github.com/maurosoria/dirsearch && ln -s /opt/Web_Tools/dirsearch/dirsearch.py /usr/bin/dirsearch

git clone --depth 1 https://github.com/drwetter/testssl.sh.git

pip install --upgrade setuptools
pip install --upgrade sslyze

cd $HOME

#### Obfuscation Tools

if [ ! -d "/opt/Obfuscation_Tools" ]; then
	mkdir /opt/Obfuscation_Tools
fi
cd /opt/Obfuscation_Tools

git clone https://github.com/TryCatchHCF/Cloakify
git clone https://github.com/aemkei/jsfuck

cd $HOME

#### Social Engineering Tools

if [ ! -d "/opt/Social_Engineering_Tools" ]; then
	mkdir /opt/Social_Engineering_Tools
fi
cd /opt/Social_Engineering_Tools

git clone https://github.com/UndeadSec/EvilURL

cd $HOME

#### Atom Text Editor

#check for atom
atomCheckMe=$(command -v atom)

if [ ! "$atomCheckMe" ]; then
	echo "Atom Text Editor found"
else
	cd ~/Downloads
	wget https://atom.io/download/deb -O atom.deb
	dpkg -i atom.deb
	cd $HOME
fi
unset atomCheckMe

# python packages
#pip3 install tldextract
#pip install


#### set up bash aliases
echo "YWxpYXMgdm1kaXI9ImNkIC9tbnQvaGdmcy9WTV9TaGFyaW5nIgoKCmFsaWFzIGJ1cnBzdWl0ZT0i
L29wdC9CdXJwU3VpdGVQcm8vQnVycFN1aXRlUHJvIgoKYWxpYXMgd2luZG93Zml4PSIvdXNyL2xv
Y2FsL3NiaW4vcmVzdGFydC12bS10b29scyIKCmFsaWFzIHRlc3Rzc2w9Ii9vcHQvV2ViX1Rvb2xz
L3Rlc3Rzc2wuc2gvdGVzdHNzbC5zaCIKCgphbGlhcyBuZXNzdXNfc3RhcnQ9Ii9ldGMvaW5pdC5k
L25lc3N1c2Qgc3RhcnQgJiYgZmlyZWZveCBodHRwczovL2xvY2FsaG9zdDo4ODM0LyMvICYiCmFs
aWFzIG5lc3N1c19zdG9wPSIvZXRjL2luaXQuZC9uZXNzdXNkIHN0b3AiCgphbGlhcyBjaHJvbWl1
bT0iY2hyb21pdW0gLS1uby1zYW5kYm94IgphbGlhcyB1cGRhdGVtZT0iYXB0LWdldCB1cGRhdGUg
LXkgJiYgYXB0LWdldCB1cGdyYWRlIC15ICYmIGFwdC1nZXQgYXV0b3JlbW92ZSAteSIKCiN0ZnRw
IHF1aWNrIHN0YXJ0CmFsaWFzIHN0YXJ0LXRmdHA9ImlmIFsgLWQgJy90bXAvZnRwcm9vdCcgXTsg
dGhlbiBhdGZ0cGQgLS1kYWVtb24gLS1wb3J0IDY5IC90bXAvZnRwcm9vdCAmJiBlY2hvICd0ZnRw
IHNlcnZpY2Ugc3RhcnRlZCc7IGVsc2UgbWtkaXIgJy90bXAvZnRwcm9vdCcgJiYgYXRmdHBkIC0t
ZGFlbW9uIC0tcG9ydCA2OSAvdG1wL2Z0cHJvb3QgJiYgZWNobyAndGZ0cCBzZXJ2aWNlIHN0YXJ0
ZWQnOyBmaSIKCiNuYyB0byBuY2F0CmFsaWFzIG5jPSJuY2F0IgoKI25ldGNhdCB0byBuY2F0CmFs
aWFzIG5ldGNhdD0ibmNhdCIKCiMgZGlyc2VhcmNoIHNob3J0Y3V0CmFsaWFzIGRpcnNlYXJjaD0i
L29wdC9XZWJfVG9vbHMvZGlyc2VhcmNoL2RpcnNlYXJjaC5weSIKCiMgZGlyc2VhcmNoLXF1aWNr
IHVzZXMgY29tbW9uIHdvcmRsaXN0CmFsaWFzIGRpcnNlYXJjaC1xdWljaz0iL29wdC9XZWJfVG9v
bHMvZGlyc2VhcmNoL2RpcnNlYXJjaC5weSAtLXdvcmRsaXN0PS91c3Ivc2hhcmUvd29yZGxpc3Rz
L2RpcmIvY29tbW9uLnR4dCIKCiMgZGlyc2VhcmNoLW1lZGl1bSB1c2VzICJtZWRpdW0iIChhY3R1
YWxseSBsYXJnZSkgd29yZGxpc3QKYWxpYXMgZGlyc2VhcmNoLW1lZGl1bT0iL29wdC9XZWJfVG9v
bHMvZGlyc2VhcmNoL2RpcnNlYXJjaC5weSAtLXdvcmRsaXN0PS91c3Ivc2hhcmUvd29yZGxpc3Rz
L2RpcmJ1c3Rlci9kaXJlY3RvcnktbGlzdC0yLjMtbWVkaXVtLnR4dCIKCmFsaWFzIG1zZmNvbnNv
bGU9InNlcnZpY2UgcG9zdGdyZXNxbCBzdGFydCAmJiBtc2Zjb25zb2xlIgoKCg==" | base64 -d > ~/.bash_aliases

