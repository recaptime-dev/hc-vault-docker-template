FROM vault:latest

# just in case the base image doesn't have Bash
RUN apk install --no-cache bash

# Copy config there
COPY prod.hcl staging.hcl /vault/config/

# Then copy our entrypoint script
COPY bootstrapper-handler.sh /vault/bootstrap-handler.sh
ENTRYPOINT ["/vault/bootstapper-handler.sh"]

# and hit the road
RUN ["server:start"]
