#!/bin/bash

set -e

docker build --tag simple-python-web-app:production -f .CICD/docker/production.Dockerfile .

docker tag simple-python-web-app:production localhost:5000/simple-python-web-app

docker push localhost:5000/simple-python-web-app

kubectl apply -k .CICD/k8s/nginx/

kubectl -n application apply -k .CICD/k8s/application/
