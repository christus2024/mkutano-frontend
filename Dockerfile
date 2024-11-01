FROM eclipse-temurin:17-jre

LABEL Author="it4innov.fr"

ARG VERSION

WORKDIR /app

RUN apt-get update -y && \
    apt-get install -y bash && \
    useradd --home /home/it4innov/ --create-home --shell /bin/bash it4innov && \
    chmod -R 755 /home/it4innov

USER it4innov

COPY --chown=it4innov:it4innov ./target/code-frontend-${VERSION}-runner.jar code-frontend.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/code-frontend.jar"]