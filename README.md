# new models with tensorflow version 2.3.0 
### ahmed hussein ahmed 
---

---
# problem defination 
create new model with tensorflow(tf) version(v) 2.3.0 and modify inference and the training files
---
# solution
* update all files used in [east]() to work with tf v2.3.0
* update the enviroment 
* update icdar files for training 
---
# Requirments
* tf v 2.3.0  
* tensorflow-addons-0.10.0 or tensorflow-addons-0.11.2
* opencv 4.4.0.46
* numpy 1.18.5
* python 3.8
* cuda 10.1
--- 
# enviroment setup 
1. copy the directory [setup enviroment](sftp://research_ninja@192.168.1.137/home/research_ninja/OCR/line_detection/tensorflow_v2/tensorflow_2.3.0/Cuda-Cudnn-Conda-TF_Freshh_installation) to your work directory
2. run the bash installation.sh in the [setup enviroment](sftp://research_ninja@192.168.1.137/home/research_ninja/OCR/line_detection/tensorflow_v2/tensorflow_2.3.0/Cuda-Cudnn-Conda-TF_Freshh_installation)
```
bash installation.sh
```
3. install the tensorflow-addons vesion 0.10.0
```
pip install tensorflow-addons==0.10.0
```

# files descriptions 
* donwload the directory for the base line [base line refactor tf 2.3.0](sftp://research_ninja@192.168.1.137/home/research_ninja/OCR/line_detection/tensorflow_v2/tensorflow_2.3.0/baseline)

1. [effientmodel.py]() this file contain the east model with resnet and effiecntnet b0 model
  1. model layers
    * the diffrenece between tf 1.13.0 to 2.3.0 was huge in the convolutional layers 
    * the conv2d in tf 1.13.0 was followed by padding (using tf.contrib.slim library) and in tf 2.3.0 the padding was removed
    * example for the issue 
    ```
    import tensorflow as tf 
    import tf_slim as tf_contrib_slim
    x=np.ones((1,5,5,3)) # the input
    stride=1
    filter=10
    kernal=3
    output_v2=tf.keras.layers.Conv2D(filter,kernal,stride)(x)
    output_v1=tf_contrib_slim.layers.conv2d(x,filter,kernal,stride)

    print(output_v2.shape)
    print(output_v1.shape)
    ```
    * output
    ```
    (1, 3, 3, 10)
    (1, 5, 5, 10)
    ```
    * thus the whole model was changed by adding the padding value to match the east requiremnts for layers output WXHXC
  2. loss function
    * this file contain the custom loss functions
    ```
        def loss(y_true_cls, y_pred_cls,
             y_true_geo, y_pred_geo,
             training_mask):
        '''
        define the loss used for training, contraning two part,
        the first part we use dice loss instead of weighted logloss,
        the second part is the iou loss defined in the paper
        :param y_true_cls: ground truth of text
        :param y_pred_cls: prediction os text
        :param y_true_geo: ground truth of geometry
        :param y_pred_geo: prediction of geometry
        :param training_mask: mask used in training, to ignore some text annotated by ###
        :return:
        '''
        classification_loss = dice_coefficient(y_true_cls, y_pred_cls, training_mask)
        # scale classification loss to match the iou loss part
        classification_loss *= 0.01

        # d1 -> top, d2->right, d3->bottom, d4->left
        d1_gt, d2_gt, d3_gt, d4_gt, theta_gt = tf.split(value=y_true_geo, num_or_size_splits=5, axis=3)
        d1_pred, d2_pred, d3_pred, d4_pred, theta_pred = tf.split(value=y_pred_geo, num_or_size_splits=5, axis=3)
        area_gt = (d1_gt + d3_gt) * (d2_gt + d4_gt)
        area_pred = (d1_pred + d3_pred) * (d2_pred + d4_pred)
        w_union = tf.minimum(d2_gt, d2_pred) + tf.minimum(d4_gt, d4_pred)
        h_union = tf.minimum(d1_gt, d1_pred) + tf.minimum(d3_gt, d3_pred)
        area_intersect = w_union * h_union
        area_union = area_gt + area_pred - area_intersect
        L_AABB = -tf.compat.v1.log((area_intersect + 1.0) / (area_union + 1.0))
        L_theta = 1 - tf.cos(theta_pred - theta_gt)
        # tf.summary.scalar('geometry_AABB', tf.reduce_mean(L_AABB * y_true_cls * training_mask))
        # tf.summary.scalar('geometry_theta', tf.reduce_mean(L_theta * y_true_cls * training_mask))
        L_g = L_AABB + 20 * L_theta

        return tf.reduce_mean(L_g * y_true_cls * training_mask) + classification_loss

    ```
    * using the same losses as tf 1.13.0 which were the dice lose for the F score and IOU for the geo map
    * the custom loss function required the geo_map true and the f_score true 
    * the normal custom loss functions which we use in combile faild, as it require only (true_label, predicted_label) and can't be given (true_label_1,true_label_2,predicted_label_1,predicted_label_2)
  3. custom loss issue solution
    * ***using the loss function as a part of the model***
      1. add 3 more input layers to the model name them as f_score_true, f_geometry_true,training_mask_in (note that we give the loss extra parameters)
      ```
      created_model = tf.keras.Model(inputs=[images,training_mask_in,f_score_true,f_geometry_true], outputs=[F_score, F_geometry])
      ```
      2. add loss layer to the model
      ```
      custom_loss=loss(f_score_true,F_score,f_geometry_true,F_geometry,training_mask_in)

      created_model.add_loss(custom_loss)
      ```
        * note that now the model take 4 parameters insted of 1 and return 2 outputs F_score and F_geometry 
      3. combile the model with out giving it any loss 
      ```
      model.compile(optimizer=opt)
      ```
  4. in the training give the model 4 inputs insted of 1

  
