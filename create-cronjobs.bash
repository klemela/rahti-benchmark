#!/bin/bash

set -e

source utils.bash

project=$(get_project)

# delete all old jobs first to prevent any extra load
for f in templates/cronjobs/*; do
  name=$(cat $f | yq r - metadata.name)

  if oc get cronjob $name > /dev/null 2>&1; then 
    oc delete cronjob $name
  fi
done


for f in templates/cronjobs/*; do
  # create the openshift job
  cat $f | sed s/{{project}}/$project/g | oc create -f - 
done
