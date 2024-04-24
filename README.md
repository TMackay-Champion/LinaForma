# LinaForma

  <!-- License -->
  <a href="https://www.gnu.org/licenses/gpl-3.0">
    <img src="https://img.shields.io/badge/License-GPLv3-blue.svg" />
  </a>
</p>

LinaForma is a series of open-sourced MATLAB®-based scripts for performing a grid-search to determine best-fit P-T conditions and uncertainties for Gibbs Energy Minimisation forward models calculated in Theriak-Domino. LinaForma requires no prior computer programming knowledge and a step-by-step walkthrough is provided.

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/05e58a21e651066dc0452beaa799e8eab52530d0/images/logo_heatmap.jpg", width="80%">
</p>


Key Features
--------
To use these codes, please just download them as a ZIP file.

There are three key packages:
1) EXTRA_TD_tools: here we provide useful tools for creating bulk-composition THERIN files (E1 script), collating DOMINO output into a single csv. file (E2), automating THERIAK (E3), and plotting data in heatmaps, contour plots etc.(E4).
2) LinaForma_inversion: here we perform a grid-search inversion to quantify which pressure-temperature conditions best fitn your rock.
3) PCA_mineral_composition: here you can perform Principal Component Analysis and K-means clustering on mineral composition data to examine whether there are multiple populations.


Citation
--------
If you use this package in your work, please cite the following conference presentation:

```console
Mackay-Champion, T., and Cawood, I.P., 2024. Using a grid-search nonlinear inversion, bootstrapping, and the Sobol’ method to quantify uncertainty in pseudosection P-T estimates. In Metamorphic Studies Group RiP Meeting 2024.
```

as well as the relevant version of the source code on [Zenodo](https://doi.org/10.5281/zenodo.4....).

We hope to have a publication coming out soon.
