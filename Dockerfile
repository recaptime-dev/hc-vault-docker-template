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

WORKDIR /vault

# just in case the base image doesn't have Bash
RUN apk add bash coreutils gettext

# Copy config there
COPY config_template.hcl /vault/template.hcl
COPY sql /vault/sql-src

# Then copy our entrypoint script
COPY bootstrapper-handler /vault/bootstrap-handler.sh
ENTRYPOINT ["/vault/bootstapper-handler.sh"]

# Then install Node.js for our database migrations to run
RUN apk add nodejs

# and hit the road
CMD ["server"]
