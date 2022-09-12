#!/bin/bash

set -e

# Check if minikube is in $PATH
path_to_minikube=$(which minikube)

# Install minikube if not in $PATH
if ! [[ -x "$path_to_minikube" ]]; then
  curl -LO https://storage.googleapis.com/minikube/releases/v1.26.1/minikube-linux-amd64
  sudo install minikube-linux-amd64
fi

# Start minikube instance if not in running state
is_minikube_running="$(minikube status -o json | jq '.Host')"
[[ "${is_minikube_running}" == '"Running"' ]] && echo "[INFO] minikube is already in running state." || minikube start --cpus 4 --addons registry --insecure-registry "10.0.0.0/24"

kubectl port-forward --namespace kube-system service/registry 5000:80 > logs/registry.log 2>&1 &

