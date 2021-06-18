#!/bin/bash

docker service ls -q > list

cat list | while read line
do
	docker service update --restart-condition none  $line
done

rm -f list
