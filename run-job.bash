#!/bin/bash

set -e

source utils.bash

job="$1"

if [ -z "$job" ]; then 
  echo "Usage: run-job.bash BASH_FILE"
  exit 1
fi

project=$(get_project)

name=$(basename $job .bash)-bash-job

if oc get job $name > /dev/null 2>&1; then 
  oc delete job $name
fi

cat templates/jobs/bash-job-template.yaml \
  | yq -j r - | jq .spec.template.spec.containers[0].command[2]="$(cat $job | jq -s -R .)" \
  | sed s/{{project}}/$project/g \
  | sed s/{{name}}/$name/g \
  | oc create -f - --validate

while ! oc get pod | grep $name- | grep -v ContainerCreating; do
  sleep 2
done

oc logs job/$name --follow