FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

# user and group IDs to run image as
ARG RUN_AS_USER=1000
ARG RUN_AS_GROUP=1000

# Versions
ARG METASTORE_VERSION=4.0.0
ARG HADOOP_VERSION=3.4.0
ARG POSTGRES_DRIVER_VERSION=42.7.3

# update and install java and dependencies
RUN microdnf update -y \
  && microdnf --nodocs install shadow-utils java-21-openjdk-headless tar gzip gettext -y \
  && microdnf clean all -y

# set up non root user
RUN groupadd -g ${RUN_AS_GROUP} metastore && \
  useradd -u ${RUN_AS_USER} -g metastore metastore

# setup opt dir for metastore user
RUN chown -R metastore:metastore /opt

USER metastore

# Set ENV vars
ENV JAVA_HOME=/usr/lib/jvm/jre-21
ENV HADOOP_HOME="/opt/hadoop"
ENV METASTORE_HOME="/opt/hive-metastore"
ENV HIVE_HOME="/opt/hive-metastore"
ENV HADOOP_CLASSPATH="${HADOOP_HOME}/share/hadoop/tools/lib/*:${HADOOP_HOME}/share/hadoop/common/lib/*"
ENV S3A_CREDENTIAL_PROVIDER="software.amazon.awssdk.auth.credentials.EnvironmentVariableCredentialsProvider"

# Download Hadoop
RUN curl https://dlcdn.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz \
    | tar xz -C /opt/  \
    && ln -s ${HADOOP_HOME}-$HADOOP_VERSION ${HADOOP_HOME} \
    && rm -r ${HADOOP_HOME}/share/doc

# Download the standalone hive metastore 
RUN curl https://repo1.maven.org/maven2/org/apache/hive/hive-standalone-metastore-server/${METASTORE_VERSION}/hive-standalone-metastore-server-${METASTORE_VERSION}-bin.tar.gz \
    | tar xz -C /opt/ \
    && ln -s /opt/apache-hive-metastore-${METASTORE_VERSION}-bin ${METASTORE_HOME} \
    # fix for schemaTool script
    && sed -i -e 's/org.apache.hadoop.hive.metastore.tools.MetastoreSchemaTool/org.apache.hadoop.hive.metastore.tools.schematool.MetastoreSchemaTool/g' ${METASTORE_HOME}/bin/ext/schemaTool.sh

# download postgres jdbc driver jar
RUN curl https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRES_DRIVER_VERSION}/postgresql-${POSTGRES_DRIVER_VERSION}.jar \
    -o ${METASTORE_HOME}/lib/postgresql-${POSTGRES_DRIVER_VERSION}.jar

WORKDIR ${METASTORE_HOME}

# copy configs
COPY --chown=metastore:metastore metastore-site.xml /opt/hive-metastore/conf/metastore-site.xml.tpl
COPY --chown=metastore:metastore metastore-log4j2.properties /opt/hive-metastore/conf/metastore-log4j2.properties

# entrypoint script
COPY --chown=metastore:metastore --chmod=775 entrypoint.sh bin/entrypoint.sh

CMD ["bash", "-c", "bin/entrypoint.sh"]

