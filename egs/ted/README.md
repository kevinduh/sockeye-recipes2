## Multitarget TED Talks 

This recipe builds systems from the TED Talks corpus at:
http://www.cs.jhu.edu/~kevinduh/a/multitarget-tedtalks/ .
There are many languages available (~20), so we can try many different language-pairs. 

### 1. Setup

First, download the data. It's about 575MB compressed and 1.8GB uncompressed.
```bash
sh ./0_download_data.sh
```

Then, setup the task for the language you are interested.
Let's do Chinese (zh) for now.  
The following command creates a new working directory (zh-en) 
and populates it with several hyperparameter files 

```bash
sh ./1_setup_task.sh zh
cd zh-en
ls
```

You should see files like `ts1.hpm` which is one of the hyperparameter files we will run with. Further, the checkpoint interval is 4000 updates and all model information will be saved in ./ts1.

### 2. Preprocessing and Training

First, make sure we are in the correct working directory (`$rootdir/egs/ted/zh-en`). All hyperparameter files and instructions below assume we are in `$rootdir/egs/ted/zh-en`, where `$rootdir` is the location of the sockeye-recipes installation. 

Now, we can preprocess the tokenized training and dev data using BPE.
```bash
../../../scripts/preprocess-bpe.sh ts1.hpm
```

The resulting BPE vocabulary file (for English) is: `data-bpe/train.bpe-30000.en.bpe_vocab` and the segmented training file is: `data-bpe/train.bpe-30000.en`. For Chinese, replace `en` by `zh`. These are the files we train on. 

To train, we will use qsub and gpu (On a Tesla V100, this should take about 6 hours):

```bash
qsub -S /bin/bash -V -cwd -q gpu.q -l gpu=1,h_rt=12:00:00,num_proc=1 -j y ../../../scripts/train-textformat.sh -p ts1.hpm -e sockeye2
```


### 3. Evaluation

Again, make sure we are in the correct working directory (`$rootdir/egs/ted/zh-en`). The test set we want to translate is `../multitarget-ted/en-zh/tok/ted_test1_en-zh.tok.zh`. We translate it using ts1 via qsub on gpu (this should take 10 minutes or less):

```bash
qsub -S /bin/bash -V -cwd -q gpu.q -l gpu=1,h_rt=00:30:00 -j y ../../../scripts/translate.sh -p ts1.hpm -i ../multitarget-ted/en-zh/tok/ted_test1_en-zh.tok.zh -o ts1/ted_test1_en-zh.tok.en.1best -e sockeye2
```

Note you can also pass to `translate.sh` some options `-b batchsize(default:1)` and `-v beamsize(default:5)` to speed up the decoding time.

Alternatively, to translate using CPU:

```bash
qsub -S /bin/bash -V -cwd -q all.q -l h_rt=00:30:00 -j y ../../../scripts/translate.sh -p ts1.hpm -i ../multitarget-ted/en-zh/tok/ted_test1_en-zh.tok.zh -o ts1/ted_test1_en-zh.tok.en.1best -e sockeye2 -d cpu
```

When this is finished, we have the translations in `ts1/ted_test1_en-zh.tok.en.1best`. We can now compute the BLEU score by:

```bash
../../../tools/multi-bleu.perl ../multitarget-ted/en-zh/tok/ted_test1_en-zh.tok.en < ts1/ted_test1_en-zh.tok.en.1best
```

This should give a BLEU score of around 17.


### Benchmark Results 

The test set BLEU scores of various tasks are:

 task | ts1 | 
  --- | --- | 
ar-en | 28.75 |
bg-en | 36.84 |
cs-en | 27.82 |
de-en | 33.75 |
fa-en | 22.59 |
fr-en | 35.81 |
he-en | 35.02 |
hu-en | 22.49 |
id-en | 27.92 |
ja-en | 12.47 |
ko-en | 16.16 |
pl-en | 24.66 |
pt-en | 42.40 |
ro-en | 36.27 |
ru-en | 24.49 |
tr-en | 24.12 |
uk-en | 19.30 |
vi-en | 26.38 |
zh-en | 17.01 |
