# LinaForma inversion
These four codes perform a grid-search inversion, accompanied by bootstrap re-sampling, to determine which pressure-temperature conditions best fit the rock of interest. The bootstrap re-sampling allows the user to determine the uncertainty in this result, as well as the sensitivity of the result to uncertainty in the input variables.
All of the codes require the same two inputs (or three if you want to use synthetics):
1) forward_model.csv = this CSV file contains the forward models created in software like THERIAK-DOMINO. If you have used scripts E2 or E3, the CSV file will already be in the correct format. The codes use the same input format as Code E4.
2) observations.csv = this CSV file contains all of the real measured values for each of the variables contained in the forward_model.csv file.
3) synthetics.csv = this CSV file is optional. It contains the mean and standard deviation of each variable in the forward_model.csv file.

The codes compare the observational data (or synthetics) with the forward model data, and finds the pressure-temperature point at which there is the least misfit between the two datasets. This is known as the best-fit solution for the system of interest.


## L1_isopleths.m
This code allows the user to plot intersecting isopleths between multiple different variables. 

### Code

### Outputs

## L2_inversion.m
This code allows the user to collate the outputs of DOMINO (a folder containing many text files) into a CSV file containing all the information in P-T order.


### Code

### Outputs



## L3_residuals.m
This code allows the user to run THERIAK in a loop and save the results to a CSV file.


### Code

### Outputs


## L4_sensitivity.m
This code

### Code

### Outputs