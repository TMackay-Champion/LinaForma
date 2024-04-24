# E4_plotter
These two codes provide tools for plotting data from any CSV file, including those created for THERIAK-DOMINO in scripts E2 and E3.

## Inputs
Both of the codes require input data in the form of a CSV file. The X axis values must be given in the first column, the Y axis values must be given in the second column. If you have used the scripts E2 or E3, the CSV files will already be in the correct format. An example can be seen below:

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/2ef1d08e30a91355a64d9770fca83716c708e314/images/E4_input.png", width="60%">
</p>

## E4a_fields.m
This code allows the user to plot phase stability fields, assemblage stability fields, the variance, and an interactive pseudosection. The output plots will be saved as pdf files to the FIGURES folder. Currently this code only works for users who have used script E2 to collate the files from DOMINO into a standardised CSV file because the columns 'Field', 'Assemblage' and 'Phases' are required.

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

% HEATMAP INPUT
do_you_want_to_include4 = 1;
column4 = 5;
var = 'Variance'; % This is the label for the heatmap

% CONTOUR 1 INPUT
do_you_want_to_include1 = 1; % 1 = Yes, 0 = No
column1 = 3; % this is the column of your Excel sheet which you want to plot
auto1 = 0; % 1 = MATLAB chooses the contours, 0 = you need to choose using the options below

if auto1 == 0
    max_contour_line1 = 1.5; % Change these values if you have selected 0 above
    min_contour_line1 = 1.3; % Change these values if you have selected 0 above
    contour_step1 = 0.01; % Change these values if you have selected 0 above
end

etc.

% LEGEND
leg  = {'HEATMAP','Column1','Column2','Column3'}; 


### Output
The output plots will be saved as pdf files to the FIGURES folder. 

 