#!/bin/bash

SHELL=/bin/bash

echo >> /var/log/ntfscopy
echo Started ntfscopy.sh >> /var/log/ntfscopy
echo /usr/local/bin/ntfscopy.sh $1 | at now
