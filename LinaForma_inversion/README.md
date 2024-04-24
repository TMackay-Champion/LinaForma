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

The grid-search inversion works by calculating the difference/misfit between the observed data and the forward model data at each P-T point in the forward model CSV file dataset. The best-fit solution is the P-T point with the lowest misfit value. 
It is important that the grid spacing is dense enough to ensure the minimum misfit is not missed between the grid spaces. 
 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/3aaf53b7526049c99e900da48fb3ca8a4db37272/images/L_gridsearch.png", width="90%">
</p>

Bootstrap resampling refers to random re-sampling of the original dataset, with replacement. This re-sampling is used to examine the uncertainty of the best-fit solution. Uncertainty may be introduced through model error, mesasurement error, disequilibrium and other such processes. 
Using bootstrapping, we can examine the effects of these errors on our P-T solution. The codes allow three different styles of re-sampling for each variable in turn:
1) Parametric bootstrapping (option 1): this assumes that the data follow a specific parametric distribution, such as the normal distribution. 
Bootstrap samples are chosen by randomly drawing observations from the assumed distribution with replacement. The LinaForma code assumes a normal distribtuion, and calculates an appropriate mean and standard deviation from the data given in observations.csv.
2) Non-parametric bootstrapping (option 0): this option re-samples the original data mulitple times and calculates the mean from each re-sampling. These mean values are used in the grid-search.
3) "Synthetic bootstrapping" (option -1): in this option, the code lets the user decide on an appropriate mean and standard deviation for a parametric bootstrap using the "synthetic.csv" file.

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/3aaf53b7526049c99e900da48fb3ca8a4db37272/images/L_bootstrap.png", width="90%">
</p>


### Code

### Outputs



## L3_residuals.m
This code allows the user to run THERIAK in a loop and save the results to a CSV file.


### Code

### Outputs


## L4_sensitivity.m
This code

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/3aaf53b7526049c99e900da48fb3ca8a4db37272/images/L_sensitivity.png", width="90%">
</p>


### Outputs