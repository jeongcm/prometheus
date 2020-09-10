FROM registry.datacommand.co.kr/golang:1.14 as builder

WORKDIR /build

COPY common .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o registerd cmd/registerd/registerd.go

FROM registry.datacommand.co.kr/prometheus:2.20.1

ENV PROMETHEUS_HOST=tasks.prometheus
ENV PROMETHEUS_PORT=9090
ENV NODE_EXPORTER_HOST=tasks.node-exporter
ENV NODE_EXPORTER_PORT=9100
ENV CADVISOR_HOST=tasks.cadvisor
ENV CADVISOR_PORT=8080

ENV CDM_SERVICE_NAME=cdm-cloud-prometheus
ENV CDM_SERVICE_ADVERTISE_PORT=9090

COPY entrypoint.sh /bin/
COPY make_config.sh /bin/
COPY --from=builder /build/registerd /bin/

ENTRYPOINT ["/bin/sh","/bin/entrypoint.sh"]