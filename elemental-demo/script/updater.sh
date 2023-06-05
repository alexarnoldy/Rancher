#!/bin/bash 


export KUBECONFIG=/home/opensuse/.kube/elemental.susealliances.com-local

while :
do

	
## This command finds all of the edge nodes that have been provisioned, but do not yet have serial numbers
kubectl -n fleet-default get machineinventory -l serialNumber=Not-Specified --no-headers -o custom-columns=N:.metadata.name > machines

COUNT=1

END=$(expr $(wc -l machines | awk '{print$1}') + 1)

while [ ${COUNT} -lt ${END} ] 
do 
	echo ${COUNT} 
	LINE=($(head "-$COUNT" inventory | tail -1))
	MACHINE=($(head "-$COUNT" machines | tail -1))
	echo ${MACHINE}
	SN=$(head "-$COUNT" machines | tail -1 | awk -F- '{print$6}')
	# serialNumber
	kubectl -n fleet-default label machineinventory ${MACHINE} --overwrite serialNumber=${SN}

	((COUNT++)) 
done

## This command finds all of the edge nodes that been powered on at the edge location
# kubectl -n fleet-default get machineinventory -l arcade-location=null -o custom-columns=:.metadata.name,:.status.plan.appliedChecksum | awk '/\<none\>/ {print$1}' > machines

kubectl -n fleet-default get machineinventory -l arcade-location=null -o custom-columns=:.metadata.name,:.status.plan.appliedChecksum | grep -v \<none\> | awk '{print$1}' > machines

COUNT=1

END=$(expr $(grep [1-9] machines | wc -l | awk '{print$1}') + 1)

echo ${COUNT}
echo ${END}

while [ ${COUNT} -lt ${END} ] 
do 
	echo ${COUNT} 
	LINE=($(head "-$COUNT" inventory | tail -1))
	MACHINE=($(head "-$COUNT" machines | tail -1))
	echo ${MACHINE}
	SN=$(head "-$COUNT" machines | tail -1 | awk -F- '{print$6}')
	# Rotate the inventory file to avoid duplicates
	grep -v "${LINE[0]} " inventory > tmp-inventory
	grep "${LINE[0]} " inventory >> tmp-inventory
	mv tmp-inventory inventory
	# game-cabinet-floor-coordiantes
	kubectl -n fleet-default label machineinventory ${MACHINE} --overwrite game-cabinet-floor-coordiantes=${LINE[1]}
	# arcade-location
	kubectl -n fleet-default label machineinventory ${MACHINE} --overwrite arcade-location=${LINE[2]}
	# create-cluster-selector
	kubectl -n fleet-default label machineinventory ${MACHINE} --overwrite create-cluster-selector=${LINE[3]}

	((COUNT++)) 
done

kubectl -n fleet-default get machineinventory --show-labels

sleep 30
done
