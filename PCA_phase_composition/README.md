## Overview
This code allows the user to perform Principal Component Analysis (PCA) and K-means clustering on any data of interest, such as phase compositional data. This workflow allows the user to assess whether there are mulitple populations or just a single population of particular phases. The data should be put in the observations.csv file.


<details>
<summary> P1 script input </summary>

% ====== Data ======\
**measurements = '?'**\
This is the CSV file containing the observations.

% ====== K-means parameters ======\
**k_plot = ?**\
Do you want to run K-means clustering? 1 = YES, 0 = NO.\
**number_of_groups = ?**\
This is an initial guess for the number of clusters, which can be changed. MAX = 5.\
**output = '?'**\
This should be a CSV file name for outputting the K-means clustering results (e.g., "outputs.csv").
</details>


<details>
<summary> P1 script output </summary>
The code will output a number of plots, including a 2D PCA plot with accompanying variable vectors and a probability density estimate for each variable. If k_plot = 1, then a CSV file will be output grouping the data into clusters.
</details>
