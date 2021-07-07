#!/bin/bash
cat << EOF
Welcome to your Vault terminal, where you can run Vault and also GPG commands here.

Available aliases and functions for ease of time:
  * list - List secrets within specific path
  * read - Read key-vaule secrets, get OTP codes and other types of secrets
  * write - Create and update secrets and configuration with specific path
  * delete - Mark an secret as deleted
  * operator/admin - Run server operations/adminstration commands including sealing and unsealing

We cannot cover all comands as Bash shell functions, but 'vault --help' and the Vault docs at
https://www.vaultproject.io/docs should help you use the CLI.

Happy encrypting secrets!
EOF

# add Alias definitions.
if [ -f /home/vault/.bash_aliases ]; then
    . /home/vault/.bash_aliases
fi

# Show "vault> " as the command prompt instead of the usual vault-gotty@random-docker-intermidate-container-id-here
export PS1="\[\e[32m\]vault\[\e[m\]> "

# Set VAULT_ADDR to our Compose instance (we set up bridge networking stuff btw)
export VAULT_ADDR=htttp://vault:3000