# DEEPLEARNING REGIONER USING YOLOV5
### ahmed hussein ahmed 
## problem difination
* rule based regioner not good enough for future experiments and not stable with all images (using threshold leads to unstable output)
# solution
* create new regioner based on Deep learning not rule based (to generate more stable and reliable regioner)
* using yolov5s (you only look once version 5 small), with multi labels to generate output tree from the given image 
---
# Requirments
* [tfv2 model requirments]()
* opencv 4.4.0.46
* numpy 1.18.5
* python 3.8
* cuda 10.1
* [yolov5 tf requriments]()
--- 
# Descriptions 
* using yolov5 small model to generate labels on the input image to classify the context into one or more of  the incoming labels
  * par
  * header
  * sub_par
  * footer
  * sub_par_f
  * page_header
# Labels Descriptions 
## par 
* par is the largest element in the input image, it can be repesented as the input image itself for single artical image or artical if the input image was paper or magzien.
* par contain many labels inside it, like (sub_par, header, sub_par_f) thus the par is the label that connect other labels together ![](https://media.discordapp.net/attachments/780088906972397578/833923223359586314/unknown.png)
* as we can see the par label contain 2 sub-par

## sub_par
* sub_par is the text written under each other to for a block of text. 
* this block of text can be the whole input image or colums in the image ![](https://media.discordapp.net/attachments/780088906972397578/833923223359586314/unknown.png)
* this image contain 2 blocks thus contain 2 sub_par ![](https://media.discordapp.net/attachments/780088906972397578/833923960018042880/unknown.png)
* this image contain  3 sub_par and par contain all labels inside it 

## header
* header is most likley the bold, large, tall text in the input image, it is also the tilte of the page
* example ![](https://media.discordapp.net/attachments/780088906972397578/833923960018042880/unknown.png)
* this image contain 2 headers label inside the par label

## footer 
* footer the most likley the page number of the input image, it can also be a floating text under the par
* example ![](https://media.discordapp.net/attachments/780088906972397578/833923960018042880/unknown.png) ![](https://media.discordapp.net/attachments/780088906972397578/833924916851376148/unknown.png)
* this image contain footer
