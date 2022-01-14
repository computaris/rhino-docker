FROM centos:7 as builder

ARG REM_PKG=rhino-element-manager-3.0.0.4.zip
ARG REM_SHA256=f87bc6ead41687a482934cdcf15a66b779d804a054731dbe0eb55a007f56cbd8

RUN yum install -y  unzip &&  yum clean all &&  rm -rf /var/cache/yum

ENV REM_HOME=/opt/opencloud/rem

COPY $REM_PKG /tmp/rem.zip

RUN set -eux; \
    echo "$REM_SHA256 */tmp/rem.zip" | sha256sum -c -; \
    mkdir -p ${REM_HOME}; \
    unzip /tmp/rem.zip -d /tmp/ ; \
    cp -r /tmp/rhino-element-manager-*/* ${REM_HOME}; \
    rm /tmp/rem.zip

FROM centos:7

ENV REM_HOME=/opt/opencloud/rem
ENV REM_USER=rem
ENV JAVA_HOME=/usr

RUN useradd -M -d /opt/opencloud -u 1000 -U rem && yum -y install java-11-openjdk-devel && yum clean all

COPY --chown=rem:rem --from=builder /opt/opencloud /opt/opencloud

USER rem:rem

ENTRYPOINT [ "sh", "/opt/opencloud/rem/rem.sh" ]
