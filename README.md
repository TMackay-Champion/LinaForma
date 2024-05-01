# LinaForma

  <!-- License -->
  <a href="https://www.gnu.org/licenses/gpl-3.0">
    <img src="https://img.shields.io/badge/License-GPLv3-blue.svg" />
  </a>
</p>

LinaForma is a series of MATLAB® scripts for calculating the optimal pressure-temperature (P-T) conditions experienced by a rock using a grid-search inversion, accompanied by bootstrap re-sampling to quantify the solution uncertainty and sensitivity to the input variables. LinaForma calculates the difference ("misfit") between measurements (e.g., Xalm) and forward models computed for a range of P-T points in third-party software such as THERIAK-DOMINO or Perple_X. The P-T point with the lowest misfit value defines the “best-fit” solution. A suite of tools is also provided for plotting forward model data, for automating processes in THERIAK-DOMINO, and for performing tasks such as Principal Component Analysis. 

LinaForma requires no prior computer programming knowledge and a step-by-step walkthrough is provided.

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/05e58a21e651066dc0452beaa799e8eab52530d0/images/logo_heatmap.jpg", width="50%">
</p>


Key Features
--------
To use these codes, please either download them as a ZIP file or 

There are three key packages:
1) **LinaForma_inversion**: this package performs a grid-search inversion to quantify which P-T conditions best fit the rock of interest. Bootstrap re-sampling provides an assessment of the uncertainty associated with this P-T estimate, and the sensitivity of the estimate to uncertainty in the input variables.
2) **TheriakDomino_tools**: this package provides useful tools for creating bulk-composition THERIN files (E1 script), collating DOMINO output into a single csv. file (E2), automating THERIAK (E3), plotting data in heatmaps, contour plots etc. (E4), and calculating the correlation coefficients between the different variables, temperature and pressure (E5).
3) **PCA_phase_composition**: this package allows the user to perform Principal Component Analysis and K-means clustering on mineral composition data.


Citation
--------
If you use this package in your work, please cite the following conference presentation:

```console
Mackay-Champion, T., and Cawood, I.P., 2024. Using a grid-search nonlinear inversion, bootstrapping, and the Sobol’ method to quantify uncertainty in pseudosection P-T estimates. In Metamorphic Studies Group RiP Meeting 2024.
```
as well as the relevant version of the source code on [Zenodo](https://doi.org/10.5281/zenodo.4....).


Contributing to LinaForma
----------------------------
Contributions to LinaForma are welcomed. Whether you have identified a bug or would like to request a new feature or enhancement, please reach out either directly or via the GitHub Issues panel to discuss the proposed changes.

Links to projects that have made use of LinaForma are also most welcome.


Contact
-------
Any comments/questions can be directed to:
* **Tobermory Mackay-Champion** - tmackaychampion@gmail.com
* **Ian Cawood** - ian.cawood@worc.ox.ac.uk

License
-------
This package is written and maintained by Tobermory Mackay-Champion and Ian Cawood. It is distributed under the GPLv3 License. Please see the [LICENSE](LICENSE) file for a complete description of the rights and freedoms that this provides the user.
