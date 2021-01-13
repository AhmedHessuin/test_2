# lline_detection_backbone_efficientnet_B0_B4
# Author 
### ahmed hussein ahmed 
---

---
# problem defination 
create new backbone model for EAST
---
# solution
Create efficientnet B0 and B4(modified B4) models and try them as backbone
---
# Requirments
* [East Requirments]()
--- 
# Steps
* following the [paper](https://arxiv.org/pdf/1905.11946.pdf)
* create the new model with tensorflow.contrib.slim (tf_slim), tf.v1.4
* the paper descripe the idea of creating larger models from small models, by increasing 
   * the width(number of filter)
   * the resolution(input shape like [224,224,3])
   * the depth(number of layers )
   * all of them in the same time, using the equations in the paper 
   
* themodel use less parameters than resnet 50 and 30 but it use more computaional power (the depthwise covolution layers)
* this implmentation used rely as activation following the paper archtecture for B0 and modifying it to B4 using the paper equations
* B0, B0 is modification on [mnasnet](https://arxiv.org/pdf/1807.11626.pdf)
![](https://media.discordapp.net/attachments/773272559688613888/796541804806930432/image2.png)
* more information about 
![](https://media.discordapp.net/attachments/773272559688613888/796087537285595176/unknown.png?width=618&height=670)
![](https://media.discordapp.net/attachments/773272559688613888/796046574094254090/The-composition-of-MBConvs-From-left-a-d-M-BConvK-K-B-S-in-EfficientNets.png)

---
# model creation 
* apply the model in the paper and return 5 layers
   * each layer of the 5 is the output before stride using the same idea as [East](https://media.discordapp.net/attachments/773272559688613888/799038465697120317/unknown.png)
   * for example if we have group of layers operate in dimensions 14x14 made of 6 layers return only the last layer contain 14x14 then apply the next layer with down sample and create 7x7 input dimesnion and do the same as 14 x 14
# results 
* checking this [sheet](https://docs.google.com/spreadsheets/d/1VHkFAnUFOxGdn3MSiVXjnZvXfK2WaLiN-H8gXJ2U8Gc/edit#gid=824382746)
* best output was on B0
