#!/bin/bash

###start registerd
/bin/registerd &

###make prometheus.yml
. /bin/make_config.sh

####start prometheus
/bin/prometheus --config.file=/prometheus/cdm-cloud-prometheus.yml \
--storage.tsdb.path=/prometheus