#!/bin/sh

#Set Up vstftp and configuration
apt-get install vstftpd
cp /etc/vsftpd.conf /etc/original_vstfpd.conf
wget https://raw.githubusercontent.com/berzerk0/textfiles/master/reference_txts/anonymous_vsftpd.conf -O /etc/vsftpd.conf


#add bash alias for tftp

#alias start-tftp="if [ -d '/tmp/ftproot' ]; then atftpd --daemon --port 69 /tmp/ftproot && echo 'tftp service started'; else mkdir '/tmp/ftproot' && atftpd --daemon --port 69 /tmp/ftproot && echo 'tftp service started'; fi"

#alias for nc to ncat
#alias nc="ncat"

#alias netcat to ncat
#alias netcat="ncat"


# set up bash aliases
echo "I0N1cnJlbnQgYXMgb2YgMjcgRmViCgojICJIb21lIiBEaXJlY3Rvcnkgb24gVVNCCmFsaWFzIHZt
ZGlyPSJjZCAvbWVkaWEvcm9vdC9USFVNQkVSS08vT1NDUC1QV0svU2hhcmVfUFdLIgoKIyBkaXJz
ZWFyY2ggc2hvcnRjdXQKYWxpYXMgZGlyc2VhcmNoPSIvb3B0L1dlYl9Ub29scy9kaXJzZWFyY2gv
ZGlyc2VhcmNoLnB5IgoKIyBkaXJzZWFyY2gtcXVpY2sgdXNlcyBjb21tb24gd29yZGxpc3QKYWxp
YXMgZGlyc2VhcmNoLXF1aWNrPSIvb3B0L1dlYl9Ub29scy9kaXJzZWFyY2gvZGlyc2VhcmNoLnB5
IC0td29yZGxpc3Q9L3Vzci9zaGFyZS93b3JkbGlzdHMvZGlyYi9jb21tb24udHh0IgoKIyBkaXJz
ZWFyY2gtbWVkaXVtIHVzZXMgIm1lZGl1bSIgKGFjdHVhbGx5IGxhcmdlKSB3b3JkbGlzdAphbGlh
cyBkaXJzZWFyY2gtbWVkaXVtPSIvb3B0L1dlYl9Ub29scy9kaXJzZWFyY2gvZGlyc2VhcmNoLnB5
IC0td29yZGxpc3Q9L3Vzci9zaGFyZS93b3JkbGlzdHMvZGlyYnVzdGVyL2RpcmVjdG9yeS1saXN0
LTIuMy1tZWRpdW0udHh0IgoKI2hhc2hidXN0ZXIKYWxpYXMgaGFzaGJ1c3Rlcj0icHl0aG9uMyAv
b3B0L0hhc2hpbmdfVG9vbHMvSGFzaC1CdXN0ZXIvaGFzaC5weSIKCiN0ZnRwIHF1aWNrIHN0YXJ0
CmFsaWFzIHN0YXJ0LXRmdHA9ImlmIFsgLWQgJy90bXAvZnRwcm9vdCcgXTsgdGhlbiBhdGZ0cGQg
LS1kYWVtb24gLS1wb3J0IDY5IC90bXAvZnRwcm9vdCAmJiBlY2hvICd0ZnRwIHNlcnZpY2Ugc3Rh
cnRlZCc7IGVsc2UgbWtkaXIgJy90bXAvZnRwcm9vdCcgJiYgYXRmdHBkIC0tZGFlbW9uIC0tcG9y
dCA2OSAvdG1wL2Z0cHJvb3QgJiYgZWNobyAndGZ0cCBzZXJ2aWNlIHN0YXJ0ZWQnOyBmaQoKI25j
IHRvIG5jYXQKYWxpYXMgbmM9Im5jYXQiCgojbmV0Y2F0IHRvIG5jYXQKYWxpYXMgbmV0Y2F0PSJu
Y2F0Igo=" | base64 -d > ~/.bash_aliases


echo "Synched 27 Feb Version at	$(date)" >> "/root/sync_status.txt"
