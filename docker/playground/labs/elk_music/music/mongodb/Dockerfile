# MongoDB image with host-based data volume

FROM mongo:latest

ENV REFRESHED_AT 2018-03-03

VOLUME ["/data/db"]
WORKDIR /data
CMD ["mongod", "--smallfiles"]
