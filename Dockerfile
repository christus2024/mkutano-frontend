# FROM openjdk:17-jdk-alpine
# WORKDIR /app
# RUN addgroup -S frontgroup && adduser -S frontuser -G frontgroup
# RUN chown -R frontuser:frontgroup /app
# COPY target/code-frontend-1.0.0-SNAPSHOT-runner.jar /app/quarkus-run.jar
# USER frontusercd 
# EXPOSE 8080
# ENTRYPOINT [ "java","-jar","/app/quarkus-run.jar" ]

FROM eclipse-temurin:17-jre

LABEL Author="it4innov.fr"

ARG VERSION

WORKDIR /app

RUN apt-get update -y && \
    apt-get install -y bash && \
    useradd --home /home/it4innov/ --create-home --shell /bin/bash it4innov && \
    chmod -R 755 /home/it4innov

USER it4innov

COPY --chown=it4innov:it4innov ./target/code-frontend-${VERSION}-SNAPSHOT-runner.jar /app/code-frontend.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/code-frontend.jar"]