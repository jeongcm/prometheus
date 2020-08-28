FROM registry.datacommand.co.kr/golang:1.14 as builder

WORKDIR /build
COPY common .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o registerd cmd/registerd/registerd.go

ENV CDM_SERVICE_NAME=cdm-cloud-prometheus
ENV CDM_SERIVCE_ADVERTISE_PORT=9090
ENV CDM_SERVICE_VERSION=2.20.1

FROM prom/prometheus

MAINTAINER jeongcm

ENV PROMETHEUS_HOST=prometheus
ENV PROMETHEUS_PORT=9090
ENV NODE_EXPORTER_HOST=node-exporter
ENV NODE_EXPORTER_PORT=9100
ENV CADVISOR_HOST=cadvisor
ENV CADVISOR_PORT=8080

COPY entrypoints.sh /bin/
COPY --from=builder /build/registerd /bin/

CMD ["/bin/sh","/bin/entrypoints.sh"]
