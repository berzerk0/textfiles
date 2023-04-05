#echo "Updating OS"
#apt-get update && apt-get upgrade
#echo
#echo "Setting Up Metasploit"
#service postgresql start
#update-rc.d postgresql enable
#msfdb init
#echo
#echo

echo "Installing HTTPScreenShot"
echo
pip install selenium
git clone https://github.com/breenmachine/httpscreenshot.git /opt/HTTPScreenshot
cd /opt/httpscreenshot/
chmod +x install-dependencies.sh && ./install-dependencies.sh

echo
echo "Installing SMBExec"
echo
git clone https://github.com/pentestgeek/smbexec.git /opt/SMBExec
cd /opt/smbexec && ./install.sh



echo
echo "Installing Printer Exploits"
echo
cd /opt && git clone https://github.com/MooseDojo/praedasploit.git

echo
echo "Installing Discover"
echo
git clone https://github.com/leebaird/discover.git /opt/discover
cd /opt/discover && ./update.sh


echo
echo "Installing Responder"
echo
git clone https://github.com/SpiderLabs/Responder.git /opt/Responder

echo
echo "Installing THP Custom Scripts"
echo
cd /opt && mkdir THP_Custom_Scripts && cd THP_Custom_Scripts
git clone https://github.com/cheetz/Easy-P.git /opt/Easy-P
git clone https://github.com/cheetz/Password_Plus_One /opt/Password_Plus_One
git clone https://github.com/cheetz/PowerShell_Popup /opt/PowerShell_Popup
git clone https://github.com/cheetz/icmpshock /opt/icmpshock
git clone https://github.com/cheetz/brutescrape /opt/brutescrape
git clone https://www.github.com/cheetz/reddit_xss /opt/reddit_xss

echo
echo "Installing HP Forked Versions"
echo
mkdir /opt/THP_Forks && cd /opt/THP_Forks
git clone https://github.com/cheetz/PowerSploit /opt/HP_PowerSploit
git clone https://github.com/cheetz/PowerTools /opt/HP_PowerTools
git clone https://github.com/cheetz/nishang /opt/nishang

echo
echo "Installing DSHashes"
echo
wget http://ptscripts.googlecode.com/svn/trunk/dshashes.py -O /opt/NTDSXtract/dshashes.py
cd /opt
wget https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/ptscripts/source-archive.zip
cd /opt
mkdir NTDSXtract
read -n 1 -p "Unzip the zip, and take dshashes.py out. Put it into the NTDSExtract Directory THEN  HIT ENTER TO CONTINUE..."


echo
echo "Installing NoSQLMap"
echo
git clone https://github.com/tcstool/NoSQLMap.git /opt/NoSQLMap



echo
echo "Installing Windows Credential Editor"
echo
wget www.ampliasecurity.com/research/wce_v1_4beta_universal.zip
mkdir /opt/wce && unzip wce_v1* -d /opt/wce && rm wce_v1*.zip


echo
echo "Installing PowerSploit"
echo
git clone https://github.com/mattifestation/PowerSploit.git /opt/PowerSploit
cd /opt/PowerSploit && wget https://raw.githubusercontent.com/obscuresec/random/master/StartListener.py && wget https://raw.githubusercontent.com/darkoperator/powershell_scripts/master/ps_encoder.py


echo
echo "Installing Veil"
echo
git clone https://github.com/Veil-Framework/Veil /opt/Veil
cd /opt/Veil/ && ./Install.sh -c



echo "PROCESS COMPLETE"
