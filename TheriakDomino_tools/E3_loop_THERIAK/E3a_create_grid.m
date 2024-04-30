% This script will create a grid for THERIAK
clear;clc;

%%%%%%%%% INPUTS %%%%%%%%%
% ====== Run parameters ======
lowT = 400;
highT = 1000;
steps_T = 5; % Number of steps
lowP = 4000;
highP = 10000;
steps_P = 5; % Number of steps


%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%%
% Create P-T matrix
T = linspace(lowT,highT,steps_T);
P = linspace(lowP,highP,steps_P);
[Pg,Tg] = meshgrid(P,T);
T = Tg(:);
P = Pg(:);
% Write path
path = table(T, P, 'VariableNames', {'Temperature (°C)', 'Pressure (bar)'});
writetable(path,'PT_path.csv');
disp('FINISHED')