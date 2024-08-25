# Exploring Apache Iceberg

With the recent [buzz around Apache Iceberg Tables](https://thenewstack.io/snowflake-databricks-and-the-fight-for-apache-iceberg-tables/), I am cashing in on the this buzz to explore what Apache Iceberg is all about, exploring the iceberg that is Apache Iceberg, if you will.

The way I see it, Iceberg provides an better alternative to Hive Metastore, which itself has been used to bring relational database table like interface on top of "unstructured" data, in distributed storage. It is better because, not only does it have some additional features (Schema evolution, hidden partitioning, snapshots, improved performance, etc.), but also the fact that it is an open standard, with multiple implementations, allowing us to move away from Hadoop/Hive dependencies. 

## The Engines of Exploration

Iceberg is supported using multiple querying engine 

## quickstart
https://iceberg.apache.org/spark-quickstart/#docker-compose
https://github.com/tabular-io/docker-spark-iceberg


## Test data
https://avilpage.com/2022/11/common-crawl-laptop-extract-subset.html
aws s3 ls s3://commoncrawl/cc-index/table/cc-main/warc/crawl=CC-MAIN-2024-26/subset=warc/part-00000-44971353-df4b-48d7-8025-975e8feb989b.c000.gz.parquet


## create minio bucket

```bash
mc config host add minio http://minio:9000 admin password
mc mb minio/hive-warehouse
mc policy set public minio/hive-warehouse
```

## creating metadata for table using pylceberg?

https://www.definite.app/blog/iceberg-query-engine


## write test

spark on hive-metastore
- 54.937945705023594 s

magic commiter for spark
https://spot.io/blog/improve-apache-spark-performance-with-the-s3-magic-committer/


s3a upload tuning
https://blog.min.io/migrating-from-hadoop-without-rip-and-replace/

## catalogs
https://medium.com/data-engineering-with-dremio/a-deep-dive-into-the-concept-and-world-of-apache-iceberg-catalogs-0697e8d18a8b

create multiple dbs:
https://github.com/mrts/docker-postgresql-multiple-databases