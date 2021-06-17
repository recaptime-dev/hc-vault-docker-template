FROM vault:latest

WORKDIR /vault

# just in case the base image doesn't have Bash
RUN apk install --no-cache bash coreutils gettext

# Copy config there
COPY config_template.hcl /vault/template.hcl

# Then copy our entrypoint script
COPY bootstrapper-handler.sh /vault/bootstrap-handler.sh
ENTRYPOINT ["/vault/bootstapper-handler.sh"]

# Server mode handler for our bootstrapper script
ARG VAULT_SERVER_MODE=production
ENV VAULT_SERVER_MODE=${VAULT_SERVER_MODE}

# and hit the road
CMD ["server"]
