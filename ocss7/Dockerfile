# Copyright (c) 2020 Computaris and/or its affiliates. All rights reserved.
#
# Licensed under the Apache License v 2.0 as shown at https://www.apache.org/licenses/LICENSE-2.0.
#
# This is the Dockerfile for Metaswitch OCSS7 protocol stack 4.0.0
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
#
# (1) ocss7-package-4.0.0.x.zip
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Put ocss7-package zip archive in the same directory as this Dockerfile
# Run:
#      $ docker build -t cts/ocss7:4.0.0.2 .
#
# This command is already scripted in build.sh so you can alternatively run
#       $ bash build.sh
#

FROM centos:7 as builder

ARG OCSS7_PKG=ocss7-package-4.0.0.2.zip
ARG OCSS7_SHA256=0c2397850bbc4d139b2f1e0c37f4939a9a82d1fd643fafa50dd8c1ad8ce22e64

RUN set -eux; \
    yum install -y unzip && \
    yum clean all && \
    rm -rf /var/cache/yum

COPY $OCSS7_PKG /tmp/ocss7.zip

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -eux && \
    echo "$OCSS7_SHA256 /tmp/ocss7.zip" | sha256sum -c -; \
    unzip /tmp/ocss7.zip -d /tmp/ocss7

FROM centos:7

ARG HOST_USER_UID=1000
ARG HOST_USER_GID=1000
ENV PATH=${PATH}:/opt/ocss7/bin:/opt/ocss7/cli

WORKDIR /tmp

RUN set -eux && \
    yum install -y lksctp-tools which java-11-openjdk-devel && \
    echo 'Creating sgc user and group from host' && \
    groupadd -o -g $HOST_USER_GID sgc && \
    useradd -o -lm -u $HOST_USER_UID -g $HOST_USER_GID sgc

# to allow jvisualvm add following lines:
# RUN yum install -y libXrender libXtst

USER sgc

COPY --chown=sgc:sgc --from=builder /tmp/ocss7/ocss7* /opt/ocss7

WORKDIR /home/sgc

VOLUME /opt/ocss7/config
VOLUME /opt/ocss7/logs

ENV JAVA_HOME=/usr/lib/jvm/java

CMD ["sh", "-c", "/opt/ocss7/bin/sgc foreground"]
