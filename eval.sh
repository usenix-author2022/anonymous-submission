#!/bin/bash
docker run --gpus device=$1 --rm -v $REPO_PATH:/asr-python \
  -w /asr-python \
	--user $(id -u):$(id -g) \
	-it sound_poisoning \
	python3 src/eval.py --attack-dir $2
