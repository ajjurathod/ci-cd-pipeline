#!/bin/bash

ENV=$1

echo "Deploying to $ENV..."

case $ENV in
  qa)
    kubectl apply -f deploy/qa-deployment.yaml
    ;;
  uat)
    kubectl apply -f deploy/uat-deployment.yaml
    ;;
  preprod)
    kubectl apply -f deploy/preprod-deployment.yaml
    ;;
  prod)
    kubectl apply -f deploy/prod-deployment.yaml
    ;;
  *)
    echo "Invalid environment: $ENV"
    exit 1
    ;;
esac
