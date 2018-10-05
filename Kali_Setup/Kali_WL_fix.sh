apt-get update

apt-get install linux-image-$(uname -r|sed 's,[^-]*-[^-]*-,,') linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') broadcom-sta-dkms


wget http://http.kali.org/kali/pool/main/l/linux/linux-kbuild-4.17_4.17.17-1kali1_amd64.deb
wget http://http.kali.org/kali/pool/main/l/linux/linux-headers-4.17.0-kali1-common_4.17.8-1kali1_all.deb
wget http://http.kali.org/kali/pool/main/l/linux/linux-headers-4.17.0-kali1-amd64_4.17.8-1kali1_amd64.deb


dpkg -i linux-kbuild-4.17_4.17.17-1kali1_amd64.deb
dpkg -i linux-headers-4.17.0-kali1-common_4.17.8-1kali1_all.deb
dpkg -i linux-headers-4.17.0-kali1-amd64_4.17.8-1kali1_amd64.deb


modprobe -r b44 b43 b43legacy ssb brcmsmac bcma


modprobe wl
