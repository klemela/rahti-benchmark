#!/bin/bash

function get_project {
  oc project -q
}

function get_domain {
  echo "rahtiapp.fi"
}

function make_temp {
  name="$1"

  if mktemp --version > /dev/null 2>&1; then
    # GNU
    mktemp -d -t $name.XXX
  else
    # MacOS
    mktemp -d -t $name
  fi
}