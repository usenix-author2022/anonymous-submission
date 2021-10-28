#!/bin/bash
docker run --gpus device=$1 --rm -v $REPO_PATH:/asr-python \
  -w /asr-python \
	-it sound_poisoning \
	python3 src/eval_baseline.py --model-type $2
