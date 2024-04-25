% This script examines the uncertainty associated with the observations,
% and suggests an appropriate synthetic uncertainty if below a critical
% threshold.
clear;clc;

%%%%%%%%% INPUTS %%%%%%%%%
% data
model = 'inputs/forward_model.csv';
observations = 'inputs/observations.csv';
synthetics = 'inputs/synthetic.csv';

% parameters for Part 1 (Temperature and pressure error from the
% observations of each variable)
synth = 1; % Do you want to use synthetics or the real observations? 1 = synth, 0 = observations. 
n = 1000; % Number of random samples. Only applicable if synth = 1.

% parameters for Part 2 (The percentage uncertainty expected for a variable for
% a given temperature uncertainty, at a selected pressure). 
threshold = 75; % This is the temperature uncertainty for each variable.
pressure_of_interest = 9000; % This is the pressure of interest (bar).



%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%

%%%%%%%%% Part 1: Find the temperature error associated with the
%%%%%%%%% observations
obs = readtable(observations); variables = obs.Properties.VariableNames; obs = table2array(obs);
mod = readmatrix(model); T = mod(:,1); P = mod(:,2); mod = mod(:,3:end);
synthetic = readmatrix(synthetics); synthetic = synthetic(:,2:end); mu = synthetic(1,:); sigma = synthetic(2,:);

for i = 1:size(mod,2)

    forward = mod(:,i);
    m = mu(:,i); sig = sigma(:,i);

    if synth == 0; tmp2 = size(obs,1); else tmp2 = n; end
    
    for ii = 1:tmp2

        if synth == 0
            ob = obs(ii,i);
        elseif synth == 1
            ob = normrnd(m,sig,1);
        end

        for iii = 1:size(forward); fit(iii) = +Functions_NO_EDIT.misfit(forward(iii),ob);end

        T_best = T(fit == min(fit)); P_best = P(fit == min(fit));
        T_variation(ii,i) = T_best;
        P_variation(ii,i) = P_best;

    end

end

fig1 = figure(1);
for i = 1:size(obs,2)
row = ceil(length(variables)/3);
subplot(row,3,i)
data = T_variation(:,i);
mu = mean(data); sigma = std(data);
mu = ceil(mu/5)*5; sigma = ceil(sigma/5)*5;
[f,ix] = ksdensity(T_variation(:,i));
%plot(ix,f);
boxplot(data,'Orientation','horizontal')
xlabel(variables(i));
t = append(string(mu),' ± ',string(sigma),' °C');
title(t)
end

fig2 = figure(2);
for i = 1:size(obs,2)
row = ceil(length(variables)/3);
subplot(row,3,i)
data = P_variation(:,i);
mu = mean(data); sigma = std(data);
mu = ceil(mu/5)*5/1000; sigma = ceil(sigma/5)*5/1000;
[f,ix] = ksdensity(P_variation(:,i));
%plot(ix/1000,f);
boxplot(data/1000,'Orientation','horizontal')
xlabel(variables(i));
t = append(string(mu),' ± ',string(sigma),' kbar');
title(t)
end


%%%%%%%%% Part 2: Find a suitable error for a known temperature
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

saveas(fig1,"FIGURES/observation_T_error.pdf");
saveas(fig2,"FIGURES/observation_P_error.pdf");
saveas(fig3,"FIGURES/predicted_error.pdf");
disp('FINISHED')





