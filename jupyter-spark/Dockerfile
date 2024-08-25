FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

# user and group IDs to run image as
ARG RUN_AS_USER=1000

# Spark and Iceberg versions
ARG SPARK_VERSION=3.5.1
ARG SPARK_HADOOP_CLOUD_VERSION=3.5.1
ARG SPARK_MAJOR_VERSION=3.5
ARG ICEBERG_VERSION=1.5.2
ARG HADOOP_VERSION=3.3.4
ARG AWS_SDK_VERSION=1.12.760
ARG POSTGRES_VERSION=42.7.3


# update and install java and python dependencies
RUN microdnf update -y \
  && microdnf --nodocs install shadow-utils java-21-openjdk-headless python39 python3-pip tar gzip procps -y \
  && microdnf clean all -y 

# set up non root user
RUN useradd -u ${RUN_AS_USER} -g root iceberg

# setup opt dir for iceberg user
RUN chown -R iceberg:root /opt

# switch to iceberg user
USER iceberg

WORKDIR /opt

# Spark env variables
ENV HADOOP_HOME="/opt/hadoop"
ENV SPARK_HOME="/opt/spark"
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9.7-src.zip:$PYTHONPATH


# Download spark
RUN mkdir -p ${SPARK_HOME} \
 && curl https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz -o spark-${SPARK_VERSION}-bin-hadoop3.tgz \
 && tar xvzf spark-${SPARK_VERSION}-bin-hadoop3.tgz --directory ${SPARK_HOME} --strip-components 1 \
 && rm -rf spark-${SPARK_VERSION}-bin-hadoop3.tgz


# setup folder for extra jars
RUN mkdir -p /opt/extra-jars

# Download Hadoop AWS bundle
RUN curl -s https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/${HADOOP_VERSION}/hadoop-aws-${HADOOP_VERSION}.jar \
  -Lo /opt/extra-jars/hadoop-aws.jar

# Download AWS SDK bundle
RUN curl -s https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/${AWS_SDK_VERSION}/aws-java-sdk-bundle-${AWS_SDK_VERSION}.jar \
  -Lo /opt/extra-jars/aws-sdk-bundle.jar

# Download Spark Hadoop Cloud
RUN curl -s https://repo1.maven.org/maven2/org/apache/spark/spark-hadoop-cloud_2.12/${SPARK_HADOOP_CLOUD_VERSION}/spark-hadoop-cloud_2.12-${SPARK_HADOOP_CLOUD_VERSION}.jar \
-Lo /opt/extra-jars/spark-hadoop-cloud.jar

# Download iceberg spark runtime jar
RUN curl https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-${SPARK_MAJOR_VERSION}_2.12/${ICEBERG_VERSION}/iceberg-spark-runtime-${SPARK_MAJOR_VERSION}_2.12-${ICEBERG_VERSION}.jar \
  -Lo /opt/extra-jars/iceberg-spark-runtime.jar

# Download Iceberg AWS bundle jar
RUN curl -s https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-aws-bundle/${ICEBERG_VERSION}/iceberg-aws-bundle-${ICEBERG_VERSION}.jar \
  -Lo /opt/extra-jars/iceberg-aws-bundle.jar

# Donload postgres JDBC drivers
RUN curl -s https://jdbc.postgresql.org/download/postgresql-${POSTGRES_VERSION}.jar \
  -Lo /opt/extra-jars/postgresql.jar


# switch to home directory
WORKDIR /home/iceberg

# install Jupyter lab and other python libs
COPY --chown=iceberg:root requirements.txt .
RUN pip install -r requirements.txt


# setup PATH
ENV JAVA_HOME=/usr/lib/jvm/jre-21
ENV PATH=${PATH}:/home/iceberg/.local/bin:/home/iceberg/minio-binaries/:${HADOOP_HOME}/bin

COPY --chown=iceberg:root --chmod=777 entrypoint.sh .

CMD ["bash", "-c", "./entrypoint.sh"]