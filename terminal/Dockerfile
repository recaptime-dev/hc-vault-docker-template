# syntax=docker/dockerfile:1

# Stage 1: Download GoTTY source code and build from source for reproducing builds
FROM golang:1.16 as gotty

RUN go get -v github.com/MadeByThePinsHub/gotty

FROM alpine:3.14 as hashicorp

# Fingerprint of HashiCorp's software release keys for GPG verification. We assume that this might
# not change except when shit happens. Please see https://hashicorp.com/security for details.
ENV VAULT_GPGKEY=C874011F0AB405110D02105534365D9472D7468F
# Release of HashiCorp Vault to pull from HashiCorp Software Packages server
ARG VAULT_VERSION=1.7.3

# Set up certificates, our base tools, and Vault.
# Copied from https://github.com/hashicorp/docer-vault/blob/master/0.X/Dockerfile
RUN set -eux; \
    # Prep
    apk add --no-cache ca-certificates gnupg openssl && \
    # Get public key for signing and download Linux tar file
    apkArch="$(apk --print-arch)"; \
    case "$apkArch" in \
        armhf) ARCH='arm' ;; \
        aarch64) ARCH='arm64' ;; \
        x86_64) ARCH='amd64' ;; \
        x86) ARCH='386' ;; \
        *) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
    esac && \
    found=''; \
    for server in \
        hkp://p80.pool.sks-keyservers.net:80 \
        hkp://keyserver.ubuntu.com:80 \
        hkp://pgp.mit.edu:80 \
    ; do \
        echo "Fetching GPG key $VAULT_GPGKEY from $server"; \
        gpg --batch --keyserver "$server" --recv-keys "$VAULT_GPGKEY" && found=yes && break; \
    done; \
    test -z "$found" && echo >&2 "error: failed to fetch GPG key $VAULT_GPGKEY" && exit 1; \
    mkdir -p /tmp/build && cd /tmp/build && \
    wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${ARCH}.zip && \
    wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS && \
    wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig && \
    # Verify SHA256 sums against our downloaded file, unzip and copy stuff to its destinations
    gpg --batch --verify vault_${VAULT_VERSION}_SHA256SUMS.sig vault_${VAULT_VERSION}_SHA256SUMS && \
    grep vault_${VAULT_VERSION}_linux_${ARCH}.zip vault_${VAULT_VERSION}_SHA256SUMS | sha256sum -c && \
    unzip -d /tmp/build vault_${VAULT_VERSION}_linux_${ARCH}.zip && \
    cp /tmp/build/vault /bin/vault && \
    if [ -f /tmp/build/EULA.txt ]; then mkdir -p /usr/share/doc/vault; mv /tmp/build/EULA.txt /usr/share/doc/vault/EULA.txt; fi && \
    if [ -f /tmp/build/TermsOfEvaluation.txt ]; then mkdir -p /usr/share/doc/vault; mv /tmp/build/TermsOfEvaluation.txt /usr/share/doc/vault/TermsOfEvaluation.txt; fi && \
    # Cleanup 
    gpgconf --kill dirmngr && \
    gpgconf --kill gpg-agent && \
    rm -rf /root/.gnupg

FROM alpine:3.14

# Copy GoTTY from the gotty download process stage
COPY --from=gotty /go/bin/gotty /usr/local/bin/gotty
# Also our wrapper with some magic
COPY gotty-wrapper.sh /bin/gotty

# Make sure it's executable
RUN chmod a+x /usr/local/bin/gotty \
    # TODO: Link to Stack Overflow answer
    && mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# Then copy Vault stuff, including legalese stuff
COPY --from=hashicorp /bin/vault /usr/local/bin/vault
# Commented out because it's enterprise stuff probably.
#COPY --from=hashicorp /tmp/build/EULA.txt /tmp/build/TermsOfEvaluation.txt /usr/share/doc/vault/

# We'll use su-exec to step down into the vault user from the current root user
# to lessen attack surface on the web terminal application. Please, don't add sudo here!
RUN apk add su-exec dumb-init tzdata ca-certificates gnupg openssl

# Btw add bash in there
RUN apk add bash coreutils

# Add our image bootstrap script. This is where we'll kick
# dumb-init and su-exec in.
COPY image-bootstraper.sh /usr/bin/image-bootstraper

# Our bashrc and shell aliases/functions
COPY .bashrc .bash_aliases /root/

# Ensure our wrappers are executable
RUN chmod +x /usr/bin/image-bootstraper && chmod +x /bin/gotty

# Listen at port 3030
EXPOSE 3030

# Since our entrypoint is /usr/local/bin/image-bootstraper, our custom
# script, we need to make dumb-init as the shebang and call /bin/bash.
ENTRYPOINT ["/usr/bin/image-bootstraper"]
CMD ["start"]
