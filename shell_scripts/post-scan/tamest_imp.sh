### WORK IN PROGRESS
## DO NOT USE


#!/bin/bash

#creates a reference file to be used as a timestamp reference

mkdir /dev/shm/.imps
touch /dev/shm/.imps/.tamest_imp_$(date | cut -d ' ' -f 5 | cut -d ':' -f -2 | tr ':' '-')



#makes copies of different logfiles to be restored upon exit

#Do history files exist?
#Do log files exist?
#which ones are neeeed







#script then deletes itself
imp_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -f "$imp_dir/tamest_imp.sh" ]; then
  imp_shred_exists=$(which shred 2>/dev/null)

  if [ "$imp_shred_exists" ]; then
    shred -fuz $imp_dir/tamest_imp.sh

  else
    dd if=/dev/urandom of=$imp_dir/tamest_imp.sh bs=1 count=10
    rm $imp_dir/tamest_imp.sh
  fi

fi
unset imp_shred_exists
unset imp_dir
