#!/bin/sh
## HINKYPUNK INFORMATION GATHERING/LISTING SCRIPT

#use WHICH or  if [ ! -f '/bin/PROGRAM' ]; then    to find programs
#cat /etc/*release* find fedora, debian, etc.
# browse user home dirs - which users have them?


cd /dev/shm || exit #move to temporary folder all users can usually access
clear


echo 'HINKYPUNK INFORMATION GATHERING'
echo 
echo '------BEGIN HINKYPUNK------'

echo
echo

echo '------SYSTEM INFORMATION------'
echo "Hostname: $(uname -n)"
echo "Kernel: $(uname -r)"
echo "Architecture: $(uname -m)"
echo "CPU: $(grep -i 'model name' /proc/cpuinfo | cut -d: -f2 | uniq)"
echo  




echo '------USER INFORMATION------'
echo "Current User: $(whoami)"
echo "Your shell is: $(grep "^$(whoami)" /etc/passwd | cut -d: -f7)" 
echo
echo "Your path is: $PATH "

echo

echo "Other Users on the System: $(cut -d: -f 1 /etc/passwd | grep -v "$(whoami)" | sort | tr '\n' ' ')"
echo


echo "Superusers on this machine are: $(grep -v -E "^#" /etc/passwd | awk -F: '$3 == 0 { print $1}')"
echo

echo "Users with /home/ dirs are: $(ls /home/  | sort | tr '\n' ' ')"
echo 

if ! [ $(id -u) = 0 ];
then

if [ -d "/home/$(whoami)" ]; then
echo "$(whoami) has a /home directory"
fi



find / -perm -4000 -type f 2>/dev/null | tr ' ' '\n' | sort > ."$(whoami)_UID_files_HINKYPUNK"
echo "   >>> $(whoami) UID files written to $(pwd)/.$(whoami)_UID_files_HINKYPUNK"

find / -perm -2 -type d 2>/dev/null | tr ' ' '\n' | sort > .world_writable_directories_HINKYPUNK
echo "   >>> List of World Writeable FOLDERS written to $(pwd)/.world_writeable_DIRS_HINKYPUNK"

find / ! -path "*/proc/*" -perm -2 -type f -print 2>/dev/null | tr ' ' '\n' | sort > .world_writable_files_HINKYPUNK
echo "   >>> List of World Writeable FILES (except in /proc/) written to $(pwd)/.world_writeable_FILES_HINKYPUNK"
fi

find /home/ -type f -name '.*' '(' -exec test -r '{}' \; ')' -print 2>/dev/null | sort > .hidden_files_HINKYPUNK
echo "   >>> List of hidden but readable FILES in /home/ written to $(pwd)/.hidden_files_HINKYPUNK"

find /home/ -type d -name '.*' '(' -exec test -r '{}' \; ')' -print 2>/dev/null | sort > .hidden_dirs_HINKYPUNK
echo "   >>> List of hidden but readable FOLDERS in /home/ written to $(pwd)/.hidden_dirs_HINKYPUNK"
echo "If you cannot read the files listed in the two hidden lists, the find command runs as root."


#See recent activity
hinkp_last_a=`last -a 2>/dev/null`
if [ "$hinkp_last_a" ]; then
last -a 2>/dev/null >> .recent_activity_HINKYPUNK
echo "   >>> Recent Activity written to $(pwd)/.recent_activity_HINKYPUNK"
unset hinkp_nc_exists
 


echo
echo '------HANDY PROGRAMS------'
echo

#nc
hinkp_nc_exists=`which nc 2>/dev/null`
if [ "$hinkp_nc_exists" ]; then
echo "nc available"
else 
echo "[-] nc not found"
fi
unset hinkp_nc_exists

#ncat
hinkp_ncat_exists=`which ncat 2>/dev/null`
if [ "$hinkp_ncat_exists" ]; then
echo "ncat available"
else 
echo "[-] ncat not found"
fi
unset hinkp_ncat_exists

#netcat
hinkp_netcat_exists=`which netcat 2>/dev/null`
if [ "$hinkp_netcat_exists" ]; then
echo "netcat available"
else 
echo "[-] netcat not found"
fi
unset hinkp_netcat_exists

#Python
hinkp_python_ver=`which python 2>/dev/null`
if [ "$hinkp_python_ver" ]; then
python -V
else 
echo "[-] Python not found"
fi
unset hinkp_python_ver

#mysql
hinkp_mysql_ver=`mysql --version 2>/dev/null`
if [ "$hinkp_mysql_ver" ]; then
mysql --version
else 
echo "[-] mysql not found"
fi
unset hinkp_mysql_ver


#check for gcc
hinkp_gcc_ver=`which gcc`
if [ "$hinkp_gcc_ver" ]; then
echo 'gcc available'
else 
echo "[-] gcc not found"
fi
unset hinkp_gcc_ver


#Perl
hinkp_perl_ver=`perl -v 2>/dev/null`
if [ "$hinkp_perl_ver" ]; then
echo "Perl: $(perl -v | grep -Eo 'v([0-9]\.*)+')"
else 
echo "[-] Perl not found"
fi
unset hinkp_perl_ver


#Java
hinkp_java_ver=`which java 2>/dev/null` 
if [ "$hinkp_java_ver" ]; then
echo 'Java available'
echo '-----'
java -version
echo '-----'
else 
echo "[-] Java not found"
fi
unset hinkp_java_ver

#Ruby
hinkp_ruby_ver=`ruby -v 2>/dev/null`
if [ "$hinkp_ruby_ver" ]; then
echo "Ruby: $(ruby -v | cut -d' ' -f2)"
else 
echo "[-] Ruby not found"
fi
unset hinkp_ruby_ver
echo

echo
echo '------INSTALLED PACKAGES------'
echo

#Packages
hinkp_debian_packages=`dpkg -l 2>/dev/null` #debian
if [ "$hinkp_debian_packages" ]; then
dpkg -l 2>/dev/null > .installed_pkgs_HINKYPUNK
echo "  >>> List of (debian) installed pkgs written to $(pwd)/.installed_pkgs_HINKYPUNK"
unset hinkp_debian_packages

else
hinkp_rpm_packages=`rpm -qa 2>/dev/null` #rpm_packages
if [ "$hinkp_rpm_packages" ]; then
rpm -qa 2>/dev/null > .installed_pkgs_HINKYPUNK
echo "  >>> List of (rpm) installed pkgs written to $(pwd)/.installed_pkgs_HINKYPUNK"
unset hinkp_rpm_packages

else
hinkp_yum_packages=`yum list | grep installed 2>/dev/null` #yum_packages
if [ "$hinkp_yum_packages" ]; then
yum list | grep installed 2>/dev/null > .installed_pkgs_HINKYPUNK
echo "  >>> List of (yum) installed pkgs written to $(pwd)/.installed_pkgs_HINKYPUNK"
unset hinkp_yum_packages

else
hinkp_pacman_packages=`pacman -Q 2>/dev/null` #pacman_packages
if [ "$hinkp_pacman_packages" ]; then
pacman -Q 2>/dev/null > .installed_pkgs_HINKYPUNK
echo "  >>> List of (pacman) installed pkgs written to $(pwd)/.installed_pkgs_HINKYPUNK"
unset hinkp_pacman_packages

fi
fi
fi
fi
fi

echo
echo
echo "This output has also been saved to $(pwd)/.HINKYPUNK_OUTPUT"


#echo '------SSH KEYS------'
# ls /home/*/.ssh/


#pkginfo
#pkg_info

#httpd -v

#find files owned by root, executable by user
#look for files with "database" in name
#look for wp files, www/var
# mail files


