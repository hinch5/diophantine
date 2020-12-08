#!/usr/bin/env bash

while [[ -s $1 ]]; do
	line=$(head -n 1 $1)
	tail -n +2 $1 > tmp.txt && mv tmp.txt $1
	num=${line#* }
	track=${line% *}
	echo $track
	echo $num
	./run_docker.sh $track $num
done
