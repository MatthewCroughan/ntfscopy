#!/bin/bash


red=$(tput setaf 1)
green=$(tput setaf 76)

e_success() { printf "${green}✔ %s${reset}\n" "$@"
}
e_error() { printf "${red}✖ %s${reset}\n" "$@"
}

try() { if "$@"; then e_success "$* succeeded." >&2; else e_error "$* failed." >&2; fi; }

try mkdir fuck
