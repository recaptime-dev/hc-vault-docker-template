#!/bin/bash

# Shell colors for different stuff
useColor() {
  RED=$(printf '\033[31m')
  #GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m')
  #BLUE=$(printf '\033[34m')
  #MAGENTA=$(printf '\033[35m')
  #BOLD=$(printf '\033[1m')
  RESET=$(printf '\033[m')
}

warn() {
  echo "${YELLOW}warning: $* ${RESET}"
}

error() {
  echo "${RED}error: $* ${RESET}"
}

if [[ "$1" == "version" ]] || [[ $1 == "--version" ]]; then
  exec /usr/local/bin/gotty --version
elif [[ "$1" == "help" ]] || [[ $1 == "--help" ]]; then
  warn "If you see 'Incorrect Usage. flag: help requested' error, that's fine. The binary will show usage docs."
  /usr/local/bin/gotty --help
else
  if [[ ! -f "/tmp/.gottylock" ]]; then
    touch /tmp/.gottylock
    exec /usr/local/bin/gotty "$@"
  else
    error "GoTTY lockfile found, not starting a new one. To force it, delete /tmp/.gottylock but you need to expose more ports on Docker."
  fi
fi