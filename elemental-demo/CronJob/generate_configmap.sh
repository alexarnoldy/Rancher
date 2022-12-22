#!/bin/bash

## Fallback option for creating the configmap in case the kustomize option doesn't work

kubectl create configmap edge-node-updater-configmap --from-file=../script/
