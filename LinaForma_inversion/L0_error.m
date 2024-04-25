% This script examines the uncertainty associated with the observations,
% and suggests an appropriate synthetic uncertainty if below a critical
% threshold.
clear;clc;

%%%%%%%%% INPUTS %%%%%%%%%
% data
model = 'inputs/forward_model.csv';
observations = 'inputs/observations.csv';

% parameters
threshold = 50; % This is the temperature uncertainty for each variable.
pressure_of_interest = 9000; % This is the pressure of interest (bar).



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


%%%%%%%%% Part 2: Find a suitable synthetic error for a known temperature
%%%%%%%%% variability

% Closest pressure
absolute_diff = abs(P - pressure_of_interest);
[~, index_closest] = min(absolute_diff);
p = P(index_closest);

for i = 1:size(mod,2)
    forward = mod(:,i);
    data = forward(p == P);

    % Find temp. jump
    tmp = unique(T); step = tmp(2) - tmp(1);
    number_of_steps = round(threshold/step);

    % Find mean
    t1 = unique(T); t1 = [1:length(t1)]';
    mn = data(t1);

    % Find with temperature added
    tmp = 1:number_of_steps;
    
    loop = 0;
    model_value = [];
    new_index = [];
    data_set = [];
    for ii = 1:length(t1)
        new_index = t1(ii) + tmp;
        loop = loop + 1;
        if max(new_index) > max(t1)
            break
        end
        model_value(ii) = mn(ii);
        data_set(ii,:) = data(new_index);
    end

    model_value = model_value';
    diff = abs(data_set - model_value)./model_value*100;
    av = mean(diff,2);
    
    % Create plot
    figure(3)
    row = ceil(length(variables)/3);
    subplot(row,3,i)
    boxplot(av,'Orientation','horizontal')
    xlabel('% difference')
    title(variables(i));

end






