FROM golang:1.14 as Build

RUN go build -o registerd common/cmd/registerd/registerd.go

FROM prom/prometheus

ENV PROMETHEUS_HOST prometheus
ENV PROMETHEUS_PORT 9090
ENV NODE_EXPORTER_HOST node-exporter
ENV NODE_EXPORTER_PORT 9100
ENV CADVISOR_HOST cadvisor
ENV CADVISOR_PORT 8080

CMD ["./registerd"]
ENTRYPOINT ["./prometheus_config.sh"]
