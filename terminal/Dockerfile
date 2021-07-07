# syntax=docker/dockerfile:1

# Stage 1: Download GoTTY source code and build from source for reproducing builds
FROM golang:1.16 as gotty

# Since we're building from the master branch, proceed at your own risk!
RUN mkdir -p /tmp/gotty && GOPATH=/tmp/gotty go get github.com/yudai/gotty

FROM alpine:3.14 as hashicorp

# Fingerprint of HashiCorp's software release keys for GPG verification. We assume that this might
# not change except when shit happens. Please see https://hashicorp.com/security for details.
ENV VAULT_GPGKEY=C874011F0AB405110D02105534365D9472D7468F
# Release of HashiCorp Vault to pull from HashiCorp Software Packages server
ARG VAULT_VERSION=1.7.3

# Set up certificates, our base tools, and Vault.
# Copied
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
    cd /tmp && \
    rm -rf /tmp/build && \
    gpgconf --kill dirmngr && \
    gpgconf --kill gpg-agent && \
    rm -rf /root/.gnupg

FROM alpine:3.14

# Copy our locally build GoTTY
COPY --from=gotty /tmp/gotty/bin/gotty /usr/local/bin/gotty

# Then copy Vault stuff, including legalese stuff
COPY --from=hashicorp /bin/vault /usr/local/bin/vault
COPY --from=hashicorp /usr/share/doc/vault /usr/share/doc/vault

# Create a vault user and group first so the IDs get set the same way,
# even as the rest of this may change over time.
RUN addgroup vault && \
    adduser -D -G vault vault

# We'll use su-exec to step down into the vault user from the current root user
# to lessen attack surface on the web terminal application.
RUN apk add su-exec dumb-init tzdata ca-certificates gnupg openssl

COPY --chown:vault:vault .bashrc .bash_aliases /home/vault/

ENTRYPOINT ['dumb-init']
CMD ['/usr/local/bin/image-bootstraper']
