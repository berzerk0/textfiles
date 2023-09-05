#! /bin/bash
#THIS SCRIPT IS BASCIALLY AUTOMATED NOTES
# IT WILL NOT CHECK FOR EXISTING CONTENT OR ANYTHING ELSE
# IT IS _NOT_ A ONE STOP SHOP


#top level
cd /opt/
git clone https://github.com/gchq/CyberChef
cd ..




#recon folder
cd /opt
mkdir /opt/recon
cd /opt/recon
git clone https://github.com/MrH0wl/Cloudmare.git
git clone https://github.com/punk-security/dnsReaper
#findomain - do manually
# trufflehog - do manullay

# payloads and strings
cd /opt
mkdir /opt/payloads_and_strings
cd /opt/payloads_and_strings
git clone https://github.com/danielmiessler/SecLists
git clone https://github.com/swisskyrepo/PayloadsAllTheThings
git clone https://github.com/fuzzdb-project/fuzzdb


# obfuscation
cd /opt
mkdir /opt/obfuscation
cd /opt/obfuscation
git clone https://github.com/aemkei/jsfuck


cd /opt
chown kali:bengroup -R *
