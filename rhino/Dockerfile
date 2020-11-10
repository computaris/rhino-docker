# Copyright (c) 2020 Computaris and/or its affiliates. All rights reserved.
#
# Licensed under the Apache License v 2.0 as shown at https://www.apache.org/licenses/LICENSE-2.0.
#
# This is the Dockerfile for Metaswitch Rhino TAS 2.7
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
#
# (1) rhino-install-2.7.x.x.tar
#     Download from https://docs.rhino.metaswitch.com/ocdoc/books/devportal-downloads/1.0/downloads-index/rhino.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run:
#      $ docker build -t cts/mswrhino:2.7 .
#
# This command is already scripted in build.sh so you can alternatively run
#       $ bash build.sh
#

FROM cts/oraclejdk:8 as builder

MAINTAINER Piotr Grabowski <github.com/pgrabowski>

# Since the files is compressed as tar and zip first yum install unzip and tar
RUN set -eux; \
    yum install -y \
        unzip \
        tar \
    ; \
    yum clean all ; \
    rm -rf /var/cache/yum


ENV RHINO_PKG=rhino-install-2.7.0.3.tar \
    RHINO_SHA256=7b9acc7d63996d49d77a2b4fcbb3c4ae2d7405779155f641984e08f1b2ddb1cd \
    RHINO_BASE=/opt/opencloud/rhino

COPY $RHINO_PKG /tmp/rhino.tar
COPY data /tmp/

RUN set -eux; \
    echo "$RHINO_SHA256 */tmp/rhino.tar" | sha256sum -c -; \
    mkdir /tmp/rhino-install; \
    tar --extract --file /tmp/rhino.tar --directory /tmp/rhino-install --strip-components 1; \
    rm /tmp/rhino.tar ; \
    /tmp/rhino-install/rhino-install.sh -a -k -r /tmp/install.properties; \
    $RHINO_BASE/create-node.sh 101; \
    mv $RHINO_BASE/node-101/ $RHINO_BASE/node;\
    cp -r /tmp/bin $RHINO_BASE; \
    sed -i -e 's/node-101/node/g' ${RHINO_BASE}/node/config/config_variables; \
    sed -i -e 's/root/rhino/g' ${RHINO_BASE}/node/config/config_variables; \
    rm -r /tmp/*

## Get a fresh version for the final image

FROM cts/oraclejdk:8

# User name for the user which Rhino will run as.
ENV RHINO_USER=rhino \
    # Rhino boot arguments.
    # Add '-q' to start the node as a quorum node.
    # Do NOT add '-p' to these arguments.
    RHINO_START_ARGUMENTS="-k -l -s" \
    # consolo.log rotation
    MAX_LOGS="-b 10" \
    MAX_SIZE="-m 100MB"

RUN useradd -M -d /opt/opencloud -u 1000 -U rhino ; \
    yum -y install zip lksctp-tools ; \
    yum clean all

# Copy the uncompressed Java Runtime from the builder image
COPY --chown=rhino:rhino --from=builder /opt/opencloud /opt/opencloud

USER rhino:rhino

ENTRYPOINT [ "/opt/opencloud/rhino/bin/start-rhino.sh" ]
