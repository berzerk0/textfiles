#!/bin/sh
## HINKYPUNK INFORMATION GATHERING/LISTING SCRIPT




cd /dev/shm || exit #move to temporary folder all users can usually access
clear


echo 'HINKYPUNK INFORMATION GATHERING'
printf "\\n"
echo '------BEGIN HINKYPUNK------'

printf "\\n \\n"

echo '------SYSTEM INFORMATION------'
echo "Hostname: $(uname -n)"
echo "Kernel: $(uname -r)"
echo "Architecture: $(uname -m)"
echo "CPU: $(grep -i 'model name' /proc/cpuinfo | cut -d: -f2 | uniq)"
echo "OS Info: Check /etc/*release*"
printf "\\n"




echo '------USER INFORMATION------'
echo "Current User: $(whoami)"
echo "Your shell is: $(grep "^$(whoami)" /etc/passwd | cut -d: -f7)"
printf "Your path is: $PATH \n"



printf "\nOther Users on the System:\n$(cut -d: -f 1 /etc/passwd | grep -v "$(whoami)" | sort | tr '\n' ' ') \n"



printf "\nSuperusers on this machine are: $(grep -v -E "^#" /etc/passwd | awk -F: '$3 == 0 { print $1}') \n"


hinkp_homedirs=$(ls /home/  | sort | tr '\n' ' ' 2>/dev/null)
if [ "$hinkp_homedirs" ]; then
	printf "\nUsers with /home/ dirs are: $(ls /home/  | sort | tr '\n' ' ')\n"
fi

printf "\n"

if ! [ "$(id -u)" = 0 ]; then #if current user != root

	#Check if user has home dir
	if [ -d "/home/$(whoami)" ]; then
		printf "current user ($(whoami)) has a /home/ directory"
		printf "\\n"
	fi

	printf "\\n"

	#find user UID files
	#find / -perm -4000 -type f 2>/dev/null | tr ' ' '\n' | sort > ."$(whoami)_UID_files_HINKYPUNK"
	#echo "   >>> $(whoami) UID files written to $(pwd)/.$(whoami)_UID_files_HINKYPUNK"


	gtfoString="apt apt-get aria2c ash awk base64 bash busybox cancel cat chmod chown cp cpan cpulimit crontab csh curl cut dash date dd diff dmesg dmsetup docker easy_install ed emacs env expand expect facter file find finger flock fmt fold ftp gdb git grep head ionice irb jjs journalctl jq jrunscript ksh ld.so less ltrace lua mail make man more mount mv mysql nano nc nice nl nmap node od openssl perl pg php pic pico pip puppet python readelf red rlogin rlwrap rpm rpmquery rsync ruby run-mailcap run-parts rvim scp sed setarch sftp shuf smbclient socat sort sqlite3 ssh start-stop-daemon stdbuf strace tail tar taskset tclsh tcpdump tee telnet tftp time timeout ul unexpand uniq unshare vi vim watch wget whois wish xargs xxd zip zsh"

	## find SUID binaries
	gtfoStandardSuid=$(find / -perm -4000 -type f 2>/dev/null | rev | cut -d '/' -f 1 | rev | sort -u)

	## find SUID binaries owned by root
	gtfoRootSuid=$(find / -uid 0 -perm -4000 -type f 2>/dev/null | rev | cut -d '/' -f 1 | rev | sort -u)


	#print out both standard and array, find matches
	gtfoStandardResult=$(echo "$gtfoStandardSuid" "$gtfoString" | tr ' ' '\n' | sort | uniq -c | sort -n -r | egrep '^\s*2' |  tr -s ' ' | cut -d ' ' -f 3)

	#print out both root and list, find matches
	gtfoRootResult=$(echo "$gtfoRootSuid" "$gtfoString" | tr ' ' '\n' | sort | uniq -c | sort -n -r | egrep '^\s*2' |  tr -s ' ' | cut -d ' ' -f 3)


	echo "The following SUID files, belonging to \"$(whoami)\", are found on GTFOBins:"
	echo $gtfoStandardResult | tr ' ' '\n' | sed -e 's/^/   /'
	echo

	if [ "$gtfoRootResult" ]; then
		echo "Of those, the following are owned by root:"
		echo $gtfoRootResult | sed -e 's/^/    /'
		echo
	fi

	unset gtfoString gtfoStandardSuid gtfoRootSuid gtfoStandardResult gtfoRootResult

	#find directories writable by all users
	find / -perm -2 -type d 2>/dev/null | tr ' ' '\n' | sort > .world_writable_directories_HINKYPUNK
	echo "   >>> List of World Writable FOLDERS written to $(pwd)/.world_writable_DIRS_HINKYPUNK"

	#find files writable by all users
	find / ! -path "*/proc/*" -perm -2 -type f -print 2>/dev/null | tr ' ' '\n' | sort > .world_writable_files_HINKYPUNK
	printf "   >>> List of World Writable FILES (except in /proc/) written to $(pwd)/.world_writable_FILES_HINKYPUNK\\n"

	#find hidden files readable by the current user
	find /home/ -type f -name '.*' '(' -exec test -r '{}' \; ')' -print 2>/dev/null | sort > .hidden_files_HINKYPUNK
	echo "   >>> List of hidden but readable FILES in /home/ written to $(pwd)/.hidden_files_HINKYPUNK"

	#find hidden directories readable by the current user
	find /home/ -type d -name '.*' '(' -exec test -r '{}' \; ')' -print 2>/dev/null | sort > .hidden_dirs_HINKYPUNK
	echo "   >>> List of hidden but readable FOLDERS in /home/ written to $(pwd)/.hidden_dirs_HINKYPUNK"

	printf " \\n If you cannot read the files listed in the two hidden lists, the find command runs as root. \\n\\n"

fi



#See crons
hinkp_crons=$(cat /etc/cron.d/automate 2>/dev/null | grep '\*')
if [ "$hinkp_crons" ]; then
	echo "cron jobs scheduled are..."
	cat /etc/cron.d/automate 2>/dev/null | grep '\*' | tee .cron_jobs_HINKYPUNK
	printf "\n"
fi
unset hinkp_crons

#See recent activity
hinkp_last_a=$(last -a 2>/dev/null)
if [ "$hinkp_last_a" ]; then
	last -a 2>/dev/null >> .recent_activity_HINKYPUNK
	echo "   >>> Recent Activity written to $(pwd)/.recent_activity_HINKYPUNK"
fi
unset hinkp_last_a



echo
echo '------HANDY PROGRAMS------'
echo

#nc
hinkp_nc_exists=$(which nc 2>/dev/null)
if [ "$hinkp_nc_exists" ]; then
	echo "nc available"
else
	echo "[-] nc not found"
fi
unset hinkp_nc_exists

#ncat
hinkp_ncat_exists=$(which ncat 2>/dev/null)
if [ "$hinkp_ncat_exists" ]; then
	echo "ncat available"
else
	echo "[-] ncat not found"
fi
unset hinkp_ncat_exists

#netcat
hinkp_netcat_exists=$(which netcat 2>/dev/null)
if [ "$hinkp_netcat_exists" ]; then
	echo "netcat available"
else
	echo "[-] netcat not found"
fi
unset hinkp_netcat_exists

#Python2
hinkp_python2_ver=$(which python >/dev/null)
if [ "$hinkp_python2_ver" ]; then
	python -V
else
	echo "[-] Python 2 not found"
fi
unset hinkp_python2_ver

#Python3
hinkp_python3_ver=$(which python3 2>/dev/null)
if [ "$hinkp_python3_ver" ]; then
	python3 -V
else
	echo "[-] Python 3 not found"
fi
unset hinkp_python3_ver

#nmap
hinkp_nmap_ver=$(which nmap 2>/dev/null)
if [ "$hinkp_nmap_ver" ]; then
	echo "nmap available"
	echo "-----"
	nmap -V
	echo "-----"
	else
	echo "[-] nmap not found"
fi
unset hinkp_nmap_ver


#mysql
hinkp_mysql_ver=$(mysql --version 2>/dev/null)
if [ "$hinkp_mysql_ver" ]; then
	mysql --version

	hinkp_mysql_nopass=$(mysqladmin -uroot version 2>/dev/null)
	if [ "$hinkp_mysql_nopass" ]; then
		echo " !!! mysql root can be logged into without a password !!!"

	else
		hinkp_mysql_nopass=$(mysqladmin -uroot -proot version 2>/dev/null)
		if [ "$hinkp_mysql_nopass" ]; then
			echo " !!! mysql root can be logged into as 'root' with password 'root' !!!"

		else
			hinkp_mysql_nopass=$(mysqladmin -uroot -pmysqlpass version 2>/dev/null)
			if [ "$hinkp_mysql_nopass" ]; then
				echo " !!! mysql root can be logged into as 'root' with password 'mysqlpass' !!!"
			fi
		fi
	fi
	unset hinkp_mysql_nopass

else
	echo "[-] mysql not found"
fi
unset hinkp_mysql_ver


#check for gcc
hinkp_gcc_ver=$(which gcc)
if [ "$hinkp_gcc_ver" ]; then
	echo 'gcc available'
else
	echo "[-] gcc not found"
fi
unset hinkp_gcc_ver


#Perl
hinkp_perl_ver=$(perl -v 2>/dev/null)
if [ "$hinkp_perl_ver" ]; then
	echo "Perl: $(perl -v | grep -Eo 'v([0-9]\.*)+')"
else
	echo "[-] Perl not found"
fi
unset hinkp_perl_ver


#Java
hinkp_java_ver=$(which java 2>/dev/null)
if [ "$hinkp_java_ver" ]; then
	echo "Java available"
	echo "-----"
	java -version
	echo "-----"
	else
	echo "[-] Java not found"
fi
unset hinkp_java_ver


#Ruby
hinkp_ruby_ver=$(ruby -v 2>/dev/null)
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
hinkp_debian_packages=$(dpkg -l 2>/dev/null) #debian
if [ "$hinkp_debian_packages" ]; then
	dpkg -l 2>/dev/null > .installed_pkgs_HINKYPUNK
	echo "  >>> List of (debian) installed pkgs written to $(pwd)/.installed_pkgs_HINKYPUNK"
	unset hinkp_debian_packages

else
	hinkp_rpm_packages=$(rpm -qa 2>/dev/null) #rpm_packages
	if [ "$hinkp_rpm_packages" ]; then
		rpm -qa 2>/dev/null > .installed_pkgs_HINKYPUNK
		echo "  >>> List of (rpm) installed pkgs written to $(pwd)/.installed_pkgs_HINKYPUNK"
		unset hinkp_rpm_packages

	else

		hinkp_yum_packages=$(yum list | grep installed 2>/dev/null) #yum_packages
		if [ "$hinkp_yum_packages" ]; then
			yum list | grep installed 2>/dev/null > .installed_pkgs_HINKYPUNK
			echo "  >>> List of (yum) installed pkgs written to $(pwd)/.installed_pkgs_HINKYPUNK"
		unset hinkp_yum_packages

		else
			hinkp_pacman_packages=$(pacman -Q 2>/dev/null) #pacman_packages
			if [ "$hinkp_pacman_packages" ]; then
				pacman -Q 2>/dev/null > .installed_pkgs_HINKYPUNK
				echo "  >>> List of (pacman) installed pkgs written to $(pwd)/.installed_pkgs_HINKYPUNK"
				unset hinkp_pacman_packages

			fi
		fi
	fi
fi


echo
echo

#echo '------SSH KEYS------'
# ls /home/*/.ssh/


#pkginfo
#pkg_info

#httpd -v

#find files owned by root, executable by user
#look for files with "database" in name
#look for wp files, www/var
# mail files
