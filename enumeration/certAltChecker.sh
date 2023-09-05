#!/bin/bash

domain="$1"

echo | openssl s_client -showcerts -servername "$domain" -connect "$domain":443 2>/dev/null \
| openssl x509 -inform pem -noout -ext subjectAltName \
| grep 'DNS' | tr -s ' ' | tr ' ' '\n' \
| tr -d ',' | cut -d ':' -f 2 | grep -E '[a-z]' | sort -u

