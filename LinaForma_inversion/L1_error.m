% This script examines the uncertainty associated with the the range in
% observations of each variable.
clear;clc;

%%%%%%%%% INPUTS %%%%%%%%%
% ====== Data ======
model = 'inputs/forward_model.csv'; % Forward models.
measurements = 'inputs/InputA.csv'; % Measurements

% ====== Data type ======
raw = 0; % What type of data do you have? 1 = all measurements. 0 = mean and std. of variables.

% ====== Sampling parameters (only applicable if raw = 0) ======
n = 20; % Number of random samples


%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%

% Input data. Give error message if wrong sheet is used.
if raw == 1
    obs = readtable(measurements); variables = obs.Properties.VariableNames;
    if any(strcmp(variables, 'Statistic'))
        error('This data only contains MEAN or STD information, not real measurements.')
    end
    obs = table2array(obs);
elseif raw == 0
    rtmp = readtable(measurements); variables = rtmp.Properties.VariableNames; 
    if ~any(strcmp(variables, 'Statistic'))
        error('This data does not contain MEAN or STD information.')
    end
    variables = variables(2:end);
    measurements = readmatrix(measurements); measurements = measurements(:,2:end); mu = measurements(1,:); sigma = measurements(2,:);
end

% Input model
mod = readmatrix(model); mod = sortrows(mod,2); T = mod(:,1); P = mod(:,2); mod = mod(:,3:end); 

% For each observation, calculate the best-fit solution
for i = 1:size(mod,2)
    forward = mod(:,i);
    if raw == 0; m = mu(:,i); sig = sigma(:,i); end
    if raw == 1; tmp2 = size(obs,1); else tmp2 = n; end

    for ii = 1:tmp2
        if raw == 1
            ob = obs(ii,i);
        elseif raw == 0
            ob = normrnd(m,sig,1);
        end

        for iii = 1:size(forward); fit(iii) = +Functions_NO_EDIT.misfit(forward(iii),ob);end
        T_best = mean(T(fit == min(fit))); P_best = mean(P(fit == min(fit)));
        T_variation(ii,i) = T_best;
        P_variation(ii,i) = P_best;
    end
end

% Plots
fig1 = figure(1);
row = ceil(length(variables)/3);
t = tiledlayout('flow');
set(fig1,'Units','centimeters')
set(fig1,'Position',[0 0 0.9*21 row*1/5*29])
for i = 1:size(mod,2)
nexttile
data = T_variation(:,i);
medT = median(data); rT3 = quantile(data,0.75); rT1 = quantile(data,0.25); 
med_T = ceil(medT/5)*5; rT3 = ceil(rT3/5)*5; rT1 = ceil(rT1/5)*5;
mu = mean(data); sigma = std(data);
mu = ceil(mu/5)*5; sigma = ceil(sigma/5)*5;
boxplot(data,'Orientation','horizontal')
xlabel(variables(i));
t = append('Mn = ',string(mu),' ± ',string(sigma),' °C (1σ)');
s = append('Md = ',string(med_T),' °C (IQR =  ',string(rT1),'-',string(rT3),')');
title({t,s});clc;
end

fig2 = figure(2);
row = ceil(length(variables)/3);
t = tiledlayout('flow');
set(fig2,'Units','centimeters')
set(fig2,'Position',[0 0 0.9*21 row*1/5*29])
for i = 1:size(mod,2)
nexttile
data = P_variation(:,i);
mu = mean(data); sigma = std(data);
medT = median(data); rT3 = quantile(data,0.75); rT1 = quantile(data,0.25); 
med_T = ceil(medT/50)*50; rT3 = ceil(rT3/50)*50; rT1 = ceil(rT1/50)*50;
mu = ceil(mu/50)*50; sigma = ceil(sigma/50)*50;
boxplot(data,'Orientation','horizontal')
xlabel(variables(i));
t = append('Mn = ',string(mu),' ± ',string(sigma),' bar (1σ)');
s = append('Md = ',string(med_T),' bar');
p = append('(IQR =  ',string(rT1),'-',string(rT3),')');
title({t,s,p});clc;
end

print('-image',fig1,"FIGURES/L1_fig1",'-dpdf');
print('-image',fig2,"FIGURES/L1_fig2",'-dpdf');
disp('FINISHED')





