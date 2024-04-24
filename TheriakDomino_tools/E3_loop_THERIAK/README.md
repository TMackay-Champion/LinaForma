# E3_loop_THERIAK
This code allows the user to run THERIAK in a loop and save the results to a CSV file. The pressure-temperature path can be changed in the PT_path.csv file.

The package is split into two parts:

## 1) E3a_create_grid.m
If the user wants to run THERIAK in a P-T grid, this code allows the user to create an appropriate PT_path.csv file. The dimensions of the grid can be chosen in the input section of the code.

## 2) E3b_automate_THERIAK.m
This code runs THERIAK at the P-T points given in the PT_path.csv file. 

### Inputs
1) The P-T path of interest must be specified in the PT_path.csv file.
2) Please create a folder (perhaps called THERIAK_automation) which contains all of the THERIAK-DOMINO programs, a THERIN file, and the database of interest.

### Code (E3b_automate_THERIAK.m)
1) directory = 'path/to/folder/THERIAK_automation/'. This must include the full path to the folder containing your THERIAK-DOMINO programs, THERIN, and database.
2) database = 'td_pelite.txt'. Please give the name of your database file.
3) path = 'PT_path.csv'. This should be a csv file with the P-T path info. Grids can be created using script E3a.

### Outputs
The code will output a CSV file containing all of the THERIAK data. It will look like this:

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/b17f80121984bd8460ea58220c26b06a878bd627/images/E3_output.png", width="80%">
</p>