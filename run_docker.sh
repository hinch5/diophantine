#!/usr/bin/env bash

if [[ $1 != "01" && $1 != "05" && $1 != "test" ]]; then
	echo "enter track"
	exit 1
fi

if [[ $2 == "" ]]; then
	echo "enter task number"
	exit 1
fi

if [[ $3 == "" ]]; then
	echo "enter interpreter path"
	exit 1
fi

docker build -t refal:diophantine .
docker run --name diophantine-$1-$2 refal:diophantine $1 $2
docker cp diophantine-$1-$2:/usr/src/dio/solutions/$1_track_$2 ./solutions/
docker rm diophantine-$1-$2