# merged_line_issue
### ahmed hussein ahmed 
---

---
# problem defination 
* lines are merged together in the inference 
---
# solution
* retrain the model with diffrent image size 
---
# Requirments
* [east_requirments]()
--- 

# issues
1. the model merge sperated lines
  * this issue found only in the well trained model (trained on 900k ) and the issue not found on base lines models (model trained on 109k steps)

2. the train data found in [east]()
  * if we clustered  the train data we will find out that 
    1. ***max side lenght***
    | cluster range | number of images |
| ---      |  ------  |
| smaller than 1024| 99   | 
| 1024 to 2048| 634 |
| 2048 or larger  |    21896      | 
    2. ***min  side lenght***
    | cluster range | number of images |
| ---      |  ------  |
| smaller than 1024| 510   | 
| 1024 to 2048| 13163 |
| 2048 or larger  |    8956      | 

  * as we can see the train data not fair if we used cluster with max side lenght
  
# state of art solution 
* retrain the model with resizing the images to increase the small image cluster
