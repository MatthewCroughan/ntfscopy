#!/bin/bash

SHELL=/bin/bash
dt=$(date +'%b %d %T:')

echo >> /var/log/ntfscopy
echo "$dt" Started ntfscopy.sh >> /var/log/ntfscopy
start() {
    echo /usr/local/bin/ntfscopy.sh "$1" | at now
} >> /var/log/ntfscopy-verbose

start "$@"
