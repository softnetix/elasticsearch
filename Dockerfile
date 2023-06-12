FROM ubuntu:22.04

USER root

RUN apt-get update && apt-get -y install gnupg wget apt-transport-https && rm -rf /var/lib/apt/lists/*

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-8.x.list

RUN apt-get update && apt-get -y install elasticsearch && rm -rf /var/lib/apt/lists/*

RUN chown -R elasticsearch:elasticsearch /usr/share/elasticsearch

# the user was created when installed the elasticsearch
# Must not be root:
# org.elasticsearch.bootstrap.StartupException: java.lang.RuntimeException: can not run elasticsearch as root
USER elasticsearch

WORKDIR /usr/share/elasticsearch

COPY --chown=elasticsearch:elasticsearch elasticsearch.yml /usr/share/elasticsearch/config/

RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-phonetic

ENTRYPOINT [ "./bin/elasticsearch" ]
