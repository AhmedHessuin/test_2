# Detectron 2
## main repo
detectron2  [git repo](https://github.com/facebookresearch/detectron2)
detectron2 [read doc](https://detectron2.readthedocs.io/en/latest/)
## table on contents 
1. installation 
2. train

## installation 
1. create the enviroment ```conda create -n NIDR python=3.8```
2. activate the enviroment ```conda activate NIDR```
3. you need to download the pre-built version from [the directory model](https://github.com/facebookresearch/detectron2/releases) for example use v0.4 with cuda 10.2 and torch 1.8, example:```python -m pip install detectron2==0.4 -f \
  https://dl.fbaipublicfiles.com/detectron2/wheels/cu102/torch1.8/index.html```
4. download the cuda version ```conda install cudatoolkit=10.2```
5. download other requirments in ```requirments.txt```
* **Now the enviroment is all set**
  
---
 

## train 
* first you need to understand the model format as in the [readme](https://detectron2.readthedocs.io/en/latest/tutorials/models.html#model-input-format)
* our model format will be descriped in the training script

## train labels 
* training data folder must contain
1. image : the target image we want to train on
2. text : the target text contain object
* for each image there must be a text file with the same name
* each text file must contain objects as descriped for each line 
1. coordinates as [top left x, top left y, top right x, top right y, bootom right x, bottom right y, bottom left x, bottom left y]
2. label for the object 
3. example with object contain label 4: ``` 0,10,10,10,10,100,0,100,4```
4. for real case for example 
```
0,10,10,10,10,100,0,100,4
5,15,15,15,15,105,5,105,5
```
5. the training labels for the model must start with index 0 otherwise it will generate an error
## train function
### main()
* this function contain the main process which will be given to the gpus for training 



### mapper2(dataset_dict)
* this function contain the augment generator function and method, if you want to add augmentation modify this function
```    '''
    the mapper used to augment and process the data before feeding it to the detectron2
    it work in online behaviour, you can write on disk the augmented image or do anything else as you can
    but you need to feed the model with the expected data type
    :param dataset_dict: dictionary from the list of dict (list[dict]) that we generated for the model
    :return: a dict contain what model expected to train on
    '''
```
### class Trainer(DefaultTrainer)
* this class inhert from the detectron2 [DefaultTrainer](https://github.com/facebookresearch/detectron2/blob/51704141a5e6d92136c6df1cc2728aedcef9885f/docs/tutorials/training.md), we modify only on the part where we build the trainer ```def build_train_loader(cls, cfg)```
``` We use the "DefaultTrainer" which contains a number pre-defined logic for
    standard training workflow. They may not work for you, especially if you
    are working on a new research project. In that case you can use the cleaner
    "SimpleTrainer", or write your own training loop.
```


### cache_training_data(data,resume=False,cache_name="cache")
* this is used to dumb or load the training data for the model
```    '''
    to save time for loading the training data we create the cache contain list[ dicts {} ] that generated
    for the training
    :param data: the list of dict contain the infromation the model need
    :param resume: resume the training or no, if yes just load the data, else create the data and return it
    :param cache_name: the name of the cache by default it's cache
    :return: the training data for th e model from cach file
    '''
```
### get_docs_dicts(img_dir,resume)
* this is the main function for loading the training data for the model, for our case we have the target folders **front, back, non** this function get the directory contain the 3 folders.
* this function expect each directory to contain image and text file represent the image objects inside it
```        '''
        get the training data for the models as list contain dictionary contain the information the model need to
        start the train.
        :param img_dir:  main dir contain the [front back non] folders
        :param resume: take the dta from te cache or create it
        :return: the list contain the training data dict
        '''
```


 
 
