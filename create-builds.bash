#!/bin/bash

set -x
set -e

# from ubuntu
oc new-build --name base -D - < dockerfiles/base/Dockerfile && sleep 1 && oc logs -f bc/base &
oc new-build --name=grafana -D - < dockerfiles/grafana/Dockerfile --to grafana && sleep 1 && oc logs -f bc/grafana &
wait
