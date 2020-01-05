# Installing KSQL SERVER AND CLI 
~~~
docker run -d \
  -p 0.0.0.0:8088:8088 \
  -e KSQL_BOOTSTRAP_SERVERS=kakfa1:9094 \
  -e KSQL_LISTENERS=http://0.0.0.0:8088/ \
  -e KSQL_KSQL_SERVICE_ID=ksql_service_3_ \
  -e KSQL_PRODUCER_INTERCEPTOR_CLASSES=io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor \
  -e KSQL_CONSUMER_INTERCEPTOR_CLASSES=io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor \
  confluentinc/cp-ksql-server:5.3.2
  ~~~

  Make sure you already started the docker compose and configure kafka1 , kafka2 and zookeeper (/etc/hosts)
  to point to the IP where your cluster is. 