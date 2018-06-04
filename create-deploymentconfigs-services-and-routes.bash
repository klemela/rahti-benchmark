#!/bin/bash

set -e

source utils.bash

project=$(get_project)

# it's faster to get lists just once
old_dcs="$(oc get dc -o name)"
old_services="$(oc get service -o name)"
old_routes="$(oc get route -o name)"

for f in templates/deploymentconfigs/*.yaml; do
  # match only to the end of the line to separate "auth" and "auth-api"
  # quotes in the echo keep the new lines and the (second) dollar in the grep matches it

  templated=${f}_templated

  cat $f | sed s/{{project}}/$project/g > $templated

  if echo "$old_dcs" | grep -q "$(basename $f .yaml)$" ; then
    oc replace -f $templated
  else
    oc create -f $templated
  fi

  rm $templated
done


# replace doesn't work for services, so delete all
for f in templates/services/*.yaml; do
  name=$(basename $f .yaml)
  if echo "$old_services" | grep -q "$name$" ; then
    oc delete service "$name"
  fi
done

for f in templates/services/*.yaml; do
  oc create -f $f
done

for f in templates/routes/*.yaml; do
  if echo "$old_routes" | grep -q "$(basename $f .yaml)$" ; then
    oc replace -f $f
  else
     oc create -f $f
   fi
done
