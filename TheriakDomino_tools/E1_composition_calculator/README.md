# E1_comp
This code allows the user to create a composition file (THERIN.txt) for TD from the original oxide weight percent compositions. The output is element proportions, and can be readily used in Perple_X sofware.

## Inputs
1) input_comp.csv. This file should contain the bulk composition of the sample in oxide weight percent. Please do not change the order of the oxides, and please put all Fe as FeO. The file should look like this:

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/9922ca42fce1f920aaf6f3300c77bbe0d4bfcac0/images/E1_input.png", width="80%">
</p>


## Code (E1_comp.m)
1) composition = '???'. This should be the name of the input file containing the bulk composition information (e.g., "input_comp.csv").
2) mole_H2O = ?. This is the mole percent of water you wish to add to your final composition.
3) sample_name = '???'. This is the sample name.
4) TD_output = '?'. This controls the output of THERIAK-DOMINO (see the program documentation for more detail).
5) monazite_fraction = ?. This is the ratio of monazite to apatite in the rock, and allows for an appropriate Ca correction in the bulk composition. Apatite contains Ca whereas monazite does not.


## Outputs
The code will output a therin.txt file which looks like this:

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/e80e9b829098b12359f445220047e4deb13afcc8/images/E1_output.png", width="80%">
</p>