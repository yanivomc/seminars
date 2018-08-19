# Elastic stack (ELK) on Docker - JohnBryce 
## Maintaner - Yaniv cohen - Yanivomc@gmail.com 

Run the latest version of the [Elastic stack](https://www.elastic.co/elk-stack) with Docker and Docker Compose.

It will give you the ability to analyze any data set by using the searching/aggregation capabilities of Elasticsearch and the visualization power of Kibana.

The environment also has NGINX Configured on port 8080 to send traffic to Kibana for security and LB if needed.


Everything is based on the official Docker images from Elastic:

* [elasticsearch](https://github.com/elastic/elasticsearch-docker)
* [logstash](https://github.com/elastic/logstash-docker)
* [kibana](https://github.com/elastic/kibana-docker)


Data:
## NGINX Data is already prepoulated automaticly on stack buildup  using filebeat


Starting the stack:
### docker-compose up -d

Scaling the stack (elastic)
### docker-compose scale elasticsearch2=num

Access kibana:
localhost:8080 using Nginx 
localhost:5601 Directly to kibana 

