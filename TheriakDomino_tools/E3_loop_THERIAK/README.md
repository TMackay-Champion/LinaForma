# E3_loop_THERIAKDOMINO
This code allows the user to run THERIAK in a loop and save the results to a CSV file. The pressure-temperature path can be changed in the PT_path.csv file.

The package is split into two parts:

## 1) E3a_create_grid.m
If the user wants to run THERIAK in a P-T grid, this code allows the user to create an appropriate PT_path.csv file. The dimensions of the grid can be chosen in the input section of the code.

## 2) E3b_automate_THERIAK.m
This code runs THERIAK at the P-T points given in the PT_path.csv file. 

### Inputs
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
3) assemblage_file = 'pixa.csv'. This is the CSV file created above.
4) min_T = ??. This is the minimum temperature over which DOMINO was run. This information is contained in pixinfo.txt.
5) max_T = ?? This is the maximum temperature.
6) min_P = ??. This is the minimum pressure.
7) max_P = ??. This is the maximum pressure.
8) ix = ??. This is the number of steps between the min. and max. temperatures.
9) iy = ??. This is the number of steps between the min. and max. pressures.


## Outputs
The code will output a CSV file containing all of the DOMINO data. It will look like this:

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/6c1cacc5b0e87a0f0c54d06fd7c62bfe3e18b36f/images/E2_output.png", width="80%">
</p>