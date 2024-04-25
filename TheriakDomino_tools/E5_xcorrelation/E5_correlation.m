% This script assesses the degree of correlation between the variables
clear;clc;


%%%%%%%%% INPUTS %%%%%%%%%
% data


% Code
data = readmatrix(data1);
names = readtable(data1); names = names.Properties.VariableNames;
data = data./max(data);

d = corrcoef(data);
table = array2table(d, 'VariableNames', names,'RowNames',names);