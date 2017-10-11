# UPDATE OS

apt-get update && apt-get upgrade
apt-get install exiftool
apt-get install gimp
apt-get install audacity


#OPT FOLDER

##HASHING_TOOLS
mkdir /opt/Hashing_Tools && cd /opt/Hashing_Tools

git clone https://github.com/psypanda/hashID
git  clone https://github.com/UltimateHackers/Hash-Buster


##OBFUSCATION_TOOLS
mkdir /opt/Obfuscation_Tools && cd /opt/Obfuscation_Tools

git clone https://github.com/TryCatchHCF/Cloakify
git clone https://github.com/viraintel/OWASP-ZSC
git clone https://github.com/liftoff/pyminifier



##STEGANOGRAPHY_TOOLS
mkdir /opt/Steganography_Tools && cd /opt/Steganography_Tools

git clone https://github.com/alexadam/img-encode
wget http://www.darkside.com.au/snow/snow-20130616.tar.gz && tar xzf snow-20130616.tar.gz && rm snow-20130616.tar.gz && mv snow-20130616 snow
git clone https://github.com/abeluck/stegdetect

mkdir stegsolve && cd stegsolve
wget http://www.caesum.com/handbook/Stegsolve.jar -O stegsolve.jar && chmod +x stegsolve.jar


##OSINT_TOOLS
mkdir /opt/OSINT_Tools && cd /opt/OSINT_Tools

git clone https://github.com/mschwager/gitem
git clonehttps://github.com/WebBreacher/WhatsMyName

mkdir spiderfoot && cd spiderfoot
wget http://sourceforge.net/projects/spiderfoot/files/spiderfoot-2.3.0-src.tar.gz/download && tar xzvf download
pip install lxml && pip install netaddr && pip install M2Crypto && pip install cherrypy && pip install mako

###Email_OSINT
mkdir /opt/Email_OSINT && cd /opt/Email_OSINT
git clone https://github.com/laramies/theHarvester
git clone https://github.com/WebBreacher/emailwhois
git clone https://github.com/m4ll0k/Infoga.git && cd Infoga && pip install -r requirements.txt && cd ..


###Facebook_OSINT
mkdir /opt/Facebook_OSINT && cd /opt/Facebook_OSINT
git clone https://github.com/guelfoweb/fbid

###LinkedIn_Osint
mkdir /opt/LinkedIn_OSINT && cd /opt/LinkedIn_OSINT
git clone https://github.com/0x09AL/raven
git clone https://github.com/mdsecactivebreach/LinkedInt

###Domain_OSINT
mkdir /opt/OSINT_Tools/Domain_OSINT && cd /opt/OSINT_Tools/Domain_OSINT
git clone https://github.com/1N3/Sn1per
git clone https://github.com/Smaash/snitch
 


##EXPLOIT_TOOLS
mkdir /opt/Exploit_Tools && cd /opt/Exploit_Tools
git clone https://github.com/1N3/BruteX
git clone https://github.com/1N3/Findsploit
git clone https://github.com/1N3/PrivEsc
git clone https://github.com/nccgroup/shocker


#SHELL_TOOLS
mkdir /opt/Shell_Tools cd /opt/Shell_Tools

git clone https://github.com/infodox/python-pty-shells
ln -s /usr/share/webshells/ /opt/Exploit_Tools/webshells


mkdir /opt/Shell_Tools/Web_Shells && cd /opt/Shell_Tools/Web_Shells
https://github.com/b374k/b374k




#PASSWORDING_TOOLS
mkdir /opt/PasswordCredential_Tools cd /opt/PasswordCrendtial_Tools

git clone https://github.com/berzerk0/BEWGor
git clone https://github.com/lightos/credmap
git clone https://github.com/urbanadventurer/username-anarchy

mkdir /opt/PasswordCredential_Tools/mutator && cd /opt/PasswordCredential_Tools/mutator
wget https://bitbucket.org/alone/mutator/downloads/mutator_release-v0.2.2-1-gc29ce2b.tar.gz && tar xzf mutator_release-v0.2.2-1-gc29ce2b.tar.gz && rm mutator_release-v0.2.2-1-gc29ce2b.tar.gz



#WEB_TOOLS
mkdir /opt/Web_Tools && cd /opt/Web_Tools
git clone https://github.com/ChrisTruncer/EyeWitness.git
git clone https://github.com/maurosoria/dirsearch

##CMS_Tools 
mkdir /opt/Web_Tools/CMS_Tools && cd /opt/Web_Tools/CMS_Tools
git clone https://github.com/Dionach/CMSmap
git clone https://github.com/nahamsec/CMSFuzz
git clone https://github.com/droope/droopescan

  



