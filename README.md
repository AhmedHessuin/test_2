# Common Module (CM)
## Installation
* python = 3.8.0
* to install requirments run ```pip install -r requirments.txt```
## Inference 
to inference using CM you need a ```.ts``` detectron model and ```config file``` in json format 
let's start with the config file 
### Config file
#### KEYS

| Key Name      | Description   | Data type     | Example       | TIP           |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| number_of_fields  | contain the number of fields expected from the model  | int  | 20  | -  |
| side_labels  | if we have ID DL and BR each one of them we consider as a side, thus we put the labels represent this sides, if we didn't find any side label while inference the inference will stop| list contain int  | [ 0, 10]  | for system without Side labels, put all the models label in this Key, so that if the model found any field, process continue |
| non_label  | a field that we consider as none, if we found this field and the confidance of this field larger than the side label field found, the process will stop and check the next image   | int  | 23  | if you don't have this field but it -1  |
| fields_name  | contain the name for each field, so we can save the result with this specified names  | dictionary key[number]:value[string]  | "0": "ID","1": "ID-Number", | -  | 
| side_labels_fields  | for each side we have some fields for this side only, if we found another field doesn't blong to this side we ignore this field   |dictionary key[number]:value[list of ints]  | "0": [1,2,3],"4":[5,6]  | if you don't have a side, you can put all fields inside all fields, example : "0":[0,1,2,3,4,5],"1":[0,1,2,3,4,5],..."5":[0,1,2,3,4,5] |
| rotation_line  | fields we consider reprentative for the card rotation for example if we have in the ID first name, ID number; we expect the first name field to have y min smaller than the id number, so in this Key we put all fields we expect to find first for each side from top to bottom, with respect to the order in this list   | dictionary key[number]:value[list of ints]  |  "0": [2,3,4]  |  if you don't have a side, you can put all fields inside all fields, example : "0":[0,1,2,3,4,5],"1":[0,1,2,3,4,5],..."5":[0,1,2,3,4,5] |
| Content Cell  | Content Cell  | Content Cell  | Content Cell  | Content Cell  |
| Content Cell  | Content Cell  | Content Cell  | Content Cell  | Content Cell  |

flip_lines
flip_lines_bool
target_list
template_list
template_list_bool
multi_label_instances
side_system
input_size_min_max
trans_height_trans_width
out_border_threshold
field_height_width_threshold
card_horz_vert_type
