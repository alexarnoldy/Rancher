#!/bin/bash
#
# Script to automate updating Rancher Management server
# Assumes correct version of helm is installed. See https://ranchermanager.docs.rancher.com/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster for more information.



## Verify that we are connected to the correct K8s cluster:

echo "Cluster name: $(kubectl config current-context)"

echo ""

kubectl get nodes

echo ""

read -n1 -p "Is this the cluster running the Rancher instance to be upgraded? (y/n) " YESNO

echo ""

[ ${YESNO} != y ] && { echo "Exiting."; echo ""; exit; }

echo "Continuing..."

echo ""

## Ensure the helm chart is available to this workstation:

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

## Would like to add a piece here to validate which repo is needed

CHART_REPO="latest"

helm repo update rancher-${CHART_REPO}

helm search repo rancher-${CHART_REPO}

echo ""

read -p "What CHART VERSION would you like to upgrade to? " CHART_VERSION

[ $(helm search repo rancher-latest | grep ${CHART_VERSION} | wc -l) != 1 ] && { echo "Chart version ${CHART_VERSION} not found. Exiting."; exit; }


## Gather the current chart values:

helm get values -n cattle-system rancher > /tmp/rancher-values.yaml

## Upgrade Rancher:

helm upgrade rancher rancher-${CHART_REPO}/rancher \
  --namespace cattle-system \
  --values /tmp/rancher-values.yaml \
  --version=${CHART_VERSION}

## Montior upgrade:

echo ""

echo "Monitor the rollout process and use Ctrl+c to exit..."

echo ""

sleep 10

kubectl rollout -n cattle-system status deployment rancher

echo "rm /tmp/rancher-values.yaml" | at now +1 hours

