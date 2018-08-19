ARG ELK_VERSION

# https://github.com/elastic/kibana-docker
FROM docker.elastic.co/beats/filebeat:6.3.2
COPY ./templates/es-nginx-pipline.json /usr/share/filebeat/es-nginx-pipline.json
COPY ./templates/es-nginx-template.json /usr/share/filebeat/es-nginx-template.json
COPY ./config/filebeat.yml /usr/share/filebeat/filebeat.yml
COPY ./nginx-logs/nginx_json_logs.txt /var/log/nginx/nginx_json_logs.txt
COPY ./healthcheck.sh /healthcheck/healthcheck.sh
##### Copy apache2.yml file to /usr/share/filebeat/modules.d/apache2.yml
COPY ./templates/apache2.yml /usr/share/filebeat/modules.d/apache2.yml
##### Copy apache datasets to var/log 
COPY ./datasets/access_log /var/log/apache2/access.log
USER root
RUN chown root:filebeat /healthcheck/healthcheck.sh && chmod +x /healthcheck/healthcheck.sh
RUN chown root:filebeat /usr/share/filebeat/es-nginx-pipline.json
RUN chown root:filebeat /usr/share/filebeat/es-nginx-template.json
RUN chown root:filebeat /usr/share/filebeat/filebeat.yml
RUN chown root:filebeat /var/log/nginx/nginx_json_logs.txt && chown root:filebeat /var/log/apache2/access.log
USER filebeat
ENTRYPOINT [ "/healthcheck/healthcheck.sh" ]

CMD [ "filebeat" ] 
# Add your kibana plugins setup here
# Example: RUN kibana-plugin install <name|url>
