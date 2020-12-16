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
## Phase 0
1. predict the table using the best model for table predict [model location]()
2. this will return output image of the predict and .txt file contain the table  inside the image, output must be in [output]()
3. our interest is the .txt file that contain the table 
---
## Phase 1
1. getting the .txt that contain the table inside the image 
2. crop the table from the image using [main.py]()
3. write the croped image in directory named [output_table_cropped]()
---
## Phase 2
1. predict the cells using the model which was trained on IBM over the table cropped image, output will be predicted img and .txt file contain the coordinates of the cells inside the table, write the output in [cells_dir]().
2. predict the lines using the best model over the table cropped image, output will be predicted img and .txt file contain the coordinates of the lines inside the table, write the output in [lines_dir]()
---
## Phase 3 
1. using the [main.py]() again to connect the lines with cells using the .txt files inside the [cells_dir]() and [lines_dir]()
2. add to the line coordinates information the line row number, line col number and it's index in this row-col
3. crop the lines from the table cropped image and write the cropped line with the name of the line row_col_index.png, in the directory [output_cropped_line]()
---
## Phase 4 
1. using the [main.py]() to create xcl sheet
2. reading every image in [output_cropped_line]() and put it in cell inside the sheet with respect to the image name (row,col,index)
---
# Phase details 
## Phase 0 
1. using the best model to predict  the tables 
2. output will be .txt file contain the cooridnates of the tables as 4 points (upper left , upper right , lower right , lower left )  ex: 0,0,10,0,10,10,0,10
---
## Phase 1 
1. using [main.py]() phase_1() function
```
def phase_1():
    '''
    write a cropped image in the output_table_cropped directory,
    read the images from output directory
    read the text from output directory
    :return
```
2. find image with function
```
def read_image_directory(path):
    '''
    getting image directory, read every .png file inside it 
    :param path: path to the directory
    :return: list contain the paths to the .png files inside the directory 
    '''
```
3. find the .txt with function 
```
def read_text_directory(path):
    '''
    getting text file directory, read every .txt file inside it
    :param path: path to the directory
    :return: list contain the paths to the .txt files inside the directory
    '''
```
4. get the informations from the .txt file 
```
def get_table_dimensions(path):
    '''
    taking a path to .txt file contain the table coordinates,
    the text contain xmin,ymin,xmax,ymin,xmax,ymax,xmin,ymax
    :param path: path to .txt file contain the table coordinates
    :return: table xmin,ymin,xmax,ymax
    '''
```

5. crop the table from the original image 
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
6. write the cropped image with open cv
---
## Phase 2
1. line predict 
    1. using the best model to predict  the lines 
    2. output will be .txt file contain the cooridnates of the line as 4 points (upper left , upper right , lower right , lower left )  ex: 0,0,10,0,10,10,0,10
2. cell predict 
    1. using the model trained on IBM 
    2. output will be .txt file contain the cooridnates of the cell as 4 points (upper left , upper right , lower right , lower left ) and the row_number,col_number ex: 0,0,10,0,10,10,0,10,0,1 // in this example the row number = 0, the col number = 1 for this cell
---
## Phase 3
* this is the core phase in which we connect the lines with cells together 
1. getting the .txt of the cells and the .txt of the lines for a certin image 
2. read the .txt of the cells with
```
def get_cells_dimensions(path):
    '''
    taking the path of .txt file output from the cell prediction, contain xmin,ymin,xmax,ymin,xmax,ymax,xmin,ymax,row,col
    :param path: path to .txt file
    :return:list contain dictionaries each dictionary contain "box" [ xmin,ymin,xmax,ymax], "row_num": row , "col_num": col:
    "lines_index": the number of lines inside this cell initially it will be 0, "num_lines":number of lines in this cell
    initially it will be 0
    '''
```
3. read the .txt of the lines with 
```
def get_lines_dimensions(path):
    '''
    taking a path to .txt file contain the line coordinates,
    the text contain xmin,ymin,xmax,ymin,xmax,ymax,xmin,ymax
    :param path: path to .txt file contain the lines coordinates
    :return: list of list each list contain [xmin,ymin,xmax,ymax]
    '''
```
4. sort the lines based on y axis to make sure that when we index them in the cell (line 0 in cell 1 , line 1 in cell 1 ) it's right index
```
def sort_boxes_y_axis(boxes):
    '''
    description : sort the contours from left to right based on the ymin
    :param contours: list of contours
    :return: list of sorted contours
    '''
```

5. modify the lines we got from get_lines_dimensions with 
```
for line in lines:
    lines_dict.append({"box": line, "row_num": None, "col_num": None, "index": None, "intersected_area": 0})
```

6. match the lines with the cells 
```
        for cell in cells:
            for line in lines_dict:
                match_lines_with_cell(cell, line)

```
```
def match_lines_with_cell(cell,dict_of_the_line):
    '''
    getting a cell dictionary and a line dictionary
    check interval overlap between the cell and the line
    if there area overlap between the cell and the line, then this line take the row_num of the cell and the col_num
    of this cell, and it's index = the cell lines_index, and add the line_index of the cell by 1.
    store the intersected area in the line, thus if the line is intersected again with another cell, check the old and
    the new intersection area and if the new cell has larger intersection area, change the row_num, col_num and the
    index for this line
    :param cell: cell dictionary {"box":[int(x),int(y),int(x2),int(y2)],"row_num":row_num,"col_num":col_num,"lines_index":0,"num_lines":0}
    :param dict_of_the_line: line dictionary {"box":line,"row_num":None,"col_num":None,"index":None,"intersected_area":0}
    :return: NONE
    '''
```
```
def interval_overlap(first_element_coordinate_min, first_element_coordinate_max,
                     second_element_coordinate_min, second_element_coordinate_max):
    '''
   description : this check if there is an intersection between 2 intervals as x1,x2 is the first interval and x3,x4 is
   the second interval
   :param first_element_coordinate_min: the first interval min value, type(int)
   :param first_element_coordinate_max: the first interval max value, type(int)
   :param second_element_coordinate_min: the second interval min value, type(int)
   :param second_element_coordinate_max: the second interval max value, type(int)
   :return: number if there is an intersection, 0 if there is no intersection ,type(int)
   '''
```
7. find out the number of lines inside each cell 
```
 for cell in cells:
            for line in lines_dict:
                if line["row_num"] == cell["row_num"] and line["col_num"] == cell["col_num"]:
                    cell["num_lines"] += 1
```
8. if we found cell with no lines inside it, maybe the line detection detected 2 column as 1 line thus we need to consider this cell as a line 
9. because of point 8 we need to break the overlapped line 
```
def break_overlaped_lines(line1,line2):
    '''
    taking 2 dictionaries of lines line1 and line2, check interval overlap between them
    check if the intersection area between them > 0.9 of the small line area, if this happens, modify the large line
    with respect to the small line
    :param line1: line dictionary 
    :param line2: line dictionary 
    :return: NONE
    '''
```
10. now we have the perfect output, crop every line from the image and write it with the name like line_row,line_col_line_index.png in croped line directory
---
## Phase 4
* in this phase we create and wirte inside the excel sheet 
1. taking the path to every image in the croped line directory 
2. from the image name find the row and col we should put it inside in the excel sheet 
3. insert this image into the excel sheet 
---
