#!/bin/bash

# Shortcuts to common Vault commands
alias list="vault list"
alias read="vault read"
alias write="vault write"
alias delete="vault delete"
#alias undelete="vault undelete"
#alias destory= "vault destory"

function operator {
    if [[ $1 == "help" ]]; then
      echo "operator - Shell function for different Vault operator commands, including sealing and unsealing ths server."
      echo "operator {init,key-status,migrate,raft,rekey,rotate,seal,step-down,unseal usage}"
      echo
      echo "Available commands:"
      echo "  help             Show this help"
      echo "  generate-root    Generates a new root token"
      echo "  init             Initializes a server"
      echo "  key-status       Provides information about the active encryption key"
      echo "  migrate          Migrates Vault data between storage backends"
      echo "  raft             Interact with Vault's raft storage backend"
      echo "  rekey            Generates new unseal keys"
      echo "  rotate           Rotates the underlying encryption key"
      echo "  seal             Seals the Vault server"
      echo "  step-down        Forces Vault to resign active duty"
      echo "  unseal           Unseals the Vault server"
      echo "  usage            Lists historical client counts"
      echo "Available shortcuts: admin"
      exit 0
    fi

    vault operator "$@"
}

# shortcut for operator function
function admin {
    operator "$@"
}