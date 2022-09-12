#!/bin/bash

set -e

minikube addons enable csi-hostpath-driver
kubectl -n application create -k ./.CICD/k8s/monitoring/prometheus
