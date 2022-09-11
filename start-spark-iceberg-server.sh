#!/bin/sh

export SPARK_NO_DAEMONIZE=true

${SPARK_HOME}/sbin/start-thriftserver.sh \
  --master local[*] \
  --hiveconf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
  --hiveconf spark.sql.catalog.spark_catalog=org.apache.iceberg.spark.SparkSessionCatalog \
  --hiveconf spark.sql.catalog.spark_catalog.type=hive \
  --hiveconf spark.sql.catalog.spark_catalog.uri=thrift://hive-standalone-metastore:9083 \
  --hiveconf hive.metastore.uris=thrift://hive-standalone-metastore:9083 \
  --hiveconf spark.sql.warehouse.dir=/tmp/hive/warehouse 

