# Detectron 2

## table on contents 
1. installation 
2. train

## installation 
1. detectron2  [git repo](https://github.com/facebookresearch/detectron2)
2. install detectron2 [pre-built](https://detectron2.readthedocs.io/en/latest/tutorials/install.html), this is the main detectron 2 librar based on your cuda and pytorch
3. [colab tutorial for installation](https://colab.research.google.com/drive/16jcaJoc6bCFAQ96jDe2HwtXj7BMD_-m5)


## train 
* to train with detectron 2 you need to generate the data with 
1. x1,y1,x2,y2,x3,y3,x4,y4 the four corner points 
 1. the 4 corner get represinted as mask and anchor boxes, this is done inside the detectron2 code
2. the train data must have labels start from index 0, if you tried to have train data with labels [1,2,3] this will fail, change it to [0,1,2]


## train explaination

* generate the data in the code
1. pass the data directory
2. the "train_2" is a directory, contain folders ["front","back","back_new","front_new","non"] each folder cotain image and text data
3. we need to register the training data in the **datacatalog and metacatalog** as followed 
4. the **get_docs_dicts** get the training data path in our example "data_dir/train_2"
5. the **metacatalog** contain the classes in the training dataset 
**CRITICAL NOTE** : the register data name and metacatalog name must be the same, and also in the model cfg

```
data_dir = '/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-ID-Reader'

for d in ["train_2"]:
    DatasetCatalog.register("data_" + "train_2", lambda d=d: get_docs_dicts(data_dir+"/" + d))
    MetadataCatalog.get("data_" + d).set(thing_classes=["front_id", "front_gomhorya", "front_beta2a", "front_name_1", "front_name_2", "front_3enwan_1", "front_3enwan_2", "front_rakmqawmi", "front_sora", "front_tarekh", "front_fcn",
                                                        "back_id", "back_rakmqawmi", "back_tarekh_sodor", "back_wazefa_1", "back_wazefa_2", "back_gender" , "back_religion", "back_marital" , "back_esm_zog", "back_rakm", "back_tarekh_entha2",
                                                        "non"
                                                        ])
```
* continue generating the data 
1. this function contain the loading of images and the labels
2. we have 5 folders each folder represint class ["front","back","non","front_new","back_new"]
3. for each class load it alone, note this consume alot of time due to the large amount of training data
4. the data must be put into something called record, a dictionary datatype
5. record cotntain the full path of the training sample in **file_name**
6. record contain the image_id as a unique flage for each image in **image_id**
7. record contain the image height in **height**
8. record contain the image width in **width**
9. record contain the anchor boxes and the class of each anchor in **annotations**
10. this keys can be filled as follow
```
def get_docs_dicts(img_dir):

    clss = ["front","back","non","front_new","back_new"]
    dataset_dicts = []

    for cls_id, cls_dir  in enumerate(clss):
        print(cls_dir)
        files = os.listdir(os.path.join(img_dir,cls_dir))

        files = [file for file in files if file.split(".")[-1] not in ["txt","csv"]]

        for idx, fn in enumerate(files):
            #print(idx, sep=" ")
            try:

                record = {}

                filename = os.path.join(img_dir, cls_dir,fn.split(".")[0]+".txt")

                with open(filename, "r") as f:
                    lines = f.readlines()

                new_lines = []
                for line in lines:
                    line = line.strip().split(",")
                    new_lines.append(line)

                height, width = cv2.imread(os.path.join(img_dir,cls_dir,fn)).shape[:2]

                record["file_name"] = os.path.join(img_dir,cls_dir,fn)
                record["image_id"] = str(cls_id)+"_"+str(idx)
                record["height"] = height
                record["width"] = width
                objs = []
                for ann in new_lines:
                    px = [float(ann[0]),float(ann[2]),float(ann[4]),float(ann[6]) ]
                    py = [float(ann[1]),float(ann[3]),float(ann[5]),float(ann[7]) ]
                    el_id = int(float(ann[8]))
                    el_id = class_map[clss[cls_id]][el_id]

                    poly = [(x , y) for x, y in zip(px, py)]
                    poly = [p for x in poly for p in x]
                    #print(poly)
                    obj = {
                        "bbox": [np.min(px), np.min(py), np.max(px), np.max(py)],
                        "bbox_mode": BoxMode.XYXY_ABS,
                        "segmentation": [poly],
                        "category_id": el_id,
                    }
                    objs.append(obj)
                record["annotations"] = objs
                dataset_dicts.append(record)
            except Exception as e:
                print("e :",e)
                print("eception")
                continue
    print(dataset_dicts)
    return dataset_dicts
```


* creating the model 
1. to create the model we must get the registerd training data, note the register data name same as the created name while generating the training samples
```
doc_metadata = MetadataCatalog.get("data_train_2")
```
2. create a cfg for the model


** model cfg
* cfg contain all information about the model, each line will be commented for farther information
* you can print the **cfg** after creating it, and if you want to modify anything just use **cfg.THE_THING_NAME.THE_ATTRIBIUTE= whatever i want** 
```
cfg = get_cfg() # get the default configuration
cfg.merge_from_file(model_zoo.get_config_file("COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml")) # get the masrk rcnn R 50 fpn 3x backbone
cfg.DATASETS.TRAIN = ("data_train_2",)# get the train data (data_train_2) same as registered data
cfg.DATASETS.TEST = ()# no data for test
cfg.DATALOADER.NUM_WORKERS = 16# number of workers 

cfg.MODEL.WEIGHTS = model_zoo.get_checkpoint_url("COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml")  # Let training initialize from model zoo from coco, for fast training
cfg.SOLVER.IMS_PER_BATCH = 4 # batch size

#######################
cfg.INPUT.MIN_SIZE_TRAIN = (300,) # min input size
# Sample size of smallest side by choice or random selection from range give by
# INPUT.MIN_SIZE_TRAIN
cfg.INPUT.MIN_SIZE_TRAIN_SAMPLING = "choice"
# Maximum size of the side of the image during training
cfg.INPUT.MAX_SIZE_TRAIN = 1024
# Size of the smallest side of the image during testing. Set to zero to disable resize in testing.
cfg.INPUT.MIN_SIZE_TEST = 300
cfg.INPUT.MAX_SIZE_TEST = 1024

###########################################


#cfg.MODEL.BACKBONE.DEPTH = 18
#cfg.MODEL.RESNETS.DEPTH = 18
#cfg.MODEL.RESNETS.RES2_OUT_CHANNELS = 64

#####################################

cfg.MODEL.ROI_BOX_HEAD.CONV_DIM = 64

cfg.MODEL.ROI_MASK_HEAD.CONV_DIM = 64


###################################

cfg.MODEL.ROI_HEADS.BATCH_SIZE_PER_IMAGE = 32# the roi heads is a hyper paramerter, for the mask rcnn this is a special hyper
# cfg.MODEL.ROI_HEADS.POSITIVE_FRACTION=0.25 # the roi head positiva fraction is a hyper parameter for the mask rcnn

cfg.MODEL.RPN.BATCH_SIZE_PER_IMAGE = 32 

cfg.MODEL.RPN.PRE_NMS_TOPK_TRAIN = 500
cfg.MODEL.RPN.PRE_NMS_TOPK_TEST = 200
cfg.MODEL.RPN.POST_NMS_TOPK_TRAIN = 200
cfg.MODEL.RPN.POST_NMS_TOPK_TEST = 50
# NMS threshold used on RPN proposals
cfg.MODEL.RPN.NMS_THRESH = 0.7

#####################################
cfg.SOLVER.BASE_LR = 0.001 # the learning rate 
cfg.SOLVER.MAX_ITER = 300100    # number of iterations
cfg.SOLVER.STEPS = []        # do not decay learning rate
#cfg.MODEL.ROI_HEADS.BATCH_SIZE_PER_IMAGE = 128   # faster, and good enough for this toy dataset (default: 512)
cfg.MODEL.ROI_HEADS.NUM_CLASSES = 23  # number of classes 
cfg.MODEL.SEM_SEG_HEAD.NUM_CLASSES = 23 # number of classes
cfg.SOLVER.CHECKPOINT_PERIOD = 10000 # checkpoint saver
#cfg.MODEL.WEIGHTS = os.path.join( "output", "model_final.pth")  # path to the last model you trained , this will load the weight and resume training if you want to resume
# NOTE: this config means the number of classes, but a few popular unofficial tutorials incorrect uses num_classes+1 here.
cfg.MODEL.ANCHOR_GENERATOR.ASPECT_RATIOS = [[0.25, 0.5, 1.,2,2.5]] # the anchor generator, generate boxes with ratio 0.25  between height and width,  the generated anchors by default rotate only 90 -90
cfg.MODEL.ANCHOR_GENERATOR.SIZES= [[8], [16], [32], [64], [128]] # the anchor boxes size this reflect to the size of the training data 

cfg.MODEL.DEVICE = 'cuda' # use cuda not cpu
print(cfg)

print("------------------")

print("start train")

cfg.OUTPUT_DIR = "output_hussien/stable_8_16_32_64_128_V3_2/" # the output directory of the model
```
## start the train
* now we can start the train just by 
```

trainer = DefaultTrainer(cfg)

trainer.resume_or_load(resume=False)

trainer.train()
```
