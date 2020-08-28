#!/bin/bash

###start registerd
/bin/registerd &

###make prometheus.yml
cat << EOF >> /config/prometheus.yml
# my global config
global:
  scrape_interval:     15s # By default, scrape targets every 15 seconds.
  evaluation_interval: 15s # By default, scrape targets every 15 seconds.
  external_labels:
      monitor: 'prometheus-swarm'

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    dns_sd_configs:
    - names:
      - '$PROMETHEUS_HOST'
      type: 'A'
      port: $PROMETHEUS_PORT

  - job_name: 'cadvisor'
    scrape_interval: 5s
    dns_sd_configs:
    - names:
      - '$CADVISOR_HOST'
      type: 'A'
      port: $CADVISOR_PROMETHEUS_PORT

  - job_name: 'node-exporter'
    scrape_interval: 5s

    dns_sd_configs:
    - names:
      - '$NODE_EXPORTER_HOST'
      type: 'A'
      port: $NODE_EXPORTER_PORT
EOF

####start prometheus
/bin/prometheus