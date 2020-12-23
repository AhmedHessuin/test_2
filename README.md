# Author 
### ahmed hussein ahmed 
---


---
# problem defination 
create one model to predict the cells directly from a raw image not croped image contain the table 
---
# solution 
1. modify the east network to be cascade network [East1 --> East2] -->output 
2. asusing the East model that trained on the table as our base network and concatinate it's table score output with the input image
3. pass the concatinated score and image to the next East model to traill on cells 
---
# requirments 
* [East requirments]()
---
# the core file to modify the EAST
1. [model.py]()
2. [multi_train_gpu.py]()
3. [resnet.py]()
---

# slim basics 
* we are using tensorflow slim that is in tensorflow old versions, can be installed with 
    ```
    !pip install git+https://github.com/google-research/tf-slim.git
    ```
* slim conv2d has many attributes we can make all conv2d share this attributes with **slim.arg_scope** iinsted of writing this attributes every time
* slim conv2d support layer name as **scope=**, with this we can generate layers with name like **scope=table_score_layer**
* slim conv2d will break if it found another layer with the same scope name 
* we can make common scope name prefix  with **tf.variable_scope**
---
# creating the new model 
## modify on resnet
* to use resnet 2 times in the code we need to change it's scope **scope='resnet_v1_50'** and **scope='resnet_v1_50_2'**
* this will change the blocks inside resnet **scope name** but this not going to change the resnet endpoint scope name 
* endpoints will have default name **'resnet_v1_50'** whatever is the **scope** we gave to our resnet 
* go to [resnet_v1.py]()
    1. function **resnet_v1**
    2. change the endpoint name, to have the same scope name as the resnet scope name
   ``` 
   end_points['pool3'] = end_points[str(scope)+'/block1']
   end_points['pool4'] = end_points[str(scope)+'/block2']
   ```
* now we can use the resnet in one or more time 
## load the table model to be our base model
* frist we need to restore the old model using the [EAST table model checkpoint]() 

1. create the saver to restore the checkpoint
    ```
    saver = tf.train.Saver(tf.global_variables())
    ```
2. before using restore the checkpoint using the saver 
    1. make sure that we have the same graph as the checkpoint for example: if there are 5 layers in the checkpoint and we used restore, we should
also have 5 layers in the current graph no less no more and with the same scope name as the checkpoint layers sope name
    2. to do that we can create the checkpoint graph first with the [model.meta]() file or we create the graph manually if we know it
3. after making the right graph we can restore the checkpoint now
    ```
    saver = tf.train.Saver(tf.global_variables()) #create the saver 
    F_score_base, F_geometry_base = model.model_base(input_images_split[0]) #create the base model the same as the graph we are gonna load 
    with tf.Session(config=tf.ConfigProto(allow_soft_placement=True)) as sess: # use the tensor flow session
        ckpt = tf.train.latest_checkpoint(FLAGS.checkpoint_path) # checkpoint path to the EAST table model
        saver.restore(sess, ckpt) # restore the EAST Model weights using the checkpoint to our graph
    ```
4. as we can see, we need to use the tensorflow session to restore the checkpoint to our graph 

## create the new model
* we can create another model now so easy, we just need to change the scope names inside the model
* to connect the output from the base model and the created model we need to give the new model **input=f_score_table** for example
* concatinate the input image with the f_score, but this will make 4 d tensor and resnet use 3 d tensor, thus apply conv2d with input dimensions = 3
* continue building the model layers
## loss function
* every layer must be connected to output layer we are gonna use to compute loss
```
return f1_score,f2_score
```
* we are gonna use f1 in the loss function and ignore f2 for now, this will triger a breaking error biase name =None
* to fix this we need to make sure that every layer is connected to output layer, and we are going to use this output layer in the loss function or we add flag **trainable=False** in the conv2d
