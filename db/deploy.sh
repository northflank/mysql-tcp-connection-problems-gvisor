#!/usr/bin/env bash

# Add the bitnami repo to helm in order to install the bitnami mysql chart
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Install the helm chart
# You may need to update storageClass in the values.yaml file
helm install mysql bitnami/mysql -f values.yaml -n default

# Patch the statefulset so it runs in gvisor
kubectl patch statefulset mysql --type=merge --patch='{"spec":{"template":{"spec":{"runtimeClassName":"gvisor"}}}}'
# Ensure the pod actually uses gvisor
kubectl delete pod mysql-0