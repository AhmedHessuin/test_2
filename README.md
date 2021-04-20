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

## sub_par_f
* this stands for sub par floating, this is not a header or a sub par, it's most likley the ads in papers, it contain the header constrains and also a block of text 
* example ![](https://media.discordapp.net/attachments/780088906972397578/833926126811217940/unknown.png)

## page header
* is the paper header most likley  the largest line on paper (not a simple input image), it contain the paper name and the page number (can be removed later)
* example![](https://media.discordapp.net/attachments/780088906972397578/833927663508258831/unknown.png?width=455&height=637)

# the benefits from the label system
* the benefits from the labels system can be seen in block sorting, as in papers or normal images the labels are sorted by
* for each par 
1. headers first
2. sub_pars second 
3. sub_par_f third (in any order it's an ads) 

* this algorithm will be robust to sort the blocks 
* example ![](![image](https://media.discordapp.net/attachments/780088906972397578/833929393486954527/unknown.png?width=138&height=635)
* in this image we can see the yolov5 output at the top, the post processing on yolov5 in the middle and rule based model at the bottom
* the deep learning model show more robust in sub_par.
* example 2 ![](https://media.discordapp.net/attachments/780088906972397578/833929656477548544/unknown.png?width=148&height=636)
* in this example knowing that the middle text is the header, gives it order 1 in block sorting making the sorting algorithm more robust and reliable
* can run the model in parllel with the line detection model in case of robust yolov5s model
* can be used on arabic or english data directly no need to give the language as input ( helpful in case of sorting with out recognition)
# constrains
* need a large amount of labeled data
