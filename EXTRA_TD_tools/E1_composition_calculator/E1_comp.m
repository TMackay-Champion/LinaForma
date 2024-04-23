% This script creates a THERIN file for a given bulk composition in wt%
% oxides. Make sure the input_comp.csv file always has the same order of
% oxides!
clear;clc;

% INPUTS
composition = 'input_comp.csv'; % Composition in wt%
sample_name = 'TMC'; % Sample name
TD_output = '0'; % The output code for Theriak-Domino. Can be -1, 0, 1



% Code
comp = readmatrix(composition);
comp_string = comp_calc_DO_NOT_EDIT(comp,0);
sample_name = append('  *  ',sample_name);
first_line = '    400     2000';
title = 'therin.txt';
final = append(first_line,'\n',TD_output,'  ',comp_string,sample_name);
autoID1 = fopen(title,'w');
fprintf(autoID1,final);
fclose(autoID1);
disp('FINISHED')