#!/bin/bash


export KUBECONFIG=/home/opensuse/.kube/elemental.susealliances.com-local

kubectl -n fleet-default get machineinventory -l arcade-location=null --no-headers -o custom-columns=N:.metadata.name > machines

COUNT=1
#COUNT=$(wc -l machines | awk '{print$1}')

END=$(expr $(wc -l machines | awk '{print$1}') + 1)

while [ ${COUNT} -lt ${END} ] 
do 
	echo ${COUNT} 
	LINE=($(head "-$COUNT" inventory | tail -1))
	echo ${LINE}
	MACHINE=($(head "-$COUNT" machines | tail -1))
	echo ${MACHINE}
	SN=$(head "-$COUNT" machines | tail -1 | awk -F- '{print$6}')
	# game-cabinet-floor-coordiantes
	kubectl -n fleet-default label machineinventory ${MACHINE} --overwrite arcade-floor-coordiantes=${LINE[0]}
	#echo "kubectl -n fleet-default label machineinventory ${MACHINE} --overwrite game-cabinet-floor-coordiantes=${LINE[0]}"
	# arcade-location
	kubectl -n fleet-default label machineinventory ${MACHINE} --overwrite arcade-location=${LINE[1]}
	#echo "kubectl -n fleet-default label machineinventory ${MACHINE} --overwrite arcade-location=${LINE[1]}"
	# create-cluster-selector
	kubectl -n fleet-default label machineinventory ${MACHINE} --overwrite create-cluster-selector=${LINE[2]}
	#echo "kubectl -n fleet-default label machineinventory ${MACHINE} --overwrite create-cluster-selector=${LINE[2]}"
	# serialNumber
	kubectl -n fleet-default label machineinventory ${MACHINE} --overwrite serialNumber=${SN}
	#echo "kubectl -n fleet-default label machineinventory ${MACHINE} --overwrite serialNumber=${SN}"
	((COUNT++)) 
done

kubectl -n fleet-default get machineinventory --show-labels
