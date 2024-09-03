#/bin/bash

# runs this script if you are having permissions issues.

# change permission of workspace files and local-data folder 
# to be accesable in the container
chmod 777 -R ./workspace
chmod 777 -R ./local-data