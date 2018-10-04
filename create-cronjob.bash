#!/bin/bash

set -e

source utils.bash

job="$1"
schedule=${2:-'12 * * * *'}
completions=${3:-1}

if [ -z "$job" ]; then 
  echo "Usage: create-cronjob.bash BASH_FILE [CRON_SCHEDULE] [COMPLETIONS]"
  exit 1
fi

if [ -z "$" ]; then 
  echo "Usage: run-job.bash BASH_FILE"
  exit 1
fi

project=$(get_project)

name=$(basename $job .bash)-bash-cronjob

if oc get cronjob $name > /dev/null 2>&1; then 
  oc delete cronjob $name
fi

echo "scheduling $completions $(basename $job) scripts to run at $schedule"

# esacpe asterisk for the sed regexp
schedule=$(echo "$schedule" | sed 's/*/\\*/g')

cat templates/cronjobs/bash-cronjob-template.yaml \
  | sed s/{{name}}/$name/g \
  | sed s/{{project}}/$project/g \
  | sed s/{{completions}}/$completions/g \
  | sed s%{{schedule}}%"$schedule"%g \
  | yq -j r - | jq .spec.jobTemplate.spec.template.spec.containers[0].command[2]="$(cat $job | jq -s -R .)" \
  | tee /dev/stderr \
  | oc create -f - --validate
