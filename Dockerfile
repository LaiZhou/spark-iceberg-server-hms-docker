FROM openjdk:8u242-jre

WORKDIR /opt

ENV SPARK_VERSION=3.3.0
ENV ICEBERG_VERSION=0.14.0
ENV ICEBERG_SPARK_JAR_NAME=iceberg-spark-runtime-3.3_2.12

RUN curl -L https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz | tar zxf -
ENV SPARK_HOME=/opt/spark-${SPARK_VERSION}-bin-hadoop3 

RUN wget -O  ${ICEBERG_SPARK_JAR_NAME}-${ICEBERG_VERSION}.jar  https://search.maven.org/remotecontent?filepath=org/apache/iceberg/${ICEBERG_SPARK_JAR_NAME}/${ICEBERG_VERSION}/${ICEBERG_SPARK_JAR_NAME}-${ICEBERG_VERSION}.jar

RUN mv /opt/${ICEBERG_SPARK_JAR_NAME}-${ICEBERG_VERSION}.jar   ${SPARK_HOME}/jars/${ICEBERG_SPARK_JAR_NAME}-${ICEBERG_VERSION}.jar  
COPY start-spark-iceberg-server.sh /start-spark-iceberg-server.sh
COPY wait-for-it.sh /wait-for-it.sh

USER root
RUN apt-get update && apt-get install -y procps && \
    groupadd -r spark_user --gid=1000 && \
    useradd -r -g spark_user --uid=1000 -d ${SPARK_HOME} spark_user && \
    chown spark_user:spark_user -R ${SPARK_HOME} && \
    chown spark_user:spark_user /start-spark-iceberg-server.sh && chmod +x /start-spark-iceberg-server.sh && \
    chown spark_user:spark_user /wait-for-it.sh && chmod +x /wait-for-it.sh

    
USER spark_user    
EXPOSE 10000
