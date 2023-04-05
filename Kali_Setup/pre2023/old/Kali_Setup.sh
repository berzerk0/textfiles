#!/bin/bash
# UPDATE OS

echo "What install mode? (power/light)"
read SETUP_TYPE 

printf "\n \n \n ----Starting apt-gets----\n \n"






if [ "$SETUP_TYPE" = 'power' ]; then
echo "Power Install"
apt-get update -y && apt-get upgrade && apt-get autoremove -y
dpkg --add-architecture i386
apt-get install p7zip borgbackup terminator bleachbit openvas gimp libreoffice -y
apt-get install stegosuite steghide vlc pidgin pidgin-otr deluge  -y

else
if [ "$SETUP_TYPE" = 'light' ]; then

echo "Light Install "
apt-get update -y && apt-get upgrade -y
apt-get install  p7zip steghide sakura bleachbit openvas

cd ~/.config/sakura && mv sakura.conf original.conf && wget https://raw.githubusercontent.com/berzerk0/textfiles/master/sakura.conf 

else
echo "Mode must be 'light' or 'power' "
exit
fi
fi

printf "\n \n \n ----Completed apt-gets, starting gits----\n \n"

#Install LXDE - if you want.
# apt-get install lxde-core lxde kali-defaults kali-root-login desktop-base


#WORDLISTS
mkdir ~/Wordlists && cd ~/Wordlists
wget https://github.com/berzerk0/textfiles/raw/master/some_wordlists.tar.gz
tar xzf some_wordlists.tar.gz && rm some_wordlists.tar.gz

#Generators
mkdir ~/Generators && cd ~/Generators
wget https://github.com/berzerk0/textfiles/raw/master/Generators.tar.gz && tar xzf Generators.tar.gz && rm Generators.tar.gz

#GET OWL https://github.com/berzerk0/textfiles/blob/master/owl.png?raw=true

#OPT FOLDER

##HASHING_TOOLS
mkdir /opt/Hashing_Tools && cd /opt/Hashing_Tools

git clone https://github.com/UltimateHackers/Hash-Buster
#git clone https://github.com/iagox86/hash_extender.git



##OBFUSCATION_TOOLS
mkdir /opt/Obfuscation_Tools && cd /opt/Obfuscation_Tools

git clone https://github.com/TryCatchHCF/Cloakify
git clone https://github.com/viraintel/OWASP-ZSC && python /opt/Obfuscation_Tools/OWASP-ZSC/installer.py
#git clone https://github.com/liftoff/pyminifier



##STEGANOGRAPHY_TOOLS
mkdir /opt/Steganography_Tools && cd /opt/Steganography_Tools

git clone https://github.com/alexadam/img-encode

#mkdir /opt/Steganography_Tools/stegdetect && cd /opt/Steganography_Tools/stegdetect && wget http://archive.debian.org/debian/pool/main/s/stegdetect/stegdetect_0.6-3_amd64.deb && dpkg -i stegdetect_0.6-3_amd64.deb && rm stegdetect_0.6-3_amd64.deb && echo "Run stegdetect from cmd line" > Run_It_From_CMD_Line.txt

#cd /opt/Steganography_Tools  &&
#wget http://www.darkside.com.au/snow/snow-20130616.tar.gz && tar xzf snow-20130616.tar.gz && rm snow-20130616.tar.gz && mv snow-20130616 snow


cd /opt/Steganography_Tools  && mkdir stegsolve && cd stegsolve
wget http://www.caesum.com/handbook/Stegsolve.jar -O stegsolve.jar && chmod +x stegsolve.jar


##OSINT_TOOLS
mkdir /opt/OSINT_Tools && cd /opt/OSINT_Tools

#git clone https://github.com/mschwager/gitem
#git clone https://github.com/WebBreacher/WhatsMyName

###Email_OSINT
mkdir /opt/OSINT_Tools/Email_OSINT && cd /opt/OSINT_Tools/Email_OSINT
git clone https://github.com/laramies/theHarvester
#git clone https://github.com/WebBreacher/emailwhois
#git clone https://github.com/m4ll0k/Infoga.git && cd Infoga && pip install -r requirements.txt && cd ..


###Facebook_OSINT
mkdir /opt/OSINT_Tools/Facebook_OSINT && cd /opt/OSINT_Tools/Facebook_OSINT
git clone https://github.com/guelfoweb/fbid

###LinkedIn_Osint
mkdir /opt/OSINT_Tools/LinkedIn_OSINT && cd /opt/OSINT_Tools/LinkedIn_OSINT
#git clone https://github.com/0x09AL/raven
#git clone https://github.com/mdsecactivebreach/LinkedInt

###Domain_OSINT
mkdir /opt/OSINT_Tools/Domain_OSINT && cd /opt/OSINT_Tools/Domain_OSINT
git clone https://github.com/1N3/Sn1per
#git clone https://github.com/Smaash/snitch
git clone https://github.com/aboul3la/Sublist3r


#mkdir /opt/OSINT_Tools/spiderfoot && cd /opt/OSINT_Tools/spiderfoot
#wget http://sourceforge.net/projects/spiderfoot/files/spiderfoot-2.3.0-src.tar.gz/download && tar xzvf download
#pip install lxml && pip install netaddr && pip install M2Crypto && pip install cherrypy && pip install mako
 


##EXPLOIT_TOOLS
mkdir /opt/Exploit_Tools && cd /opt/Exploit_Tools
git clone https://github.com/1N3/BruteX
git clone https://github.com/1N3/Findsploit && sh /opt/Exploit_Tools/Findsploit/install.sh
git clone https://github.com/1N3/PrivEsc
git clone https://github.com/nccgroup/shocker




#SHELL_TOOLS
mkdir /opt/Shell_Tools && cd /opt/Shell_Tools
git clone https://github.com/infodox/python-pty-shells




#mkdir /opt/Shell_Tools/Web_Shells && cd /opt/Shell_Tools/Web_Shells
#git clone https://github.com/b374k/b374k

#ln -s /usr/share/webshells/ /opt/Shell_Tools/Web_Shells/webshells




#PASSWORDING_TOOLS
mkdir /opt/PasswordCredential_Tools && cd /opt/PasswordCrendential_Tools

git clone https://github.com/berzerk0/BEWGor
mkdir /opt/PasswordCredential_Tools/mutator && cd /opt/PasswordCredential_Tools/mutator
wget https://bitbucket.org/alone/mutator/downloads/mutator_release-v0.2.2-1-gc29ce2b.tar.gz && tar xzf mutator_release-v0.2.2-1-gc29ce2b.tar.gz && rm mutator_release-v0.2.2-1-gc29ce2b.tar.gz



#WEB_TOOLS
mkdir /opt/Web_Tools && cd /opt/Web_Tools
git clone https://github.com/maurosoria/dirsearch && ln -s /opt/Web_Tools/dirsearch/dirsearch.py /usr/bin/dirsearch

##CMS_Tools 
mkdir /opt/Web_Tools/CMS_Tools && cd /opt/Web_Tools/CMS_Tools
git clone https://github.com/Dionach/CMSmap
git clone https://github.com/nahamsec/CMSFuzz
git clone https://github.com/droope/droopescan


#WIRELESS_TOOLS
#mkdir /opt/Wireless_Tools && cd /opt/Wireless_Tools
#git clone https://github.com/wi-fi-analyzer/fluxion
#git clone https://github.com/DanMcInerney/wifijammer
#git clone https://github.com/derv82/wifite2.git


#printf "\n \n \n ----Completed gits, showing browser downloads----\n \n"


#firefox "https://eddie.website/download/?platform=linux&arch=x64&ui=ui&format=debian.deb&version=2.13.6&r=0.9676549577881011"  "https://www.opera.com/computer/thanks?partner=www&par=id%3D42412%26amp;location%3D411&gaprod=opera"  "https://www.activestate.com/komodo-ide/downloads/edit" "https://extensions.gnome.org/extension/1112/screenshot-tool/" "https://discordapp.com/api/download?platform=linux&format=deb" &


#download obs-studio


#openvas-setup


