#!/bin/bash
#

#
#

##
###### Base variables
##

DELETE_DELAY="2 hours"
#DELETE_DELAY="10 minutes"

DATE=$(date +%m%d%H%M)

CLUSTER_BASE_NAME="demo-${DATE}"

## BEGIN Functions

func_delete_cluster () {
cat <<EOF | at now +${DELETE_DELAY}
curl 'https://rancher-demo.susealliances.com/v1/provisioning.cattle.io.clusters/fleet-default/${CLUSTER_NAME}' \
  -X 'DELETE' \
  -H 'authority: rancher-demo.susealliances.com' \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cookie: R_PCS=light; R_LOCALE=en-us; R_REDIRECTED=true; CSRF=3c5c95b2d40010180dba90d415e1750d; R_SESS=${TOKEN}' \
  -H 'origin: https://rancher-demo.susealliances.com' \
  -H 'referer: https://rancher-demo.susealliances.com/dashboard/c/_/manager/provisioning.cattle.io.cluster' \
  -H 'sec-ch-ua: "Google Chrome";v="111", "Not(A:Brand";v="8", "Chromium";v="111"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36' \
  -H 'x-api-csrf: 3c5c95b2d40010180dba90d415e1750d' \
  --compressed
EOF
}

func_create_rke2_cluster () {
## Render the correct command to create the *Config resource (k api-resources | grep -i rke-machine-config   to see all)

cat curl-commands/create_${PLATFORM}config.curl | sed "s/TOKEN/${TOKEN}/g" | sed "s/CLUSTER_NAME/${CLUSTER_NAME}/g" > /tmp/${PLATFORM}-${CLUSTER_NAME}-config.sh

## Create the *Config resource
POOL_NAME=$(bash /tmp/${PLATFORM}-${CLUSTER_NAME}-config.sh | jq '.id' | sed 's/\"//g' | awk -F\/ '{print$2}')

## Get the name of the *Config resource
#kubectl config use-context rancher-demo
#POOL_NAME=$(kubectl get ${PLATFORM}config.rke-machine-config.cattle.io -n fleet-default | grep nc-${CLUSTER_NAME}-pool1 | awk '{print$1}')

## Create the cluster resource
cat curl-commands/create_${PLATFORM}_rke2_cluster.curl | sed "s/TOKEN/${TOKEN}/g" | sed "s/CLUSTER_NAME/${CLUSTER_NAME}/g" | sed "s/POOL_NAME/${POOL_NAME}/g" > /tmp/${PLATFORM}-${CLUSTER_NAME}-cluster.sh

bash /tmp/${PLATFORM}-${CLUSTER_NAME}-cluster.sh

sleep 5
rm /tmp/${PLATFORM}-${CLUSTER_NAME}-config.sh
rm /tmp/${PLATFORM}-${CLUSTER_NAME}-cluster.sh
}

func_create_hosted_k8s_cluster () {
## Render the correct command to create the hosted cluster

cat curl-commands/create_${PLATFORM}_cluster.curl | sed "s/TOKEN/${TOKEN}/g"  | sed "s/CLUSTER_NAME/${CLUSTER_NAME}/g" > /tmp/${PLATFORM}-${CLUSTER_NAME}-config.sh

bash /tmp/${PLATFORM}-${CLUSTER_NAME}-config.sh

sleep 5
rm /tmp/${PLATFORM}-${CLUSTER_NAME}-config.sh
}

## END Functions
#

#
## BEGIN create clusters
#

## Possible platform options are: 
# amazonec2
# azure
# digitalocean
# harvester
# linode
# vmwarevsphere
# aks
# eks

##
######## Create Harvester cluster
##

PLATFORM="harvester"

CLUSTER_NAME="${CLUSTER_BASE_NAME}-${PLATFORM}"

func_create_rke2_cluster 

func_delete_cluster

