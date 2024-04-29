% This script quantified the variation in a variable expected for a given
% uncertainty in temperature, at a selected pressure.
% e.g., how much is XAlm expected to vary, if there is a 50 °C uncertainty at 9 kbar.
clear;clc;

%%%%%%%%% INPUTS %%%%%%%%%
% data
model = 'inputs/forward_model.csv';
observations = 'inputs/observations.csv';
synthetics = 'inputs/synthetic.csv';

% parameters
threshold = 75; % This is the temperature uncertainty for each variable.
pressure_of_interest = 9000; % This is the pressure of interest (bar).


%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%

% Read data
obs = readtable(observations); variables = obs.Properties.VariableNames; obs = table2array(obs);
mod = readmatrix(model); mod = sortrows(mod,2); T = mod(:,1); P = mod(:,2); mod = mod(:,3:end);
synthetic = readmatrix(synthetics); synthetic = synthetic(:,2:end); mu = synthetic(1,:); sigma = synthetic(2,:);

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
    av = av(~isnan(av)); med = median(av);
    med = ceil(med);
    
    % Create plot
    fig3 = figure(3);
    row = ceil(length(variables)/3);
    subplot(row,3,i)
    boxplot(av,'Orientation','horizontal')
    t = append(variables(i),', x̄ = ',string(med));
    title(t);
    xlabel('% difference')

end
saveas(fig3,"FIGURES/predicted_error.pdf");
