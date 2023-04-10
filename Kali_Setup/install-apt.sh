#!/bin/sh

#get sublime text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# apt get-update/upgrade
apt-get update
apt-get upgrade

#apt install
apt-get install p7zip vlc chromium terminator flameshot shellcheck libreoffice httpie httprobe massdns sublime-text tmux alacritty golang-go gobuster pup gh
apt-get autoremove
