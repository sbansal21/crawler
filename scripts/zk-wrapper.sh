#!/usr/bin/env bash

declare -A IPTable

IPTable[jeremy]=
IPTable[steve]=
IPTable[praneeth]=
IPTable[chris]=

mkdir root &> /dev/null
for IP in "${!IPTable[@]}"; do
	echo $@
	java -jar zk-crawler.jar generate ${IPTable[$IP]} /alcatrazproperties/2.5 `pwd`/root $IP $@
done
