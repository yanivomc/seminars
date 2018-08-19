#!/bin/bash
x=1
while [ $x -le 10 ]
do
echo "Checking if Elastic is up - $x out of 10 times"
curl -X GET "elasticsearch:9200/_cluster/health?wait_for_status=red&timeout=50s"
exit_code=`echo $?`
echo "Exit code $exit_code"
if [ $exit_code -eq 7 ]; then
        echo "Connection timedout - sleeping 5 seconds"
        sleep 5
        echo "retrying"

elif [ $exit_code -eq 0 ]; then
        echo "Elastic is up - creating template and pipline"
        curl -XPUT -H 'Content-Type: application/json' 'elasticsearch:9200/_ingest/pipeline/nginx_json_pipeline' -d @/usr/share/filebeat/es-nginx-pipline.json
      #  curl -XPUT -H 'Content-Type: application/json' 'elasticsearch:9200/_template/nginx_json' -d @/usr/share/filebeat/es-nginx-template.json
        echo "Updates completed - Starting Filebeat"
        echo "Loading all dashboards"
        ./filebeat setup -E output.elasticsearch.hosts=[elasticsearch:9200] -E setup.kibana.host=kibana:5601  --dashboards
        echo "Starting daemon"
        ./filebeat -e 
        exit 0
else
    echo "Faling - Sleeping 5 seconds"
    sleep 5
    echo "retrying"
fi

if [ $x -eq 9 ]; then
        echo "Connection failed - exiting"
        exit 1
fi
x=$(( $x + 1 ))
done