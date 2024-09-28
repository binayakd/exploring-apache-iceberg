# Exploring Apache Iceberg

This repo the is the accompaniment to the [blog post](https://binayakd.tech/posts/2024-08-30-exploring-iceberg/) where we explore the basics of setting up Hive, JDBC and REST Iceberg catalogs, and test writing and reading to Iceberg using Spark and Trino.

## Prerequisites
You would need these to get things working:
1. Git
2. Docker/Podman Compose

## Setup

Clone this repo down, including submodules:

```bash
git clone --recurse-submodules git@github.com:binayakd/exploring-apache-iceberg.git
```

Inside the cloned folder, trigger the image builds:

```
docker compose build
```

This will build the following Images:

1. `jupyter-spark`: this is the Jupyter Lab based development environment with all the client dependencies installed
2. `hive-metastore`: this will be used as the Iceberg Hive Catalog
3. `iceberg-rest-catalog`: this is a python Iceberg REST catalog by [Kevin Liu](https://github.com/kevinjqliu/iceberg-rest-catalog), which I have forked, and added to this repo as a submodule

Now start all the services:

```
docker compose up
```

On top of the 3 images mentioned above, this will also start the following images:

1. `minio`: this will be our local S3 alternative, the object storage holding the data
2. `mc`: this is the Minio client image, which is started to automatically create the initial bucker in Minio, then shutdown.
3. `postgres`: this is the Postgres that will be used by the catalogs. An init script in the `postgres-init` folder is used to create the required databases in the postgres instances on first startup.
4. `trino`: this is the Trino server, running as a single node cluster, with all the configs in the `trino-config`folder


## Jupyter Lab Notebooks

Once the setup is done, the Jupyter lab instance can be accessed at: http://localhost:8888. There you will see the list of Jupyter Notebooks, which you can follow along in order:

1. 00-setup.ipynb
2. 01-iceberg-hive.ipynb
3. 02-iceberg-jdbc.ipynb
4. 03-iceberg-rest.ipynb

These are located in the `workspace` folder in this repo.

The data created when running the notebooks will be saved under the `local-data` folder. 

## Permissions issues
If you run into permissions issues in the `workspace` and the `local-data` folders, you can run the `permissions-fix.sh` script to try and fix it.