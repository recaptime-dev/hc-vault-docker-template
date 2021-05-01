FROM vault:latest

# just in case the base image doesn't have Bash
RUN apk install --no-cache bash

# Copy config there
COPY prod.hcl staging.hcl /vault/config/

# Then copy our entrypoint script
COPY bootstrapper-handler.sh /vault/bootstrap-handler.sh
ENTRYPOINT ["/vault/bootstapper-handler.sh"]

# Server mode handler for our bootstrapper script
ARG VAULT_SERVER_MODE
ENV VAULT_SERVER_MODE=${VAULT_SERVER_MODE:production}

# and hit the road
RUN ["server"]
