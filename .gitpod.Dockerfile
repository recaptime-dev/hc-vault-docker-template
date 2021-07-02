FROM gitpod/workspace-full

WORKDIR /home/gitpod

# Hard-code the VAULT_ADDR at build time
ENV VAULT_ADDR=https://localhost:3000

# Vault Open-Source (https://learn.hashicorp.com/tutorials/vault/getting-started-install)
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - \
    && sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && sudo apt-get update && sudo apt-get install vault --yes

# Keybase
RUN curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb \
    && sudo apt install ./keybase_amd64.deb --yes

# Ensure Keybase GUI and KBFS aren't activated when summoning run_keybase
ENV KEYBASE_NO_GUI=1 KEYBASE_NO_KBFS=1

# Cleanup
RUN rm -v /home/gitpod/keybase_amd64.deb