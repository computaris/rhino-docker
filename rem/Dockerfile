FROM centos:7 as builder

ARG REM_PKG=rhino-element-manager-3.0.0.1.zip
ARG REM_SHA256=c4d654425d9bdf1b18fa7798f58a37c054d6c9d7463fc6e48a2f22baa63e311e

RUN set -eux; \
    yum install -y \
        unzip \
	    which \
        java-11-openjdk-devel \
    ; \
    yum clean all ; \
    rm -rf /var/cache/yum

ENV REM_HOME=/opt/opencloud/rem

COPY $REM_PKG /tmp/rem.zip

RUN set -eux; \
    echo "$REM_SHA256 */tmp/rem.zip" | sha256sum -c -; \
    mkdir /tmp/rem-install; \
    unzip /tmp/rem.zip -d /tmp/ ; \
    rm /tmp/rem.zip ; \
    mkdir -p ${REM_HOME}; \
    cp -r /tmp/rhino-element-manager-*/* ${REM_HOME}; \
    rm -r /tmp/*

FROM centos:7

ENV REM_HOME=/opt/opencloud/rem
ENV REM_USER=rem
ENV JAVA_HOME=/usr

RUN useradd -M -d /opt/opencloud -u 1000 -U rem ; \
    yum -y install zip which lksctp-tools java-11-openjdk-devel; \
    yum clean all

COPY --chown=rem:rem --from=builder /opt/opencloud /opt/opencloud

USER rem:rem

ENTRYPOINT [ "sh", "/opt/opencloud/rem/rem.sh" ]
