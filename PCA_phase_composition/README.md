# PCA phase composition
This code allows the user to perform Principal Component Analysis (PCA) and K-means clustering on phase compositional data. This workflow allows the user to assess whether there are mulitple populations or just a single population of particular phases.

Inputs:
The data should be put in the observations.csv file. The data could be end-member activities, compositions or site allocations. 

Code:
P1_pca.m

This code allows you to run the PCA and K-means clustering. There are four inputs for the code:

1) observations = ???. This should be the csv file name of the data (e.g., "observations.csv").
2) k_plot = ???. This controls whether or not the K-means clustering runs. 1 = YES, 0 = NO
3) number_of_groups = ???. This is an initial guess for the number of populations, which can be changed once the K-means clustering has run. MAX = 5
4) output = ???. This should be a .csv file name for outputting the K-means clustering results (e.g., "outputs.csv").