#!/bin/sh

## Setup "That" VM - 21 Feb


# get hashbuster
if [ ! -d "/opt/Hashing_Tools" ]; then
        mkdir '/opt/Hashing_Tools' || return
	git clone https://github.com/UltimateHackers/Hash-Buster /opt/Hashing_Tools/Hash-Buster
fi


if [ ! -d "mkdir /opt/Web_Tools/CMS_Tools" ]; then
        mkdir '/opt/Web_Tools/CMS_Tools' || return
	git clone https://github.com/Dionach/CMSmap /opt/Web_Tools/CMS_Tools/CMSmap
	git clone https://github.com/droope/droopescan /opt/Web_Tools/CMS_Tools/droopescan

fi


# set up bash aliases
echo "CiMgIkhvbWUiIERpcmVjdG9yeSBvbiBVU0IKYWxpYXMgdm1kaXI9ImNkIC9tZWRpYS9yb290L1RI
VU1CRVJLTy9PU0NQLVBXSy9TaGFyZV9QV0siCgojIGRpcnNlYXJjaCBzaG9ydGN1dAphbGlhcyBk
aXJzZWFyY2g9Ii9vcHQvV2ViX1Rvb2xzL2RpcnNlYXJjaC9kaXJzZWFyY2gucHkiCgojIGRpcnNl
YXJjaC1xdWljayB1c2VzIGNvbW1vbiB3b3JkbGlzdAphbGlhcyBkaXJzZWFyY2gtcXVpY2s9Ii9v
cHQvV2ViX1Rvb2xzL2RpcnNlYXJjaC9kaXJzZWFyY2gucHkgLS13b3JkbGlzdD0vdXNyL3NoYXJl
L3dvcmRsaXN0cy9kaXJiL2NvbW1vbi50eHQiCgojIGRpcnNlYXJjaC1tZWRpdW0gdXNlcyAibWVk
aXVtIiAoYWN0dWFsbHkgbGFyZ2UpIHdvcmRsaXN0CmFsaWFzIGRpcnNlYXJjaC1tZWRpdW09Ii9v
cHQvV2ViX1Rvb2xzL2RpcnNlYXJjaC9kaXJzZWFyY2gucHkgLS13b3JkbGlzdD0vdXNyL3NoYXJl
L3dvcmRsaXN0cy9kaXJidXN0ZXIvZGlyZWN0b3J5LWxpc3QtMi4zLW1lZGl1bS50eHQiCgoKI2hh
c2hidXN0ZXIKYWxpYXMgaGFzaGJ1c3Rlcj0icHl0aG9uMyAvb3B0L0hhc2hpbmdfVG9vbHMvSGFz
aC1CdXN0ZXIvaGFzaC5weSIK" | base64 -d > ~/.bash_aliases

apt-get install shellcheck

echo "Synched 21 Feb Version at	$(date)" >> "/root/sync_status.txt"
