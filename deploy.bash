#!/bin/bash

set -e

source utils.bash

if ! kubectl --help > /dev/null 2>&1; then
  echo "Error: command 'kubectl' not found"
  exit 1
fi

if ! kubectl kustomize --help > /dev/null 2>&1; then
  echo "Error: command 'kubectl kustomize' not found, please update your kubectl"
  exit 1
fi

export PROJECT=$(get_project)
export DOMAIN=$(get_domain)

private_config_path=" ../chipster-private/confs"

# better to do this outside repo
build_dir=$(make_temp rahti-benchmark-deploy)

echo -e "build dir is \033[33;1m$build_dir\033[0m"

base_dir="$build_dir/kustomize"

mkdir -p $base_dir

echo "copy Kustomize yaml files"
cp -r kustomize/* $base_dir

# copy private overlay to the build dir in case this deployment uses it
private_kustomize_path="$private_config_path/$PROJECT.$DOMAIN/kustomize"

echo private kustomize path: $private_kustomize_path

if [ -f $private_kustomize_path/kustomization.yaml ]; then
  echo "create overlay from $private_kustomize_path"

  overlay_dir="$build_dir/overlay"
  mkdir -p $overlay_dir

  # copy the overlay to our build dir
  cp -r $private_kustomize_path/* $overlay_dir

  apply_dir="$overlay_dir"
else
  echo "ERROR: private kustomize path '$private_kustomize_path' was not found. Refusing to deploy without IP whitelist"
  exit 1
fi

echo "apply to server $apply_dir"

kubectl kustomize $apply_dir | oc apply -f -

echo "delete build dir $build_dir"
rm -rf $build_dir
