#!/bin/bash
#
#DATE=$(date +%s | cut -b 6-)
DATE=$(date +%m%d%H%M)

CLUSTER_BASE_NAME="demo-${DATE}"


##
######## Create Harvester cluster
##

CLUSTER_NAME="${CLUSTER_BASE_NAME}-harvester"

## Render the correct command to create the harvesterConfig

cat curl-commands/create_HarvesterConfig.curl | sed "s/TOKEN/${TOKEN}/g" | sed "s/CLUSTER_NAME/${CLUSTER_NAME}/g" > /tmp/harvester-${CLUSTER_NAME}-config.sh

## Create the harvesterConfig
bash /tmp/harvester-${CLUSTER_NAME}-config.sh

## Get the name of the harvesterConfig object
kubectl config use-context rancher-demo
POOL_NAME=$(kubectl get HarvesterConfig.rke-machine-config.cattle.io -n fleet-default | grep nc-${CLUSTER_NAME}-pool1 | awk '{print$1}')

## Create the harvester cluster
cat curl-commands/create_Harvester_RKE2_cluster.curl | sed "s/TOKEN/${TOKEN}/g" | sed "s/CLUSTER_NAME/${CLUSTER_NAME}/g" | sed "s/POOL_NAME/${POOL_NAME}/g" > /tmp/harvester-${CLUSTER_NAME}-cluster.sh

bash /tmp/harvester-${CLUSTER_NAME}-cluster.sh

sleep 5
rm /tmp/harvester-${CLUSTER_NAME}-config.sh
rm /tmp/harvester-${CLUSTER_NAME}-cluster.sh

#
####### Create EC2 RKE2 cluster
#

CLUSTER_NAME="${CLUSTER_BASE_NAME}-ec2"

## Render the correct command to create the Amazonec2Config
cat curl-commands/create_Amazonec2Config.curl | sed "s/TOKEN/${TOKEN}/g" | sed "s/CLUSTER_NAME/${CLUSTER_NAME}/g" > /tmp/ec2-${CLUSTER_NAME}-config.sh

## Create the Amazonec2Config
bash /tmp/ec2-${CLUSTER_NAME}-config.sh

## Get the name of the Amazonec2Config object
kubectl config use-context rancher-demo
POOL_NAME=$(kubectl get Amazonec2Config.rke-machine-config.cattle.io -n fleet-default | grep nc-${CLUSTER_NAME}-pool1 | awk '{print$1}')

## Create the EC2 RKE2 cluster
cat curl-commands/create_EC2_RKE2_cluster.curl | sed "s/TOKEN/${TOKEN}/g" | sed "s/CLUSTER_NAME/${CLUSTER_NAME}/g" | sed "s/POOL_NAME/${POOL_NAME}/g" > /tmp/ec2-${CLUSTER_NAME}-cluster.sh

bash /tmp/ec2-${CLUSTER_NAME}-cluster.sh

sleep 5
rm /tmp/ec2-${CLUSTER_NAME}-cluster.sh
rm /tmp/ec2-${CLUSTER_NAME}-cluster.sh

#
####### Create Azure RKE2 cluster
#

CLUSTER_NAME="${CLUSTER_BASE_NAME}-azure"

## Render the correct command to create the AzureConfig

cat curl-commands/create_AzureConfig.curl | sed "s/TOKEN/${TOKEN}/g" | sed "s/CLUSTER_NAME/${CLUSTER_NAME}/g" > /tmp/azure-${CLUSTER_NAME}-config.sh

## Create the AzureConfig
bash /tmp/azure-${CLUSTER_NAME}-config.sh

## Get the name of the AzureConfig object
kubectl config use-context rancher-demo
POOL_NAME=$(kubectl get AzureConfig.rke-machine-config.cattle.io -n fleet-default | grep nc-${CLUSTER_NAME}-pool1 | awk '{print$1}')

## Create the Azure RKE2 cluster
cat curl-commands/create_Azure_RKE2_cluster.curl | sed "s/TOKEN/${TOKEN}/g"  | sed "s/CLUSTER_NAME/${CLUSTER_NAME}/g" | sed "s/POOL_NAME/${POOL_NAME}/g" > /tmp/azure-${CLUSTER_NAME}-cluster.sh

bash /tmp/azure-${CLUSTER_NAME}-cluster.sh

sleep 5
rm /tmp/azure-${CLUSTER_NAME}-config.sh
rm /tmp/azure-${CLUSTER_NAME}-cluster.sh

#
####### Create EKS cluster
#

CLUSTER_NAME="${CLUSTER_BASE_NAME}-eks"

## Render the correct command to create the EKS cluster

cat curl-commands/create_EKS_cluster.curl | sed "s/TOKEN/${TOKEN}/g"  | sed "s/CLUSTER_NAME/${CLUSTER_NAME}/g" > /tmp/EKS-${CLUSTER_NAME}-config.sh

bash /tmp/EKS-${CLUSTER_NAME}-config.sh

sleep 5
rm /tmp/EKS-${CLUSTER_NAME}-config.sh
#
####### Create AKS cluster
#

CLUSTER_NAME="${CLUSTER_BASE_NAME}-aks"

## Render the correct command to create the AKS cluster

cat curl-commands/create_AKS_cluster.curl | sed "s/TOKEN/${TOKEN}/g"  | sed "s/CLUSTER_NAME/${CLUSTER_NAME}/g" > /tmp/AKS-${CLUSTER_NAME}-config.sh

bash /tmp/AKS-${CLUSTER_NAME}-config.sh

sleep 5
rm /tmp/AKS-${CLUSTER_NAME}-config.sh

