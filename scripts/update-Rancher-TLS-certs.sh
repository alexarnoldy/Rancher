#!/bin/bash
#
# Script to updat Rancher Management server TLS certificates
# Assumes correct version of helm is installed. See https://ranchermanager.docs.rancher.com/pages-for-subheaders/install-upgrade-on-a-kubernetes-cluster for more information.

## copy the cert and key into the home directory with the required file names:
#

CERT_DIR=$(sudo ls -1dtr /etc/letsencrypt/live/susealliances.com-* | tail -1)

sudo cp -p ${CERT_DIR}/fullchain.pem /home/opensuse/tls.crt
sudo cp -p ${CERT_DIR}/privkey.pem /home/opensuse/tls.key

sudo chown opensuse /home/opensuse/tls.crt
sudo chown opensuse /home/opensuse/tls.key

## Delete the private key after one hour:
#

echo "rm -f /home/opensuse/tls.key" | at now +1 hours


## Verify that we are connected to the correct K8s cluster:

echo "Cluster name: $(kubectl --insecure-skip-tls-verify config current-context)"

echo ""

kubectl --insecure-skip-tls-verify get nodes -o wide

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

echo ""

[ ${YESNO} != y ] && { echo "Exiting."; echo ""; exit; }

echo "Continuing..."

echo ""

kubectl --insecure-skip-tls-verify -n cattle-system delete secret tls-rancher-ingress

kubectl --insecure-skip-tls-verify -n cattle-system create secret tls tls-rancher-ingress \
  --cert=/home/opensuse/tls.crt \
  --key=/home/opensuse/tls.key


