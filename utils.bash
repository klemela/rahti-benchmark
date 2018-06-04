#!/bin/bash

function get_project {
  oc project -q
}

function get_domain {
  echo "rahti-int-app.csc.fi"
}