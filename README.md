# Author 
### ahmed hussein ahmed 
---
# table of content 


---
# problem defination 
creating a pipeline for table recognition and return a csv  contain the text of the table in the image with respect to the cells in the table 
---
# solution 
1. training east on cell detection using IBM dataset for cell det
2. using the best trained model on table and lines
3. merge all of them to create pipeline getting image and retun text of the table 
---
# requirments 
* [East requirments]()
* [IBM train requirments]()
* xlsxwriter for python 
---
# Run it 
1. using my config file [config]()
```
branch=master


test_data_tables=/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-IBM-Dataset/test_data

test_data_cells=/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-table/EAST-master/output_table_cropped

test_data_lines=/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-table/EAST-master/output_table_cropped


src_path_table_line=/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-table/EAST-master

src_path_cell=/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-angle-adj/EAST-master


output_path_table_line=/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-table/EAST-master/exps/checkpoints

output_path_cell=/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-angle-adj/EAST-master/exps/checkpoints/

inference_path_tables=/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-table/EAST-master/output

inference_path_lines=/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-table/EAST-master/lines_dir

inferance_path_cells=/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-table/EAST-master/cells_dir


# this belongs to the main #
output_table_cropped=/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-table/EAST-master/output_table_cropped

output_cropped_line=/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-table/EAST-master/output_cropped_line

cells_dir=/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-table/EAST-master/cells_dir

lines_dir=/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-table/EAST-master/lines_dir

output_p=/media/res12/30aa9699-51c5-4590-9aa2-decf88416771/OCR/OCR-table/EAST-master/output
```
* test_data_tables=path to the directory contain image we want to predict table inside
* test_data_cells=path to the directory contain image we want to predict cells inside
* test_data_lines=path to the directory contain image we want to predict lines inside
---
* src_path_table_line= the path to the directory contain src files of the table/lines/main.py 
* src_path_cell= the path to the directory contain src files of the cell detection
---
* output_path_table_line= the path to the line/table model checkpoints directory
* output_path_cell=  the path to the cell model checkpoints directory
---
* inference_path_tables= the path to the output directory for table prediction 
* inference_path_lines= the path to the output directory for line prediction 
* inferance_path_cells= the path to the output directory for cell prediction 
---
* output_table_cropped=the path to the cropped table image directory (used for main.py)
* output_cropped_line=the path to the output for cropped line image directory (used for main.py)
* cells_dir=this path should be like inferance_path_cells (used for main.py)
* lines_dir=this path should be like inference_path_lines (used for main.py)
* output_p=this path should be like inference_path_tables (used for main.py)
---
* Note that we use 2 src paths because the model in table/line build is diffrent from the cell model
* src folders for table/lines/main [src table/lines/main.py]()
* src folder for cell [src cells]()
---
# Alogrithm Phases
the algorithm is made of mainly 4 phases
---
## Phase 1 
1. predict the table using the best model for table predict [model location]()
2. this will return output image of the predict and .txt file contain the table  inside the image, output must be in [output]()
3. our interest is the .txt file that contain the table 
---
## Phase 2
1. getting the .txt that contain the table inside the image 
2. crop the table from the image using [main.py]()
3. write the croped image in directory named [output_table_cropped]()
---
## Phase 3
1. predict the cells using the model which was trained on IBM over the table cropped image, output will be predicted img and .txt file contain the coordinates of the cells inside the table, write the output in [cells_dir]().
2. predict the lines using the best model over the table cropped image, output will be predicted img and .txt file contain the coordinates of the lines inside the table, write the output in [lines_dir]()
---
## Phase 4 
1. using the [main.py]() again to connect the lines with cells using the .txt files inside the [cells_dir]() and [lines_dir]()
2. add to the line coordinates information the line row number, line col number and it's index in this row-col
3. crop the lines from the table cropped image and write the cropped line with the name of the line row_col_index.png, in the directory [output_cropped_line]()
---
## Phase 5 
1. using the [main.py]() to create xcl sheet
2. reading every image in [output_cropped_line]() and put it in cell inside the sheet with respect to the image name (row,col,index)
---
# Phase details 
## Phase 1 
1- using the best model to predict  the tables 
2- output will be .txt file contain the cooridnates of the tables as 4 points (upper left , upper right , lower right , lower left )  ex: 0,0,10,0,10,10,0,10
---
## Phase 2 
* using [main.py]() phase_1() function
1.  
```
def phase_1():
    '''
    write a cropped image in the output_table_cropped directory,
    read the images from output directory
    read the text from output directory
    :return
```
* reading image with function
2. 
```
def read_image_directory(path):
    '''
    getting image directory, read every .png file inside it 
    :param path: path to the directory
    :return: list contain the paths to the .png files inside the directory 
    '''
```
* read the .txt with function 
3. 
```
def read_text_directory(path):
    '''
    getting text file directory, read every .txt file inside it
    :param path: path to the directory
    :return: list contain the paths to the .txt files inside the directory
    '''
```
* get the informations from the .txt file 
4.
```
def get_table_dimensions(path):
    '''
    taking a path to .txt file contain the table coordinates,
    the text contain xmin,ymin,xmax,ymin,xmax,ymax,xmin,ymax
    :param path: path to .txt file contain the table coordinates
    :return: table xmin,ymin,xmax,ymax
    '''
```

* crop the table from the original image 
5. 
```
def crop_image(image,y_min,y_max, x_min,x_max,up_ratio=1,left_ratio=1):
    '''
    :param image: the original image we want to crop
    :param y_min: start point y of the cropped image
    :param y_max: end point y of the cropped image
    :param x_min: start point x of the cropped image
    :param x_max: end point x of the cropped image
    :param up_ratio: will be used in feature release
    :param left_ratio: not used right now
    :return: cropped image 
    '''
```
* write the cropped image with open cv
6. cv2.imwrite()
---
## Phase 3
1- line predict 
  1- using the best model to predict  the lines 
  2- output will be .txt file contain the cooridnates of the line as 4 points (upper left , upper right , lower right , lower left )  ex: 0,0,10,0,10,10,0,10
2- cell predict 
  1- using the model trained on IBM 
  2- output will be .txt file contain the cooridnates of the cell as 4 points (upper left , upper right , lower right , lower left ) and the row_number,col_number ex: 0,0,10,0,10,10,0,10,0,1 // in this example the row number = 0, the col number = 1 for this cell
---
## Phase 4
