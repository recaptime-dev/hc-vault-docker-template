##### LICENSE #####
# MIT License
#
# Copyright (c) 2021-present Andrei Jiroh Halili, The Pins Team and its contributors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
##### LICENSE #####

# syntax=docker/dockerfile:1
FROM vault:1.7.3

# Temporarily switch to root to install deps and chown to vault
WORKDIR /vault

# Copy config and SQL stuff
COPY --chown=vault:vault config_template.hcl /vault/template.hcl
COPY --chown=vault:vault sql /vault/migrations

# just in case the base image doesn't have Bash, we also install Node.js and psql
# for our database migrations to run
RUN apk add bash coreutils gettext nodejs postgresql-client libcap \
    # Aded to possibly fix permission issues
    && chmod -R 777 /vault/config \
    # Enable IPC_LOCK stuff, we cannot handle SETFCAP stuff here.
    && /usr/sbin/setcap cap_ipc_lock=+ep /bin/vault

# One last thing: copy scripts/wait-for-it from thedevs-network/kutt
#COPY scripts/wait-for-it /bin/wait-for-it

# Finally copy our entrypoint script
COPY bootstrapper-handler /vault/bootstrap-handler

# Ensure our bootstrap script is executable btw
RUN chmod +x /vault/bootstrap-handler \
    # Create an staging folder for our generated Vault config through
    # envsubst command. Our bootstrap script in this image will handle the
    # rest on it.
    && mkdir /vault/staging && chmod -Rv 777 /vault/staging
    # Then delete the main entrypoint script from our base image because we want to
    # custmize it.
    #&& rm /usr/local/bin/docker-entrypoint.sh

#COPY scripts/main-entrypoint-custom.sh /usr/local/bin/docker-entrypoint.sh

# Ensure it's executable btw
#RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose in port 3000
EXPOSE 3000

# SETFCAP-related error is still an issue when running out chmod stuff as vault user.
# Issue: https://github.com/hashicorp/docker-vault/issues/137
USER vault
# ..and hit the road! When our bootstrap script calls the customized /usr/local/bin/docker-entrypoint.sh,
# we'll switch to the vault user through su-exec
ENTRYPOINT ["/vault/bootstrap-handler"]
# by default, we'll start our Vault server through some environment variables magic
# if $VAULT_SERVER_MODE is set to 'production', otherwise we'll start in dev mode instead.
CMD ["server"]
