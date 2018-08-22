#!/bin/bash

ENGINE=$1
CUTOFF=0

if [ $ENGINE == "podman" ]; then
	CUTOFF=8
else 
	CUTOFF=7
fi

CMD="$1 run  --security-opt=no-new-privileges --cap-drop=ALL --security-opt label=type:nvidia_container_t --rm -it docker.io/mirrorgooglecontainers/cuda-vector-add:v0.1"

$CMD

FILES=$(grep mounting /var/log/nvidia-container-runtime-hook.log | tail -n 50 |  awk '{ print $8 }' | cut -d'/' -f${CUTOFF}- | grep -e '^merged' | sort | uniq | cut -d'/' -f2-)

IFS='
'


for i in $FILES
do
	
	echo "Checking /$i"
	$1 run  --security-opt=no-new-privileges --cap-drop=ALL --security-opt label=type:nvidia_container_t --rm -it docker.io/mirrorgooglecontainers/cuda-vector-add:v0.1 bash -c "ls -lZ /$i"
done
