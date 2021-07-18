#!/bin/env bash

# Add Ingress repository to Helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# Update to let Helm know what it contains
helm repo update
# Install the Nginx ingress
helm install nginx-ingress ingress-nginx/ingress-nginx --set controller.publishService.enabled=true
