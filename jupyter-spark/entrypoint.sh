#/bin/bash

# export SPARK_DIST_CLASSPATH="$($HADOOP_HOME/bin/hadoop classpath)"

echo "changing dir"
cd workspace

echo "starting jupyter lab"
jupyter-lab \
  --ip='*' \
  --NotebookApp.token='' \
  --NotebookApp.password='' \
  --port=8888 \
  --no-browser