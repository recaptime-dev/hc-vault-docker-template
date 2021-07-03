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
USER root
WORKDIR /vault

# just in case the base image doesn't have Bash, we also install Node.js and psql
# for our database migrations to run
RUN apk add bash coreutils gettext nodejs postgresql-client

# Copy config and SQL stuff
COPY --chown=vault:vault config_template.hcl /vault/template.hcl
COPY --chown=vault:vault sql /vault/sql-src

# One last thing: copy scripts/wait-for-it from thedevs-network/kutt
#COPY scripts/wait-for-it /bin/wait-for-it

# Finally copy our entrypoint script
COPY --chown=vault:vault bootstrapper-handler /vault/bootstrap-handler

# Ensure our bootstrap script is executable btw
RUN chmod +x /vault/bootstrap-handler \
    && touch config/main.hcl && chown -R vault config

USER vault

# Expose in port 3000
EXPOSE 3000

# and hit the road
ENTRYPOINT ["/usr/bin/dumb-init"]
CMD ["/vault/bootstrap-handler", "server"]
