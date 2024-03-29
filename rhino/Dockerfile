# Copyright (c) 2020 Computaris and/or its affiliates. All rights reserved.
#
# Licensed under the Apache License v 2.0 as shown at https://www.apache.org/licenses/LICENSE-2.0.
#
# This is the Dockerfile for Metaswitch Rhino TAS 3.0
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
#
# (1) rhino-install-3.0.x.x.tar
#     Download from https://docs.rhino.metaswitch.com/ocdoc/books/devportal-downloads/1.0/downloads-index/rhino.html
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put all downloaded files in the same directory as this Dockerfile
# Run:
#      $ docker build -t cts/mswrhino:3.0.0.19 .
#
# This command is already scripted in build.sh so you can alternatively run
#       $ bash build.sh
#

ARG BASE_IMAGE=centos:7
FROM $BASE_IMAGE as builder

MAINTAINER Piotr Grabowski <github.com/pgrabowski>

ARG RHINO_PKG=rhino-install-3.0.0.19.tar
ARG RHINO_SHA256=e4b107632473439dc4d0bea4009e33e540f948391127af58a960dc3f4bffaff3

# Since the files is compressed as tar and zip first yum install unzip and tar
RUN set -eux; \
    yum install -y \
        unzip \
        tar \
	which \
        java-11-openjdk-devel \
    ; \
    yum clean all ; \
    rm -rf /var/cache/yum


ENV RHINO_BASE=/opt/opencloud/rhino

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
ARG BASE_IMAGE=centos:7
FROM $BASE_IMAGE

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
    yum -y install zip which lksctp-tools java-11-openjdk-devel; \
    yum clean all

# Copy the uncompressed Java Runtime from the builder image
COPY --chown=rhino:rhino --from=builder /opt/opencloud /opt/opencloud

USER rhino:rhino

ENTRYPOINT [ "/opt/opencloud/rhino/bin/start-rhino.sh" ]
