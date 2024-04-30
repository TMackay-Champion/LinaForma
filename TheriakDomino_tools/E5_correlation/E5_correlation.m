% This script assesses the degree of correlation between the variables
clear;clc;


%%%%%%%%% INPUTS %%%%%%%%%
% ====== Data ======
models = 'forward_model.csv'; % The filename of the input data


%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%
data = readmatrix(models);
names = readtable(models); names = names.Properties.VariableNames;
data = data./max(data);
d = corrcoef(data);
table = array2table(d, 'VariableNames', names,'RowNames',names);

writetable(table,'correlation_coefficients.csv','WriteRowNames',true);