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
    ls -l /tmp ; \
    cp -r /tmp/bin $RHINO_BASE; \
    sed -i -e 's/node-101/node/g' ${RHINO_BASE}/node/config/config_variables; \
    rm -r $RHINO_BASE/node/init.d /tmp/*

## Get a fresh version for the final image

FROM cts/oraclejdk:8

ENV RHINO_VERSION=2.7.0.3 \
    MANAGEMENT_DATABASE_NAME=rhino \
    MANAGEMENT_DATABASE_HOST=localhost \
    MANAGEMENT_DATABASE_PORT=5432 \
    MANAGEMENT_DATABASE_USER=rhino \
    MANAGEMENT_DATABASE_PASSWORD=password \
    SESSION_OWNERSHIP_FACILITY_ENABLED=False \
    REPLICATED_STORAGE_RESOURCE=DomainedMemoryDatabase \
    CASSANDRA_CONTACT_POINTS=localhost \
    CASSANDRA_PORT=9042 \
    REMOTE_TIMER_SERVER_BASE_PORT=0 \
    REMOTE_TIMER_SERVER_PORT_RANGE=0 \
    RMI_MBEAN_REGISTRY_PORT=1199 \
    JMX_SERVICE_PORT=1202 \
    RHINO_SSL_PORT=1203 \
    SNAPSHOT_BASEPORT=22000 \
    HEAP_SIZE=3072m \
    MAX_NEW_SIZE=512m \
    NEW_SIZE=512m \
    RHINO_CLIENT_STORE_PASS=changeit \
    RHINO_SERVER_STORE_PASS=changeit \
    RHINO_PASSWORD=password \
    RHINO_USERNAME=admin \
    LOCALIPS="*" \
    RHINO_WATCHDOG_STUCK_INTERVAL=45000 \
    RHINO_WATCHDOG_THREADS_THRESHOLD=50 \
    SAVANNA_COMMS_MODE=MULTICAST \
    SAVANNA_SCAST_BASE_PORT=12000 \
    SAVANNA_SCAST_PORT_OFFSET=101 \
    SAVANNA_CLUSTER_ID=100 \
    SAVANNA_CLUSTER_ADDR=224.0.50.1 \
    SAVANNA_MCAST_START=224.0.50.1 \
    SAVANNA_MCAST_END=224.0.50.8 \
    NODE_ID=101 \
    RHINO_BASE=/opt/opencloud/rhino \
    RHINO_HOME=/opt/opencloud/rhino/node \
    RHINO_WORK_DIR=/opt/opencloud/rhino/node/work \
    RHINO_WATCHDOG_DUMPTHREADS=/opt/opencloud/rhino/node/dumpthreads.sh \
    # User name for the user which Rhino will run as.
    RHINO_USER=rhino \
    # Rhino boot arguments.
    # Add '-q' to start the node as a quorum node.
    # Do NOT add '-p' to these arguments.
    RHINO_START_ARGUMENTS="-k -l -s" \
    # consolo.log rotation
    MAX_LOGS="-b 10" \
    MAX_SIZE="-m 100MB"

RUN useradd -M -d /opt/opencloud -u 1001 -U rhino ; \
    yum -y install zip ; \
    yum clean all

# Copy the uncompressed Java Runtime from the builder image
COPY --chown=rhino:rhino --from=builder /opt/opencloud /opt/opencloud

USER rhino:rhino

ENTRYPOINT [ "/opt/opencloud/rhino/bin/start-rhino.sh" ]
