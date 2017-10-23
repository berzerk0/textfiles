## HINKYPUNK INFORMATION GATHERING/LISTING SCRIPT

#use WHICH or  if [ ! -f '/bin/PROGRAM' ]; then    to find programs
#cat /etc/*release* find fedora, debian, etc.
# browse user home dirs - which users have them?



cd /dev/shm #move to temporary folder all users can usually access
#history > .history_before_hinky.txt
clear


echo 'HINKYPUNK INFORMATION GATHERING'
echo 
echo '------BEGIN HINKYPUNK------'

echo
echo

echo '------SYSTEM INFORMATION------'
echo Hostname: $(uname -n)
echo Kernel: $(uname -r)
echo Architecture: $(uname -m)
echo CPU: $(cat /proc/cpuinfo | grep -i 'model name' | cut -d: -f2 | uniq)
echo  

echo '------USER INFORMATION------'
echo "Current User: $(whoami)"
echo "Your shell is: $(grep ^$(whoami) /etc/passwd | cut -d: -f7)" 
echo
echo "Your path is: $PATH "

echo

echo "Other Users on the System: $(cut -d: -f 1 /etc/passwd | grep -v $(whoami) | sort | tr '\n' ' ')"
echo


echo "Superusers on this machine are: $(grep -v -E "^#" /etc/passwd | awk -F: '$3 == 0 { print $1}')"
echo

find / -perm -4000 -type f 2>/dev/null | tr ' ' '\n' | sort > .$(whoami)_UID_files.txt
echo "   >>> $(whoami) UID files written to $(pwd)/.$(whoami)_UID_files_HINKYPUNK"

find / -perm -2 -type d 2>/dev/null | tr ' ' '\n' | sort > .world_writable_directories_HINKYPUNK
echo "   >>> List of World Writeable FOLDERS written to $(pwd)/.world_writable_DIRS_HINKYPUNK"

find / ! -path "*/proc/*" -perm -2 -type f -print 2>/dev/null | tr ' ' '\n' | sort > .world_writable_files_HINKYPUNK
echo "   >>> List of World Writeable FILES (except in /proc/) written to $(pwd)/.world_writable_FILES_HINKYPUNK"

#find / -type f -name '.*' '(' -exec test -r '{}' \; ')' -print 2>/dev/null #show all hidden files the user can read
#find / -type d -name '.*' '(' -exec test -r '{}' \; ')' -print 2>/dev/null #show all hidden dirs the user can read
#if these return files that cannot be read - find may be running as root



if [ -d "/home/$(whoami)" ]; then
echo "[+] nc available
else 
echo " [-] nc not found"
fi



echo '------HANDY PROGRAMS------'

#nc
hinkp_nc_exists=`which nc 2>/dev/null`
if [ "$hinkp_nc_exists" ]; then
echo "[+] nc available
else 
echo " [-] nc not found"
fi
unset hinkp_nc_exists

#ncat
hinkp_ncat_exists=`which ncat 2>/dev/null`
if [ "$hinkp_ncat_exists" ]; then
echo "[+] ncat available
else 
echo " [-] ncat not found"
fi
unset hinkp_ncat_exists

#netcat
hinkp_netcat_exists=`which netcat 2>/dev/null`
if [ "$hinkp_ncat_exists" ]; then
echo "[+] netcat available
else 
echo " [-] netcat not found"
fi
unset hinkp_netcat_exists

#Python
hinkp_python_ver=`python -V 2>/dev/null`; 
if [ "$hinkp_python_ver" ]; then
python -V
else 
echo " [-] Python not found"
fi
unset hinkp_python_ver

#mysql
hinkp_mysql_ver=`mysql --version 2>/dev/null`
if [ "$hinkp_mysql_ver" ]; then
echo "[+] mysql : $(mysql --version | tr -s ' ' | cut -d' ' -f3-)
else 
echo " [-] mysql not found"
fi
unset hinkp_mysql_ver


#check for gcc
hinkp_gcc_ver=`gcc -v 2>/dev/null`
if [ "$hinkp_gcc_ver" ]; then

else 
echo " [-] gcc not found"
fi
unset hinkp_gcc_ver

#mysql
hinkp_mysql_ver=`mysql --version 2>/dev/null`
if [ "$hinkp_mysql_ver" ]; then
echo "[+] mysql : $(mysql --version | tr -s ' ' | cut -d' ' -f3-)
else 
echo " [-] mysql not found"
fi
unset hinkp_mysql_ver


#Perl
hinkp_perl_ver=`perl -v 2>/dev/null`
if [ "$hinkp_perl_ver" ]; then
echo " [+] Perl: $(perl -v | egrep -o 'v([0-9]\.*)+')"
else 
echo " [-] Perl not found"
fi
unset hinkp_perl_ver



#Java
hinkp_java_ver=`java -version 2>/dev/null`; 
if [ "$hinkp_java_ver" ]; then
java -version
else 
echo " [-] Java not found"
fi
unset hinkp_java_ver

#Ruby
hinkp_ruby_ver=`ruby -v 2>/dev/null`; 
if [ "$hinkp_ruby_ver" ]; then
echo " [+] Ruby: $(ruby -v | cut -d' ' -f2)"
else 
echo " [-] Ruby not found"
fi
unset hinkp_ruby_ver


#gcc -v 


#echo '------SSH KEYS------'
# ls /home/*/.ssh/

