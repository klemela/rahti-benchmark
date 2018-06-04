#!/bin/bash

set -e

source utils.bash

project=$(get_project)

for f in templates/jobs/*.bash; do
  name=$(basename $f .bash)

  if oc get job $name > /dev/null 2>&1; then 
    oc delete job $name
  fi
done

for f in templates/jobs/*.bash; do
  name=$(basename $f .bash)

  cat templates/jobs/bash-job-template.yaml \
  | yq -j r - | jq .spec.template.spec.containers[0].command[2]="$(cat $f | jq -s -R .)" \
  | sed s/{{project}}/$project/g \
  | sed s/{{name}}/$name/g \
  | oc create -f - --validate
done
