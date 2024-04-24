# E2_collate_DOMINO
This code allows the user to collate the outputs of DOMINO (a folder containing many text files) into a CSV file containing all the information in P-T order.

## Inputs
1) The user must provide a folder containing all of the text files output by DOMINO. In our example, it is called "_dommap".
2) The user MUST create a CSV file (named 'pixa.csv') containing all of the information in the pixa.txt file. This helps to standarised the input format for the code. The pixa.csv file should be put in the DOMINO output folder. The steps are outlined below:

<p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/6c1cacc5b0e87a0f0c54d06fd7c62bfe3e18b36f/images/E2_pixaStep1.png", width="80%">
</p>

<p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/6c1cacc5b0e87a0f0c54d06fd7c62bfe3e18b36f/images/E2_pixaStep2.png", width="80%">
</p>


## Code (E2_collate.m)

1) domino_folder = '???'. This is the name of the folder containing all the DOMINO text files. In our case, it is called _dommap.
2) output_file = '???'. This is the file name for the output CSV file (e.g., "forward_models.csv").
3) assemblage_file = 'pixa.csv'. This 

% Pix info
min_T = 650;
max_T = 750;
min_P = 3000;
max_P = 8000;
ix = 100;
iy = 100;

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/66936a954cb7b7d4c4d1d81afe6fd91cb4c2fc73/images/E1_input.png", width="80%">
</p>

## Code (E1_comp.m)
1) composition = '???'. This should be the name of the input file containing the bulk composition information (e.g., "input_comp.csv").

2) sample_name = '???'. Give your sample a name!

3) TD_output = '?'. This controls the output of THERIAK-DOMINO (see the program documentation for more detail).

## Outputs
The code will output a CSV file containing all of the DOMINO data. It will look like this:

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/6c1cacc5b0e87a0f0c54d06fd7c62bfe3e18b36f/images/E2_output.png", width="80%">
</p>