#!/bin/bash
#
#
DATE=$(date +%m%d%H%M)

CLUSTER_BASE_NAME="demo-${DATE}"
PLATFORM="terraform"

export CLUSTER_NAME="${CLUSTER_BASE_NAME}-${PLATFORM}"

ssh cc3 'bash -c "sudo sed -i 's/CLUSTER_NAME/${CLUSTER_NAME}/g' /etc/hosts"'

ssh cc3 "cd /home/sles/k3s-edge-sandbox/KVM; ./bin/k3s-cluster-create.sh ${CLUSTER_NAME}"

ssh cc3 'bash -c "sudo sed -i 's/${CLUSTER_NAME}/CLUSTER_NAME/g' /etc/hosts"'


## Delete cluster code
echo "cd /home/sles/k3s-edge-sandbox/KVM" > /tmp/delete-cluster.sh
echo "./bin/destroy_${CLUSTER_NAME}_edge_location.sh" >> /tmp/delete-cluster.sh
chmod 755 /tmp/delete-cluster.sh
echo "scp /tmp/delete-cluster.sh cc3:/tmp; ssh cc3 /tmp/delete-cluster.sh" | at now +2 hours

rm /tmp/delete-cluster.sh

echo "K3s cluster will be deleted in two hours."

