% This script examines the uncertainty associated with the observations,
% and suggests an appropriate synthetic uncertainty if below a critical
% threshold.
clear;clc;

%%%%%%%%% INPUTS %%%%%%%%%
% data
model = 'inputs/forward_model.csv';
observations = 'inputs/observations.csv';

% parameters
threshold = 50; % This is the lowest temperature uncertainty accepted for each variable
pressure_of_interest = 8000; % This is the pressure of interest (bar). Code will choose closest fitting pressure.



%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%

%%%%%%%%% Part 1: Find the temperature error associated with the
%%%%%%%%% observations
obs = readtable(observations); variables = obs.Properties.VariableNames; obs = table2array(obs);
mod = readmatrix(model); T = mod(:,1); P = mod(:,2); mod = mod(:,3:end);

for i = 1:size(mod,2)

    forward = mod(:,i);
    
    for ii = 1:size(obs,1)

        ob = obs(ii,i);

        for iii = 1:size(forward); fit(iii) = +Functions_NO_EDIT.misfit(forward(iii),ob);end
        T_best = T(fit == min(fit)); P_best = P(fit == min(fit));
        T_variation(ii,i) = T_best;
        P_variation(ii,i) = P_best;


    end

end

figure(1)
for i = 1:size(obs,2)
row = ceil(length(variables)/3);
subplot(row,3,i)
data = T_variation(:,i);
mu = mean(data); sigma = std(data);
mu = ceil(mu/5)*5; sigma = ceil(sigma/5)*5;
[f,ix] = ksdensity(T_variation(:,i));
plot(ix,f);
xlabel(variables(i));
t = append(string(mu),' ± ',string(sigma),' °C');
title(t)
end

figure(2)
for i = 1:size(obs,2)
row = ceil(length(variables)/3);
subplot(row,3,i)
data = P_variation(:,i);
mu = mean(data); sigma = std(data);
mu = ceil(mu/5)*5/1000; sigma = ceil(sigma/5)*5/1000;
[f,ix] = ksdensity(P_variation(:,i));
plot(ix/1000,f);
xlabel(variables(i));
t = append(string(mu),' ± ',string(sigma),' kbar');
title(t)
end


%%
%%%%%%%%% Part 2: Find a suitable synthetic error for a known temperature
%%%%%%%%% variability
threshold = 40;  % Change in Y value


% Find 
absolute_diff = abs(P - pressure_of_interest); [~, index] = min(absolute_diff);
p = P(index);
uT = unique(T);
t1 = unique(T); 
t2 = t1 + threshold;
t3 = t1 - threshold;

true = t1;
bigger = t2;
smaller = t3;

% Big
result = NaN(size(true));
indices = ismember(bigger, true);
result(indices) = bigger(indices);

% Small
result1 = NaN(size(true));
indices = ismember(smaller, true);
result1(indices) = smaller(indices);


t = [t1,t2,t3]; t(t < min(t1)) = NaN; t(t > max(t1)) = NaN;




t = find(ismember(t, t1));
t1 = find(P == p);


array1 = [-2, -3, 1, 2, 3, 4, 5, 6, 7, 8, 10];  % Larger array
array2 = [2, 5, 8, 10];  % Smaller array

% Find the index positions of elements in array1 that match elements in array2
index_positions = find(ismember(array1, array2));

% Display the index positions
disp('Index positions of [2,5,8,10] in [-2,-3,1,2,3,4,5,6,7,8,10]:');
disp(index_positions);


