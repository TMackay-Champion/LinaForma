% This script plots the residuals for a particular point of interest
clear;clc;

%%%%%%%%% INPUTS %%%%%%%%%
% data
forward_model = 'inputs/forward_model.csv';
observations =  'inputs/observations.csv';
synthetic_data = 'inputs/synthetic.csv';

% parameters
synth = 1; % Do you want to use a synthetic distribution? 1 = YES, 0 = NO
T_best = 570; % Select the T point to which results will be compared.
P_best = 9300;      % Select the P point to which results will be compared. Units = bars.



%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%%
model = readmatrix(forward_model);
observations = readmatrix(observations);
variables = readtable(forward_model);variables = variables.Properties.VariableNames;
variables = variables(:,3:end);


% Get data
m_data = model(:,3:end); TP = model(:,1:2); % Get PT points of model
row = +Functions_NO_EDIT.find_points([T_best,P_best],TP,0);
data = m_data(row,:);


% Make observations
syn = readtable(synthetic_data);
syn_mean = table2array(syn(1,2:end)); syn_sigma =table2array(syn(2,2:end));


for i = 1:size(observations,2)

        if synth == 1
            mu = syn_mean(i); sig = syn_sigma(i);
            x = linspace(mu-3*sig, mu + 3*sig, 1000); 
            distribution = normpdf(x, mu, sig);
            sigma(i) = sig; mn(i) = mu;
            observed_dist(i,:) = distribution;
            x_axis(i,:) = x;

        else
            tmp = observations(:,i);
            sigma(i) = std(tmp);
            mn(i) = mean(tmp);
            [f,x] = ksdensity(tmp);
            observed_dist(i,:) = f;
            x_axis(i,:) = x;
        end

end

fig1 = figure(1);
set(fig1,'Units','centimeters')
set(fig1,'Position',[0 0 0.9*21 0.9*21])
for i = 1:length(variables)
    row = ceil(length(variables)/3)+1;
    subplot(row,3,i)
    plot(x_axis(i,:),observed_dist(i,:)); hold on
    plot([data(1,i),data(1,i)],[0 max(observed_dist(i,:))],'r--','LineWidth',2)
    if synth ~= 1
        plot([min(observations(:,i)) min(observations(:,i))],[0 max(observed_dist(i,:))])
        plot([max(observations(:,i)) max(observations(:,i))],[0 max(observed_dist(i,:))])
    end
    t = append(string(mn(i)),' ± ',string(sigma(i)));
    title(t);
    ylabel('P.D.E.')
    xlabel(string(variables(i)))
    if i == 1 && synth == 1
        lg = legend({'Observations','Model result'});
        lg.Position = [0.5, 0.05, 0.1, 0.1];
    elseif i ==1 && synth ~= 1
        lg = legend({'Observations','Model result','Maximum observation','Minimum observation'});
        lg.Position = [0.3, 0.25, 0.4, 0.05];
    end
end
print(fig1,"FIGURES/residuals.pdf",'-dpdf','-bestfit')
disp('FINISHED')
