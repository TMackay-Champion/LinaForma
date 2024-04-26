# E4_plotter
These two codes provide tools for plotting data from any CSV file, including those created for THERIAK-DOMINO in scripts E2 and E3.

## Inputs
Both of the codes require input data in the form of a CSV file. The X axis values must be given in the first column, the Y axis values must be given in the second column. If you have used the scripts E2 or E3, the CSV files will already be in the correct format. An example can be seen below:

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/2ef1d08e30a91355a64d9770fca83716c708e314/images/E4_input.png", width="60%">
</p>

## E4a_fields.m
This code allows the user to plot phase stability fields, assemblage stability fields, the variance, and an interactive pseudosection. The output plots will be saved as pdf files to the FIGURES folder. Currently this code only works for users who have used script E2 to collate the files from DOMINO into a standardised CSV file because the columns 'Field', 'Assemblage' and 'Phases' are required.

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/8f640e267e617b008a97176b4d2882e7dd0b87d7/images/E4a_output.png", width="40%">
</p>

## E4b_variables.m
This code allows the user to plot heatmaps and contour plots for any CSV file with a structure like the image above. The code allows the user to overlay up to 3 contour plots and 1 heatmap onto one figure.

### Inputs
The code needs a CSV file containing the data. The file must have the structure outlined above.

### Code
1) input_file = 'forward_models.csv'. This is the file name of the input data.

The code input is then split into four sections:Heatmap input, Contour 1 input, Contour 2 input, and Contour 3 input. For each section, you need to 
confirm whether you want to plot that data (do_you_want_to_include = ?). Then you must decide which column of the input file you want to plot (column = ?). Finally, for the contour plots you must decided whether you want to use the MATLAB
automated contours, or plot your own (auto = ?). If you select 0, then you need to fill out the max_contour_line, min_contour_line, and contour_step variables with appropriate values. Finally, you will want to added an appropriate legend to your plot.

e.g.,
 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/c4dbdbf2da83e7abcd6a58525acd3cde3b27b87e/images/E4b_code_input.png", width="80%">
</p>


### Output
The output plots will be saved as pdf files to the FIGURES folder. 

 