#!/bin/bash
#
#
export CLUSTER_NAME=test

ssh cc3 'bash -c "sudo sed -i 's/CLUSTER_NAME/${CLUSTER_NAME}/g' /etc/hosts"'

ssh cc3 "cd /home/sles/k3s-edge-sandbox/KVM; ./bin/k3s-cluster-create.sh ${CLUSTER_NAME}"

ssh cc3 'bash -c "sudo sed -i 's/${CLUSTER_NAME}/CLUSTER_NAME/g' /etc/hosts"'



echo "ssh cc3 "cd /home/sles/k3s-edge-sandbox/KVM; ./bin/destroy_${CLUSTER_NAME}_edge_location.sh""  | at now +10 minutes
