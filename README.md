# LinaForma

  <!-- License -->
  <a href="https://www.gnu.org/licenses/gpl-3.0">
    <img src="https://img.shields.io/badge/License-GPLv3-blue.svg" />
  </a>
</p>

LinaForma is a series of open-sourced MATLAB®-based scripts for performing a grid-search to determine best-fit P-T conditions and uncertainties for Gibbs Energy Minimisation forward models calculated in Theriak-Domino. LinaForma requires no prior computer programming knowledge and a step-by-step walkthrough is provided.

To use these codes, please just download them as a ZIP file.

There are three key packages:
1) EXTRA_TD_tools: here we provide useful tools for creating bulk-composition THERIN files (E1 script), collating DOMINO output into a single csv. file (E2), automating THERIAK (E3), and plotting data in heatmaps, contour plots etc.(E4).
2) LinaForma_inversion: here we perform a grid-search inversion to quantify which pressure-temperature conditions best fitn your rock.
3) PCA_mineral_composition: here you can perform Principal Component Analysis and K-means clustering on mineral composition data to examine whether there are multiple populations.


Citation
--------
If you use this package in your work, please cite the following conference presentation:

```console
Winder, T., Bacon, C.A., Smith, J.D., Hudson, T., Greenfield, T. and White, R.S., 2020. QuakeMigrate: a Modular, Open-Source Python Package for Automatic Earthquake Detection and Location. In AGU Fall Meeting 2020. AGU.
```

as well as the relevant version of the source code on [Zenodo](https://doi.org/10.5281/zenodo.4442749).

We hope to have a publication coming out soon:

```console
Winder, T., Bacon, C.A., Smith, J.D., Hudson, T.S., Drew, J., and White, R.S. QuakeMigrate: a Python Package for Automatic Earthquake Detection and Location Using Waveform Migration and Stacking. (to be submitted to Seismica).
```
