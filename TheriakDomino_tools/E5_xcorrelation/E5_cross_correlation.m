% This script assesses the degree of cross-correlation
clear;clc;
% INPUTS
% data
data1 = 'inputs/forward_model.csv';


% Code
data = readmatrix(data1);
names = readtable(data1); names = names.Properties.VariableNames;
data = data./max(data);

d = corrcoef(data);
table = array2table(d, 'VariableNames', names,'RowNames',names);