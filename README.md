# OCR cell detection 





Author: Ahmed Hussein Ahmed

Supervisor: Hazem Mamdouh

  


# Installation 

	Downloading the data from IBM [Link](https://developer.ibm.com/technologies/artificial-intelligence/data/fintabnet/)
	Click get this [dataset](https://dax-cdn.cdn.appdomain.cloud/dax-fintabnet/1.0.0/fintabnet.tar.gz )
	For sample you can find it in [run dataset notebooks](https://dataplatform.cloud.ibm.com/analytics/notebooks/v2/f57cf3f6-e972-48ff-ab7b-3771ba7b9683/view?access_token=317644327d84f5d75b4782f97499146c78d029651a7c7ace050f4a7656033c30)  

	Extract the .tar file

Data 
	The data contain many pdfs file, each file contain only 1 page, each page contain 1 or more table and at least 1 cell in each table. the annotations file is jsonl format file, 1 file for all pdfs, annotation for table is category=1 and the cell is category=2. 

IBM assumptions in the data annotation are: 
	Tables must contain cells inside it 
	No cell exists outside of the table 
	Each pdf is made of 1 page with at least 1 table inside it 

Process on the data to get tables as image 
The IBM provide a notebook to convert the pdf into image and draw GT on the image for the tables and cells. 
I modified the notebook script to extract the tables from the pdf as images and extract the cells coordinate inside each table relative to the cropped image. The file can be found in main.py, the code is commented for more information.

The main.py need the IBM data to be in directory “./fibtabnet/pdf/” relative to the main.py path
The main.py generate a cropped image in .png format and .txt file contain the coordinates of the cells inside the table, the output need directory named “output” to be in the same path of the main.py 

 
Train East 
	Taking the output path from the main.py and use it as train data path for East model, using the model which predict the lines only not the model which predict the tables and lines. Repo link EAST_MASTER.
Training on 1300 table only with 200 k steps, using learning rate = 0.001, the model achieved a satisfying result. 


Inference with east 
	The outputs from east model are:
	Score map: contain the confidence on each pixel that is inside a cell
	Geo map: contain the model predict of the RBOX edges distance for this pixel

Post processing 
The outputs from east model are preprocessed in the following pipeline:
Phase 1 generating the cell box on the image
	Taking the score map and apply threshold = 95%, to get the most confidence pixels	
	Get contours on the score map with open cv
	For each contour split it into 2 areas (1/8  of the contour are on the right and 1/8  of the contour area on the left)
	For each area get 5 pixels which contain the best score map values on this area, if number of pixels in this area less than 5; pad it
	Now we have 10 pixels correspond to the contour.
	Using ICDAR restore boxes function to get the box that contain these points using the geo map
	Now we have 10 boxes for each contour in the score map, using hussein_nms instead of ramzy_nms to get the final number of boxes in the whole image
	hussein_nms: using the nms for all boxes, I didn’t generate 1 box for every 10 boxes like ramzy_nms, the output is much better than using ramzy_nms
	After applying the hussein_nms we now have a certain number of boxes each box represents a cell in the table 
 
Phase 2 getting rows and columns 
	There are 1 main function to get rows and cols named “get_row_col” in the inference file 
	The function takes the boxes then apply 4 sub functions 
	get_row: sort the boxes with the respect of y axis, check interval overlap in the y coordinate for every box and the other boxes, if there are interval overlap between them, just add the boxes together in a list, by doing that we can get the rows as list contain [[row_1],[row_2]], note that sometimes the row contain only 1 box  this box is considered as row and get appended to the rows list [ [row_1],[row_2],[box_23]]
	get_col: using the same methodology used in “get_row” but with 2 different design
	ignore the row that contain only 1 box
	consider the row that contain only 1 box
the first one is good for visualization only not in practical as for example the col can be  a type or common information between the rest of the cols, thus ignore it, but when generating the output table with docgen this data will be forgotten.
2009	2008


The second algorithm is good for generating the docgen as it will make a cell in a separated 
row and with col = the col of 2009 
October 
2009	2008

	get_row_cell: this sub function is exactly the same as “get_row” except it generate also a list contain contains dictionary for every box in the format 
{“box”:<the coordinates>,”row_num”:< row number>, “col_num”:< col number>} for every box, and “get_row_cell” modify the “row_num” for every box, thus we now know where is the cell ( the information of the box) and in which row it’s in (the information of the “row_num”).
	 get_col_cell: takes the output list of dictionaries from “get_row_cell” and apply the same algorithm as “get_col” but it also modify the dictionary by adding the “col_num“ for every box 
now we have for every cell in which row it’s inside and in which col it belongs to, with this 2 information we can generate the table.
Phase 3 visualization 
Right now, I visualize with the out information of the “get_row” and “get_col” as for loop iterate 	

	
