# anonymous-submission
This repository is created to be an anonymous source for the submission of our work to the USENIX 2022 security conference.
Please note that we created a repository with this name before the submission (with the intention to add the anonymized code by the end of October 2022). However, while pushing the code, we made a mistake which could have led to break the anonymity. So, we removed that repository and created another one from scratch on Oct. 28, 2021.

## Poison Samples
Unzip [samples.zip](https://drive.google.com/file/d/1DSzzPXo5tn3mSCozxF-zRlpzC0ZfWgj_/view?usp=sharing).
In the folder `samples/poisons`, you can find 20 randomly selected poison samples for 12 succesfull attacks. We provided poison samples for both when the psychoacoustic modeling is disabled as well as when a margin of 30dB is used.
In the foler `samples/clean`, you can find the original (i.e., clean) poison samples that are in the `samples/poisons` folder.

## Prerequisites
### Dataset
Before anything, download our datasets and surrogate decoders (HMMs) from [here](https://drive.google.com/file/d/1qs8Y28xGvds5TMBDJRzvgnkhm-MrZCSX/view?usp=sharing). Unzip it in the root directory.
Then, the raw audio files of the dataset can be found at `data/raw`. In the example that we are attacking the victim's system with `DNN2+` network, the surrogate decoder/HMM is located at `data/TwoLayerPlus/aligned/hmm.h5`. The aligned labels (alignment for audio waveform and HMM states) for training and test sets are located at `data/TwoLayerPlus/aligned/TRAIN` and `data/TwoLayerPlus/aligned/TEST` directories. It should be noted that the `TEST` directory will not be used except for the targeted input file. That is, when evaluating the victim's system, we do not use these aligned labels since we train the whole system from scratch. This guarantees the fairness of evaluation, with respect to our threat model.

If you want, you can download the TIDIGITS dataset yourself from [here](https://catalog.ldc.upenn.edu/LDC93S10), just note that it does not come with the alignment of labels. We have used the `Montreal Forced Aligner` library to determine which parts of audio waveform correspond to which digit (in the ground-truth label). You can download the specific version of the library that we've used to generate the alignments for the dataset [here](https://drive.google.com/file/d/1ff499CJsvKNWIjyQycylrNN5yBrLXE80/view?usp=sharing). Then unzip it into folder `montreal-forced-aligner`.

If you download the dataset from our link, you don't need to download and run this library yourself.

### Experiments
To run experiments in the docker, you first need to build the docker image.
```
docker build -t sound_poisoning .
```

Note that the default docker file (i.e., `Dockerfile`) is using `Cuda 10.1`. We also provide `Dockerfile-cuda11.0`, which uses `Cuda 11.0`

You can start the poisoning attack by running:
```
docker run --gpus device=$gpu --rm -v $REPO_PATH:/asr-python \
	-it sound_poisoning \
	"--target-filename $targetFilename --adv-label $advLabel --data-dir $dataDir --task $task --poisons-budget $poisonBudget --model-type $net "
```
where `$dataDir` is the path to the data directory, and `$task` is either `TIDIGITS` or `SPEECHCOMMANDS`. The parameter `$net` determines the network type we use for the surrogate networks, and `$poisonBudget` is the poison budget we use (r_p in the paper). Parameters `$targetFilename` and `$advLabel` determine the name of the targeted input file and the adversarial word sequence, respectively.
You may want to look at the list of parameters of `src/craft_poisons.py`.

You can use `eval.sh` script to evaluate the generated poisons of one attack against a victim that starts training the ASR system from scratch. Even the Viterbi training is being done from scratch. The random seed used by the victim is new.

To automate the experiments in our paper, we have used scripts in `src/exp/`, which you may find useful. You probably need to adjust the path to the source code.
