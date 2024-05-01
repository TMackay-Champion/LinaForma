 <p align="left">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/d2577b0a12c168a8a8fe5a055eeb452f473757e5/images/logo_black.jpg", width="30%">
</p>

## Overview
These five codes perform a grid-search inversion, accompanied by bootstrap re-sampling, to determine which Pressure-Temperature (P-T) conditions best fit the rock of interest. The bootstrap re-sampling allows the user to determine the uncertainty in this result, as well as the sensitivity of the result to the uncertainty of the input parameters. An example of the ouputs can be found in [EXAMPLES](https://github.com/TMackay-Champion/LinaForma/tree/8486dc1820e7d5363f01476148a69ec186ac12be/EXAMPLES).

All of the codes require the same two inputs:
1) **forward_model.csv** = this CSV file contains the forward models for selected parameters (e.g., XMg in biotite, vol% garnet) created in software like THERIAK-DOMINO. These files can be created using scripts E2 or E3 (see [TheriakDomino_tools](https://github.com/TMackay-Champion/LinaForma/tree/8486dc1820e7d5363f01476148a69ec186ac12be/TheriakDomino_tools)). The codes use the same input format as script E4.
2) **measurements.csv** = this CSV file contains the measured values matching each of the parameters in the forward model file. It is important that the measurements are in the order given the the forward model file. There are two accepted formats for this file: A) list all the measurements for each parameter. These may be individual point measurements for example (e.g., [InputA]). B) provide the mean and standard deviation of each parameter (e.g., [InputB]). 


## Script L0_isopleths.m
This code allows the user to plot zones in P-T space defined by measured ranges of isopleth values for selected parameters. Zones of intersecting isopleths will be plotted.

<details>
<summary> L0 script inputs </summary>

 % ====== Data ======\
**model = '?'**\
 This is the CSV file for the forward models (e.g., inputs/forward_model.csv).
**measurements = '?'**\
This is the CSV file for the measurements (e.g., 'inputs/measurement_distributions.csv').

% ====== Data type ======\
**raw = ?**\
This is the type of format you have used for your input measurements file. If you have used InputA (see above), then raw = 1. If you have used InputB, then raw = 0.

% ====== Range of values (only applicable if raw = 0 ======\
**sd = ?**\
This parameter is only applicable if you have used InputA, and controls the range of isopleth values plotted (i.e., range = MEAN +/- sd * STANDARDDEVIATION).

% ====== PLOTS ======\
% PLOT 1 = percentage overlap plot
all1 = 1; % Do you want to plot all of the variables? 1 = YES, 0 = NO.
columns1 = [1,2,3,4]; % List the columns you want to plot, beginning from first variable. Only relevant if all = 0.

% PLOT 2 = individual isopleths
all2 = 1; % Do you want to plot all of the variables? 1 = YES, 0 = NO.
columns2 = [1,2,3,4]; % List the columns you want to plot, beginning from first variable. Only relevant if all = 0.

% PLOT 3 will use the contours from Plot2 and the max. percentage from 
% Plot1

</details>






### Outputs
The code outputs three plots: 
1) the percentage overlap plot. This plot shows the regions in P-T space which have the greatest number of overlapping variables. 
2) the overlapping contours plot. This plot shows which regions in P-T space coincide with the observed values for each variable of interest.
3) the contour plot. This 


## L1_error.m
This code allows the user to perform two tasks. Firstly (Part 1), the user can examine the pressure and temperature best-fit solution for each variable, and the associated uncertainty. 
This is performed for each value in the observations.csv file. Alternatively, the user can select to perform the analysis on the synthetic data in synthetic.csv.
This allows the user to examine the error associated with the observations, perhaps due to analytical or geological uncertainty.

Secondly (Part 2), the code allows to user to quantify the variation in the forward modelled value of each variable for a given temperature uncertainty at a selected pressure.
This allows the user to examine the amount of variation expected for a variable if there is model error of a known quantity.

### Outputs
The code outputs three plots: 
1) a boxplot for each variable showing how the temperature estimates vary between observations.
2) a boxplot for each variable showing how the pressure estimates vary between observations.
3) a boxplot for each variable showing how temperature uncertainty in the forward model may propagate to uncertainty in the predicted value.


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
3) "Synthetic bootstrapping" (option -1): in this option, the code lets the user decide on an appropriate mean and standard deviation for a Gaussian parametric bootstrap using the "synthetic.csv" file.

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/3aaf53b7526049c99e900da48fb3ca8a4db37272/images/L_bootstrap.png", width="90%">
</p>


### How many input variables should I use?
A grid-search is a non-linear inversion. The problem is overdetermined because the number of observations is in excess of of the number of model parameters. 
Each data point provides a constraint on the possible solution. By incorporating multiple constraints, overdetermined problems can identify and compensate for errors in the different variables.
This often results in a higher precision estimate than could be achieved by the individual variables alone. 

This is important when considering correlated variables. In an error-free system, it would be reasonable to remove all correlated variables. However, each variable in a petrological system is associated with a different level of error and the primary cause of this error will vary between different variables. 
One can readily imagine a situation in which two highly correlated variables result in different P-T estimates due to petrological or model error. Considering the two variables together allows the user to determine the most appropriate solution.
As such, we deem it acceptable to use variables which are predicted to be highly correlated in the forward model. 
However, phases which are common to one mineral should only be used together if a degree of freedom remains. For example, e.g., the composition of plagioclase can be described by Xan and Xab. You should only use 1 of these variables, to maintain a degree of freedom. 


### What bootstrapping method should I use?
The method of bootstrapping depends on your assumptions surrounding the sources of error in the system.
Non-parametric bootstrapping assumes that the underlying model generating the data is unknown or too complex to be accurately represented by a parametric distribution. 
Instead of making explicit assumptions about the model, non-parametric bootstrapping focuses solely on the observed data and its properties. This error can be examinied for each variable using the L1_error.m script (Part 1).
As such, we deem this bootstrap method to be most appropriate if we assume that the primary source of error is analytical and/or related to disequilbrium, geological uncertainty etc. 
In this case, the error associated with the observations is greater than associated model error. 

However, in some cases the primary source of error may be model error. In this case, the synthetic bootstrap option may be most suitable as it allows the user to select an appropriate mean and standard deviation. 
A standard deviation should be chosen which allows for a suitable degree of temperature and pressure uncertainty for the particular variable of interest. This can be chosen with the help of the L1_error.m script (Part 2).
We have generally found that a standard deviation equivalent to 20% of the mean value is more than enough.


### Code
1) model = '???'. This is the path to the forward model CSV file.
2) observations =  '???'. This is the path to the observations CSV file.
3) synthetic_data = '???'. This is the path to the synthetic data. It will only be used if bootstrap_type = -1.
4) bootstrap_type = ?. This controls the type of bootstrapping you perform. Parametric = 1, non-parametric = 0, synthetic Gaussian = -1
5) it = ?. This is the number of bootstrap re-samples used. The more the merrier!
6) confidence_level = ?. This is the confidence level represented by the ellipse on the final plot.
7) boxplots = ?. This controls whether you plot boxplots or histograms of temperature and pressure variability. 1 = boxplot, 0 = histogram
8) Nbins = ?. This is the number of histogram bins used for the plot. Only applicable if boxplots = 0.

### Outputs
The code outputs four plots:
1) a grid showing the extent and resolution of the forward models.
2) the grid-search solution with uncertainty analysis.
3) a plot showing all of the best-fit solutions overlain on the overlapping contour plot of L0_isopleths.m script.
4) a 2D histogram of the best-fit solutions.


## L3_residuals.m
This code allows the user to examine the difference between the forward model predicitions and the observed or synthetic data at chosen P-T points.
This can be used to check how well different variables match the best-fit solution. When accompanied by textural evidence or large enough datasets, this process 
could be used to examine disequilibrium and/or model error.

### Outputs
This code outputs boxplots for each variable showing the distribution of observations and the forward model predicted value.

## L4_sensitivity.m
This code examines how sensitive the best-fit solutions are to uncertainty in the observations. To do this, the code bootstrap re-samples one variable at a time while keeping
all the other variables constant. The resulting variation in the best-fit solutions can then be directly attritubted to the uncertainty on that particular variable. 

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/3aaf53b7526049c99e900da48fb3ca8a4db37272/images/L_sensitivity.png", width="90%">
</p>

### Outputs
This code outputs two "tornado" plots, one for temperature and one for pressure.
These plots display how the variation in a particular variable influences the best-fit solutions relative to a given best-fit solution (ideally the output of the L2_inversion.m script).
