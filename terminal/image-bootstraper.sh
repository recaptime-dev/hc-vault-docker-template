#!/usr/bin/dumb-init /bin/bash
# shellcheck shell=bash

# Shell colors for different stuff
useColor() {
  RED=$(printf '\033[31m')
  #GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m')
  #BLUE=$(printf '\033[34m')
  #MAGENTA=$(printf '\033[35m')
  BOLD=$(printf '\033[1m')
  RESET=$(printf '\033[m')
}

warn() {
  echo "${YELLOW}warning: $* ${RESET}"
}

error() {
  echo "${RED}error: $* ${RESET}"
}

echoStageName() {
  echo "${BOLD}----> $* ${BOLD}"
}

main() {
  useColor

  # Check if /tmp/.gottylock is there, otherwise touch to to ensure
  # we cannot start another instace.
  if [[ ! -f "/tmp/.gottylock" ]] && [[ $1 == "start" ]]; then
    echoStageName Touching /tmp/.gottylock to ensure only one instance can be called
    touch "/tmp/.gottylock"

    echoStageName Starting web terminal
    exec gotty --port 3030 --title-format vault-operator-controlplane --permit-write --reconnect /bin/bash -l
  elif [[ -f "/tmp/.gottylock" ]] && [[ $1 == "start" ]]; then
    error "GoTTY lockfile found, not starting a new one."
    exit 1
  elif [[ $1 == "" ]]; then
    exec bash -l
  else
    exec "$@"
  fi
}

main "$@"