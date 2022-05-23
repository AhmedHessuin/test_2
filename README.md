# Rules
1. repo start with author name  as a header
2. repo second head is the experiment name(fixed prefix) followed by **V**, **V** stands for version, if this is the first version the **V** should be like V.0.0.0 
description : V.0(change in the data and scripts).0(change in the scripts).0(change in the data)
example using more crafted data V.0.0.1, change in the script for getting the features or generating the crafted data for crafting repo V.0.1.0, change in the baseline with more data crafted and modification in the training scripts V.1.0.0 as this is considered as new experiments
3. repo third head is system, this contain the "kaldi version", "opencv version", "gpu information" and the rest of enviroment information
4. repo forth head is table map for the rest of the repo 
5. data generating files must be in folder named **raw data processing**
6. lats generating files must be in folder named **generating lats**
7. data lang generating files must be in folder named **generating datalang**
8. language model generating files must be in folder named **generating languagemodel**
9. the data used in train (uttsbk, images.scp, text, ...) must be in folder named **kaldi data/train|dev**
10. the language model must be in folder **language model**
11. the data land model must be in folder **datalang/train|dev**
12. the lats folder must be in folder named **lats**
13. the training files must be in folder **training scripts**
14. the decoding files must be in folder **decoding scripts**
15. output model folder must be inside **exp/experiment_name**
16. the decoded data path must be in folder namged **decoded data**
# from this section this will discuss the internal section of the repos
## data generating steps
1. data generating steps as follow 
1.1 first point in this head must be the path to the raw data on sftp or on wep (this is a must )
1.2 the step to craft data, or augmentation 
1.3 follow steps to generate the **kaldi data** 
1.4 a script named **generate_kaldi_data_files.sh** contain all steps done to generate the **kaldi data** **lats** **language model** **datalang** as commands on terminal 
## training steps
1. training steps as follow
1.1 the script used to train the model 
1.2 each hyperparameter used in the script like (the path to train data and other input paths or the learning rate,...) must be named as **hyperparameter_(whatever the name)** no constant value in the script except the values that will remain constant till the god claim your soul 
1.3 each output parameter must be named as **output_(whatever the name)**
1.4 a script named **training_kaldi_data_files.sh** contain all steps done to start training the model and make folder **exp/experiment_name**
## decode steps 
1. the decode steps 
1.1 the scirpt used in decode 
1.2 a script named **decode_kaldi_data_fies.sh** contain all steps done to start the decode and get the normalized result
## result sections
1. the result normalized and non normalized  as utt2spk
2. the result compared to the baseline or the version before the current version  


