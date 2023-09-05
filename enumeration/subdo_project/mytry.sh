#!/bin/bash
# shellcheck disable=check-extra-masked-returns
# subfinder2dnsx.sh
# 5tr41gh7 gh3tt0 5cr1p7 --

#NOTE: run with --
# bash subfinder2dnsx.sh domain.com

# #NOTE: check for go --
# if test go; then
#     echo "=> go found"
#     echo "=> checking -> \$GOPATH"
#     if [[ -z ${GOPATH} ]]; then
#         echo "=> \$GOPATH is not set"
#         echo "=> please set \$GOPATH"
#         echo "=> mkdir -p \$HOME/Workspace ; export GOPATH=\$HOME/Workspace"
#         echo "=> export PATH=\$PATH:\$GOPATH/bin"
#         echo "=> you may want to set these permanently in your ~/.bashrc or ~/.zshrc"
#         exit
#     else
#         echo "=> \$GOPATH is set"
#     fi
# else
#     echo "=> go not found"
#     echo "=> please install go"
#     exit
# fi

#NOTE: required binaries --
# if test subfinder || test dnsx || test jq || true; then
if [[ ! $(which subfinder) ]]; then
    echo "=> subfinder not found"
    echo "=> install subfinder -> go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    exit
else
    echo "=> subfinder found"
fi

if [[ ! $(which dnsx) ]]; then
    echo "=> dnsx not found"
    echo "=> install dnsx -> go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
    exit
else
    echo "=> dnsx found"
fi

if [[ ! $(which jq) ]]; then
    echo "=> jq not found"
    echo "=> install jq -> sudo apt install jq"
    echo "=> install jq -> sudo pacman -Sy jq"
    exit
else
    echo "=> jq found"
fi

#NOTE: script functions  --
function do_script_functions() {
  # do subfinder; dnsx and parse output --

  the_date=$(date "+%m%d%Y%M%S")
  raw_json=${PWD}/$1_${the_date}_subfinder.json
  dnsx_json=${PWD}/$1_${the_date}_dnsx.json
  dnsx_csv=${PWD}/$1_${the_date}_dnsx.csv

  # do subfinder --
  subfinder_status=$(subfinder -silent -d "$1" -json -o "${raw_json}")
  if [[ ${subfinder_status} == 0 ]]; then
      echo -ne "\n=> subfinder failed\n"
      exit 1
  else
      echo -ne "=> subfinder success\n"
      echo -ne "=> subfinder output -> ${raw_json}"
  fi

  # do dnsx --
  dnsx_status=$(cat "${raw_json}" | jq .host -r | \
    dnsx -silent -l - -a -cname -json -o "${dnsx_json}")
  if [[ ${dnsx_status} == 0 ]]; then
      echo -ne "\n=> dnsx failed\n"
      exit 1
  else
      echo -ne "=> dnsx success\n"
      echo -ne "=> dnsx output -> ${dnsx_json}\n"
  fi

  # parse output --
  cat "${dnsx_json}" | jq '.a[]?' -r | \
    sort -u | uniq | \
    tee -a "${PWD}/$1.dnsx.a_${the_date}.txt" >/dev/null

  cat "${dnsx_json}" | jq '.cname[]?' -r | \
    sort -u | uniq | \
    tee -a "${PWD}/$1.dnsx.cname_${the_date}.txt" >/dev/null

  cat "${dnsx_json}" | jq '.host' -r | \
    sort -u | uniq | \
    tee -a "${PWD}/$1.dnsx.host_${the_date}.txt" >/dev/null

  # list the files --
  echo -ne "\n=> listing files\n"
  find -type f -name "*${the_date}*" -exec ls -lh {} \; 2>/dev/null
}

#NOTE: finally; our ghetto main --
echo -ne "\n=> starting the script\n"
do_script_functions "$@"


# output to CSV

(head -1 "$dnsx_json" | jq -r 'keys_unsorted | @csv' && jq -r 'map(tostring) | @csv' < "$dnsx_json") > "$dnsx_csv"


#__eof__