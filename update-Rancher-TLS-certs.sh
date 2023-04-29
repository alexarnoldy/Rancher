#!/bin/bash
#
# Script to updat Rancher Management server TLS certificates
# Assumes correct version of helm is installed. See https://ranchermanager.docs.rancher.com/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster for more information.



## Verify that we are connected to the correct K8s cluster:

echo "Cluster name: $(kubectl config current-context)"

echo ""

kubectl get nodes

echo ""

read -n1 -p "Is this the cluster running the Rancher instance to be receive an updated TLS certificate? (y/n) " YESNO

echo ""

[ ${YESNO} != y ] && { echo "Exiting."; echo ""; exit; }

echo "Continuing..."

echo ""

## Verify the certificate to be installed:

openssl x509 -noout --text -in /home/opensuse/tls.crt | head -11

echo ""

read -n1 -p "Is this the certificate to be installed? " YESNO

[ ${YESNO} != y ] && { echo "Exiting."; echo ""; exit; }

echo "Continuing..."

echo ""

kubectl -n cattle-system delete secret tls-rancher-ingress

kubectl --insecure-skip-tls-verify -n cattle-system create secret tls tls-rancher-ingress \
  --cert=/home/opensuse/tls.crt \
  --key=/home/opensuse/tls.key


