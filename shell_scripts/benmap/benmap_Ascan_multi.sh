#!/bin/bash

#./benmap_Ascan_multi.sh FILENAME.txt

#FILE must be in "ip,hostname" format


while read -r line
do

  ip_addr=$(echo $line | cut -d ',' -f 1)
  box_name=$(echo $line | cut -d ',' -f 2)

  #Alias for output directory
  benmap_dir="$HOME/CTFs/$box_name"

  # If output directory does not exist, create and move into it.
  if [ ! -d "$benmap_dir" ]; then
  	mkdir ~/CTFs/$box_name && cd ~/CTFs/$box_name || return
  	touch "NOTES_$box_name.txt"
  else
    cd ~/CTFs/$box_name || return
  fi

  #If output dir does exist, but not NOTES file, create notes file.
  if [ ! -f "$HOME/CTFs/NOTES_$box_name.txt" ]; then
  	touch "NOTES_$box_name.txt"
  fi

  nmap -A -T4 "$ip_addr" -oA nmap_"$box_name"_AScan




done < "$1"
