 <p align="left">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/d2577b0a12c168a8a8fe5a055eeb452f473757e5/images/logo_black.jpg", width="30%">
</p>

These four codes perform a grid-search inversion, accompanied by bootstrap re-sampling, to determine which pressure-temperature conditions best fit the rock of interest. The bootstrap re-sampling allows the user to determine the uncertainty in this result, as well as the sensitivity of the result to uncertainty in the input variables.
All of the codes require the same two inputs (or three if you want to use synthetics):
1) forward_model.csv = this CSV file contains the forward models created in software like THERIAK-DOMINO. If you have used scripts E2 or E3, the CSV file will already be in the correct format. The codes use the same input format as Code E4.
2) observations.csv = this CSV file contains all of the real measured values for each of the variables contained in the forward_model.csv file.

## L1_isopleths.m
This code allows the user to plot intersecting isopleths between multiple different variables over the entire area of P-T space defined by the forward models.

### Outputs
The code outputs three plots: 
1) the percentage overlap plot. This plot shows the regions in P-T space which have the greatest number of overlapping variables. 
2) the overlapping contours plot. This plot shows which regions in P-T space coincide with the observed values for each variable of interest.
3) the contour plot. This 




## L2_inversion.m
This code performs a bootstrap re-sampling of the observation data, and a grid-search inversion to find the best-fit solution for each bootstrap resample. These are combined to give the user a 
best-fit pressure-temperature estimate for the system of interest and an uncertainty on that estimate.

The grid-search inversion works by calculating the difference/misfit between the observed data and the forward model data at each P-T point in the forward model CSV file. The best-fit solution is the P-T point with the lowest misfit value. 
 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/21be9b7e2e964cd5b8098782d4a1419307e4cc2d/images/L_overview1.png", width="65%">
</p>

The bootstrap re-sampling is used to examine the uncertainty of this result. 


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