# sockeye-recipes2

Training scripts and recipes for the Sockeye Neural Machine Translation (NMT) toolkit
- The original Sockeye codebase is at [AWS Labs](https://github.com/awslabs/sockeye). This repo is based off [a stable fork](https://github.com/kevinduh/sockeye), version: 2.3.17
- Here we focus on Sockeye v2. This repo is similar but not exactly back-compatible with the older version of [sockeye-recipes for Sockeye v1](https://github.com/kevinduh/sockeye-recipes).

This repo contains scripts that makes it easy to run and replicate NMT experiments.
All model hyperparameters are documented in a file "hyperparams.txt", which are passed to different steps in the pipeline:
- scripts/preprocess-bpe.sh: Preprocess bitext via subword segmentation
- scripts/train.sh: Train the NMT model given bitext
- scripts/translate.sh: Translates a tokenized input file using an existing model


## Installation
First, clone this package: 
```bash
git clone https://github.com/kevinduh/sockeye-recipes2.git sockeye-recipes2
```

We assume that Anaconda for Python virtual environments is available on the system.
All code needed by the scripts are installed in an Anaconda environment named `sockeye2`:

```bash
cd path/to/sockeye-recipes2
bash ./install/install_sockeye_gpu.sh
bash ./install/install_tools.sh
```

If you need to backup or remove your Anaconda environment before re-installing: 
```bash
conda create --name sockeye2_bkup --clone sockeye2
conda remove --name sockeye2 --all
```

## Recipes 

The `egs` subdirectory contains recipes for various datasets. 

* [egs/quickstart](egs/quickstart): For first time users, this recipe explains how sockeye-recipe works. 

* [egs/ted](egs/ted): Recipes for training various NMT models, using a TED Talks dataset consisting of 20 different languages.

The [hpm](hpm) subdirectory contains hyperparameter (hpm) file templates. Besides NMT hyerparameters, the most important variables in this file to set are below: 

* rootdir: location of your sockeye-recipes installation, used for finding relevant scripts (i.e. this is current directory, where this README file is located.)

* modeldir: directory for storing a single Sockeye model training process

* workdir: directory for placing various modeldirs (i.e. a suite of experiments with different hyperparameters) corresponding to the same dataset

* train_tok and valid_tok: prefix of tokenized training and validation bitext file path

* train_bpe_{src,trg} and valid_bpe_{src,trg}: alternatively, prefix of the above training and validation files already processed by BPE


## Design Principles and Suggested Usage

Building NMT systems can be a tedious process involving lenghty experimentation with hyperparameters. The goal of sockeye-recipes is to make it easy to try many different configurations and to record best practices as example recipes. The suggested usage is as follows:
- Prepare your training and validation bitext beforehand with the necessary preprocessing (e.g. data consolidation, tokenization, lower/true-casing). Sockeye-recipes simply assumes pairs of train_tok and valid_tok files. 
- Set the working directory to correspond to a single suite of experiments on the same dataset (e.g. WMT17-German-English)
- Run preprocess-bpe.sh with different BPE vocabulary sizes (bpe_symbols_src, bpe_symbols_trg). These can be saved all to the same datadir.
- train.sh is the main training script. Specify a new modeldir for each train.sh run. The hyperparms.txt file used in training will be saved in modeldir for future reference. 
- At the end, your workingdir will have a single datadir containing multiple BPE'ed versions of the bitext, and multiple modeldir's. You can run tensorboard on all these modeldir's concurrently to compare learning curves.

There are many options in Sockeye. Currently not all of them are used in sockeye-recipes; more will be added. See [sockeye/arguments.py](https://github.com/kevinduh/sockeye/blob/master/sockeye/arguments.py) for detailed explanations. 

Alternatively, directly call sockeye with the help option as below. Note that sockeye-recipe hyperameters have the same name as sockeye hyperparameters, except that sockeye-recipe hyperparameters replace the hyphen with underscore (e.g. --num-embed in sockeye becomes $num_embed in sockeye-recipes):
 
```bash
conda activate sockeye2
python -m sockeye.train --help
```
