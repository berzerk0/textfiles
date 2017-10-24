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

if ! [ $(id -u) = 0 ];
then

if [ -d "/home/$(whoami)" ]; then
echo "$(whoami) has a /home directory"
fi


find / -perm -4000 -type f 2>/dev/null | tr ' ' '\n' | sort > ."$(whoami)_UID_files.txt"
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
hinkp_python_ver=`which python`
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
hinkp_java_ver=`which java` 
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




#echo '------SSH KEYS------'
# ls /home/*/.ssh/

#dpkg -l
#rpm -qa
#yum list | grep installed
#pacman -Q
#pkginfo
#pkg_info

#sudo -V
#httpd -v
#last -a

#find /var/log ­type f ­perm 0004 2>/dev/nul


