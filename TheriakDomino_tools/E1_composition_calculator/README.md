## Overview
This code allows the user to create a composition file (THERIN.txt) for TD from the original oxide weight percent compositions. The output is element proportions, and can be readily used in Perple_X sofware.

## Data Inputs
1) input_comp.csv. This file should contain the bulk composition of the sample in oxide weight percent. Please do not change the order of the oxides, and please put all Fe as FeO. The file should look like this:

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/9922ca42fce1f920aaf6f3300c77bbe0d4bfcac0/images/E1_input.png", width="80%">
</p>



## E1 script inputs
% ====== Compositional data ======\
**composition = '?'**\
This should be the name of the input file containing the bulk composition information.

% ====== Run parameters ======\
**mole_H2O = ?**\
The mole percent of water added to the final composition.\
**sample_name = '?'**\
The sample name.\
**TD_output = '?'**\
The output code for THERIAK-DOMINO.\
**monazite_fraction = ?**\
The molar ratio of monazite to apatite in the rock. This controls the phosphate correction. Apatite contains Ca whereas monazite does not.


## E1 script outputs
The code will output a therin.txt file. The data within could also be used as the input for the Perple_X software.

 <p align="center">
<img src="https://github.com/TMackay-Champion/LinaForma/blob/e80e9b829098b12359f445220047e4deb13afcc8/images/E1_output.png", width="80%">
</p>
