## HINKYPUNK INFORMATION GATHERING/LISTING SCRIPT

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

echo '------HANDY PROGRAMS------'

which nc
which vi
which vim



 
#software versions

#gcc -v 
#mysql --version
#perl -v
#ruby -v
#python --version
#java -version
