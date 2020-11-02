#!/bin/sh

# Generate Rhino keystores that later can be injected into container

mkdir -p certs

keytool -genkey -alias jmxr-ssl-server -keyalg RSA -storetype pkcs12 \
  -dname 'cn=Rhino JMXRAdaptor Server, ou=Rhino Slee Security, o=Open Cloud Limited,c=NZ' \
  -validity 365 -keystore certs/rhino-server.keystore \
  -storepass $1 -keypass $1

keytool -genkey -alias jmxr-ssl-client -keyalg RSA -storetype pkcs12 \
  -dname 'cn=Rhino JMXRAdaptor Client, ou=Rhino Slee Security, o=Open Cloud Limited,c=NZ' \
  -validity 365 -keystore certs/rhino-client.keystore \
  -storepass $2 -keypass $2

keytool -export -alias jmxr-ssl-client \
    -keystore certs/rhino-client.keystore \
    -storepass $2 -keypass $2 \
    |\
keytool -import -alias jmxr-ssl-client \
    -keystore certs/rhino-server.keystore \
    -storepass $1 -keypass $1 -noprompt

${JAVA_HOME}/bin/keytool -export -alias jmxr-ssl-server \
    -keystore certs/rhino-server.keystore \
    -storepass $1 -keypass $1 \
    |\
${JAVA_HOME}/bin/keytool -import -alias jmxr-ssl-server \
    -keystore certs/rhino-client.keystore \
    -storepass $2 -keypass $2 -noprompt


keytool -exportcert -alias jmxr-ssl-server \
    -keystore certs/rhino-client.keystore \
    -storepass $2 -keypass $2 \
    -file certs/rhino-trust.cert -noprompt
