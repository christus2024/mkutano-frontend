FROM openjdk:17-ea-10-slim

MAINTAINER it4innov.fr

ARG VERSION=1

WORKDIR /app

RUN apt-get update -y && \
    apt-get install -y bash && \
    groupadd it4innov && \
    useradd --home /home/it4innov/ --create-home -g it4innov --shell /bin/bash it4innov && \
    chmod -R 755 /home/it4innov

USER it4innov

COPY ./target/code-frontend-${VERSION}-runner.jar code-frontend.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/code-frontend.jar"]