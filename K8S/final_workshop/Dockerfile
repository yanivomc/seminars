FROM yanivomc/alpine-oraclejdk8:slim
WORKDIR /app
# make sure that the spring-music.jar file is located at the same place as your Dockerfile
COPY ./spring-music.jar /app/spring-music.jar
EXPOSE 8080
CMD java -jar -Dspring.profiles.active=none /app/spring-music.jar