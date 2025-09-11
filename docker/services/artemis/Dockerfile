FROM apache/activemq-artemis:2.42.0-alpine

ENV ARTEMIS_USER=artemis
ENV ARTEMIS_PASSWORD=artemis
ENV ANONYMOUS_LOGIN=false
ENV EXTRA_ARGS="--http-host 0.0.0.0 --relax-jolokia"

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
#RUN chmod +x /usr/local/bin/docker-entrypoint.sh
#COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
