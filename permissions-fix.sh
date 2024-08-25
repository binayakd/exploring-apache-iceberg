#/bin/bash

# runs this script if you are having permissions issues.
# setup directories for local data
mkdir -p ./local-data/downloaded-data
mkdir -p ./local-data/minio-data
mkdir -p ./local-data/postgres-data

# change permission of workspace files 
# to be accesable in the container
chmod 777 -R ./workspace