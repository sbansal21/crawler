#!/usr/bin/env bash

declare -A IPTable

IPTable[dev1]=127.0.0.1
IPTable[dev2]=127.0.0.2
IPTable[dev3]=127.0.0.3

mkdir root &> /dev/null
for IP in "${!IPTable[@]}"; do
	echo $@
	java -jar zk-crawler-1.0.0.jar generate ${IPTable[$IP]} /alcatrazproperties/3.0 `pwd`/root $IP $@
done
