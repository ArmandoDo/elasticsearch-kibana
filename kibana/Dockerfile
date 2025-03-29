FROM docker.elastic.co/kibana/kibana:8.6.2

## Set up Kibana
USER kibana
COPY --chown=1000:0 config/kibana.yml /usr/share/kibana/config/kibana.yml

