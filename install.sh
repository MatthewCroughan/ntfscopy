#!/bin/bash

#========== Logging functions ==========#

#Set Colors

bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

purple=$(tput setaf 171)
red=$(tput setaf 1)
green=$(tput setaf 76)
tan=$(tput setaf 3)
blue=$(tput setaf 38)

# Headers and  Logging

e_header() { printf "\n${bold}${purple}==========  %s  ==========${reset}\n" "$@" 
}
e_arrow() { printf "➜ $@\n"
}
e_success() { printf "${green}✔ %s${reset}\n" "$@"
}
e_error() { printf "${red}✖ %s${reset}\n" "$@"
}
e_warning() { printf "${tan}➜ %s${reset}\n" "$@"
}
e_underline() { printf "${underline}${bold}%s${reset}\n" "$@"
}
e_bold() { printf "${bold}%s${reset}\n" "$@"
}
e_note() { printf "${underline}${bold}${blue}Note:${reset}  ${blue}%s${reset}\n" "$@"
}

try() { if "$@"; then e_success "$* succeeded." >&2; else e_error "$* failed." >&2; fi; }

#=======================================#

if [[ $USER == "root" ]]
then
  e_error "This script must not be run as root!"
  exit 1
fi

e_arrow "Installing ntfscopy"

# Make config directory
try sudo mkdir -p /etc/ntfscopy/
# Get position of the script so that this being ran from elsewhere in the system doesn't impact the script
try cd "$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# We'll need ntfs-3g. Install it if needed.
if [ -z "$(which ntfs-3g)" ]; then
	e_note "I need ntfs-3g and it's missing. I'll install it."
	try sudo apt-get update
	try sudo apt-get --no-install-recommends -y install ntfs-3g
fi

# We'll need at. Install it if needed.
if [ -z "$(which at)" ]; then
	e_note "I need at and it's missing. I'll install it."
 	try sudo apt-get update
	try sudo apt-get --no-install-recommends -y install at
fi

# Install
try sudo cp ./ntfscopy.sh /usr/local/bin/ntfscopy.sh
try sudo cp ./detected.sh /usr/local/bin/detected.sh

try echo 'KERNEL=="sd[a-z]", SUBSYSTEM=="block", ACTION=="add", RUN+="/usr/bin/sudo /usr/local/bin/ntfscopy.sh $name"' | sudo tee /etc/udev/rules.d/99-ntfscopy.rules > /dev/null 2>&1 && e_success "Installed udev rule"

try sudo udevadm control --reload-rules && e_success "Reloading udev rules"
