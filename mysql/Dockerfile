FROM mariadb:10.6.16

RUN touch /var/log/mysql/mariadb-slow.log

RUN chown mysql:mysql /var/log/mysql/mariadb-slow.log

RUN apt update && \
    apt upgrade -y && \
    apt install -y curl

RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.10.2-amd64.deb && \
    dpkg -i filebeat-8.10.2-amd64.deb && \
    rm filebeat-8.10.2-amd64.deb

COPY ./filebeat/filebeat.yml /etc/filebeat/filebeat.yml

RUN chmod go-w /etc/filebeat/filebeat.yml

COPY ./filebeat/modules/logstash.yml /etc/filebeat/modules.d/logstash.yml.disabled

RUN chmod go-w /etc/filebeat/modules.d/logstash.yml.disabled

COPY ./configs/ /etc/mysql/conf.d/

COPY ./start.sh /start.sh

RUN chmod +x /start.sh && \
    chown mysql:mysql /start.sh

ENTRYPOINT [""]

CMD ["/start.sh"]