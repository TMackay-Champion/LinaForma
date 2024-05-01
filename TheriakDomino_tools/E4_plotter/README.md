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
<img src="https://github.com/TMackay-Champion/LinaForma/blob/8f640e267e617b008a97176b4d2882e7dd0b87d7/images/E4a_output.png", width="60%">
</p>

<details>
<summary> E4a script input </summary>

% ====== Data ======\
**model = '?'**\
This is the file name of the forward model input data.

% ====== PLOTS ======\
% Plot stability field of particular phase?\
**phase = ?**\
Do you want to plot phase stability? 1 = YES; 0 = NO.\
**mineral = '?'**\
This corresponds to the name given to the mineral in the database.\

% Plot stability field of particular assemblage?\
**field = ?**\
Do you want to plot equilibrium field stability? 1 = YES; 0 = NO.\
**f_no = ?**\
This corresponds to the field number provided by DOMINO in pixa.txt.

% Plot pseudosection and variance?\
*If you click on the pseudosection, MATLAB will print the equilibrium phase assemblage*\
**assemblage = ?**\
Do you want to plot the pseudosection? 1 = YES; 0 = NO.\
**components = ?**\
Give the number of components of the system for calculating the variance.
</details>

## E4b_variables.m
This code allows the user to plot heatmaps and contour plots for any CSV file with a structure like the image above. The code allows the user to overlay up to 3 contour plots and 1 heatmap onto one figure.

### E4b data input
The code needs a CSV file containing the forward model data. The file must have the structure outlined above.

### E4b script details
% ====== Data ======\
**model = '?'**\
This is the file name of the forward model input data.

% ====== PLOTS ======\
The code input is then split into four sections: (1) Heatmap input, (2) Contour 1 input, (3) Contour 2 input, and (4) Contour 3 input. For each section, you need to 
confirm whether you want to plot that data (do_you_want_to_include = ?). Then you must decide which column of the input file you want to plot (column = ?). Finally, for the contour plots you must decided whether you want to use the MATLAB
automated contours, or plot your own (auto = ?). If you select 0, then you need to fill out the max_contour_line, min_contour_line, and contour_step variables with appropriate values. Finally, you will want to added an appropriate legend to your plot.

e.g.,
 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/c4dbdbf2da83e7abcd6a58525acd3cde3b27b87e/images/E4b_code_input.png", width="80%">
</p>


### E4b script output
The output plots will be saved as pdf files to the FIGURES folder. 

 
