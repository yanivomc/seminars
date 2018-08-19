ARG ELK_VERSION

# https://github.com/elastic/logstash-docker
FROM docker.elastic.co/logstash/logstash:${ELK_VERSION}
COPY ./datasets/access_log /var/log/access_log
# Add your logstash plugins setup here
# Example: RUN logstash-plugin install logstash-filter-json
