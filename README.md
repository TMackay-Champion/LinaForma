# LinaForma
LinaForma is a series of open-sourced MATLAB®-based scripts for performing a grid-search to determine best-fit P-T conditions and uncertainties for Gibbs Energy Minimisation forward models calculated in Theriak-Domino. LinaForma requires no prior computer programming knowledge and a step-by-step walkthrough is provided. 

To use these codes, please just download them as a ZIP file.

There are three key packages:
1) EXTRA_TD_tools: here we provide useful tools for creating bulk-composition THERIN files (E1 script), collating DOMINO output into a single csv. file (E2), automating THERIAK (E3), and plotting data in heatmaps, contour plots etc.(E4).
2) LinaForma_inversion: here we perform a grid-search inversion to quantify which pressure-temperature conditions best fitn your rock.
3) PCA_mineral_composition: here you can perform Principal Component Analysis and K-means clustering on mineral composition data to examine whether there are multiple populations.
