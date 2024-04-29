% This script examines the uncertainty associated with the the range in
% observations of each variable.
clear;clc;

%%%%%%%%% INPUTS %%%%%%%%%
% data
model = 'inputs/forward_model.csv';
observations = 'inputs/observations.csv';
synthetics = 'inputs/synthetic.csv';

% parameters
synth = 0; % Do you want to use synthetics or the real observations? 1 = synth, 0 = observations. 
n = 1000; % Number of random samples. Only applicable if synth = 1.


%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%

obs = readtable(observations); variables = obs.Properties.VariableNames; obs = table2array(obs);
mod = readmatrix(model); mod = sortrows(mod,2); T = mod(:,1); P = mod(:,2); mod = mod(:,3:end);
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

        T_best = mean(T(fit == min(fit))); P_best = mean(P(fit == min(fit)));
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

saveas(fig1,"FIGURES/observation_T_error.pdf");
saveas(fig2,"FIGURES/observation_P_error.pdf");
disp('FINISHED')





