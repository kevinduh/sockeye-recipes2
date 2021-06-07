## Hyperparameter file templates for sockeye-recipes

These files should be self-explanatory. The general naming convention is:

* First letter: {t = Transformer}
* Second letter: {s = small model, m = mid-sized model, l = large model}
* Third numeral: Just an identifier

So, for example:

* ts1 = Transformer model, relatively small size, id=1. These have around 50M parameters (exact number depends on vocabulary size)
* tm1 = Transformer model, mid-sized. These have alround 80M+ parameters. id=1 corresponds to Tranformer Base in original paper.
* tl1 = Transformer model, large. These have around 250M+ parameters. id=1 corresponds to Tranformer Big in original paper
* tb = Transformer model, very small size models, e.g. around 20M parameters

Additionally, some deep encoder shallow decoder models are available. Naming convention is:

* b2-e6d2 = follows most of the hyperparameters of tb2, but changed encoder to 6 layers and decoder to 2 layers. 
* l1-e10d2 = follows most of the hyperparameter of tl1, but changed encoder to 10 layers and decoder to 2 layers.

These hyperparameter file templates are meant to be used as starting points. The best hyperparameter setting will of course depend on the task. 

