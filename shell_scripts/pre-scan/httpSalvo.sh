#!/bin/bash

# ideas for this script
# support https
# support non-port 80

#$1 = ip_addr


fimap -H -d 3 -u "http://$1" -w /tmp/fimap_output | tee fimap_result & \
nikto -h \"http://$1\" -o nikto_result.txt & \
dirsearch -u $1 -e php,txt,sh,html,htm -f --simple-report=dirsearch_quick
