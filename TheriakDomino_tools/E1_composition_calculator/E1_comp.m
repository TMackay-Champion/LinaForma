% This script creates a THERIN file for a given bulk composition in wt%
% oxides. Make sure the input_comp.csv file always has the same order of
% oxides!
clear;

%%%%%%%%% INPUTS %%%%%%%%%
% ====== Compositional data ======
composition = 'input_comp.csv'; % Composition in wt%

% ====== Run parameters ======
mole_H2O = 5 ; % The mole percent of water in final composition
sample_name = 'TMC'; % Sample name
TD_output = '0'; % The print code for THERIAK-DOMINO.
monazite_fraction = 0.95; % The molar ratio of monazite to apatite in the rock. This controls the phosphate correction.


%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%
comp_string = comp_calc_DO_NOT_EDIT(composition,1,monazite_fraction,mole_H2O);
sample_name = append('  *  ',sample_name);
first_line = '    400     2000';
title = 'therin.txt';
final = append(first_line,'\n',TD_output,'  ',comp_string,sample_name);
autoID1 = fopen(title,'w');
fprintf(autoID1,final);
fclose(autoID1);
disp(comp_string)
disp('FINISHED')