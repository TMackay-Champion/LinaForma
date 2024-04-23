% This script will produce tornado sensitivity plots for each parameter
clear;clc;

%%%%%%%%% INPUTS %%%%%%%%%
% data
forward_model = 'inputs/forward_model.csv';
observations =  'inputs/observations.csv';
synthetic_data = 'inputs/synthetic.csv'; 

% parameters
bootstrap_type = 1;      % What type of bootstrapping do you want to use? Parametric = 1, non-parametric = 0, synthetic Gaussian = -1
it = 5;        % How many random iterations do you want to calculate? The more then better.
T_best = 570;      % Select the best-fit T point to which results will be compared.
P_best = 9300;      % Select the best-fit P point to which results will be compared.



%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%%

%%%% PART 1: Input the data and create the Pressure-temperature grid %%%%
% Read in data
model = readtable(forward_model);
observations = readtable(observations);

% Create Pressure-Temperature grid
data = table2array(model);
temperature = data(:,1);
pressure = data(:,2);
T = unique(temperature); T = T(~isnan(T)); ix = length(T);
P = unique(pressure); P = P(~isnan(P)); iy = length(P);
[X,Y] = meshgrid(T,P);
model_data = data(:,3:end);

%%%% PART 2: Boostrapping the observations, keeping all variables but 1 constant %%%%
obs = table2array(observations);
syn = readtable(synthetic_data);
syn_mean = table2array(syn(1,2:end)); syn_sigma =table2array(syn(2,2:end));

% Loop through each variable
for n_variable = 1:size(model_data,2)

% Perform bootstrap re-sampling
if bootstrap_type == 1 % Parametric bootstrapping
    sigma = std(obs,1); mu = mean(obs,1);
    samples1 = +Functions_NO_EDIT.gaussian_boot(it,mu,sigma);
    samples = repmat(mu,it,1);
    samples(:,n_variable) = samples1(:,n_variable);

elseif bootstrap_type == 0 % Non-parametric
    samples1 = bootstrp(it,@mean,obs);
    mean_samples = mean(samples1,1);
    samples = repmat(mean_samples,it,1);
    samples(:,n_variable) = samples1(:,n_variable);


elseif bootstrap_type == -1
    sigma = syn_sigma; mu = syn_mean;
    samples1 = +Functions_NO_EDIT.gaussian_boot(it,mu,sigma);
    samples = repmat(mu,it,1);
    samples(:,n_variable) = samples1(:,n_variable);

end

%%%% PART 3: Perform the grid-search inversion for each bootstrap resample %%%%
loop1 = 0;
for j = 1:size(samples,1)
loop1 = loop1 + 1; sample_values = samples(j,:);
for ii = 1:length(temperature)
    model_values = model_data(ii,:); 
    model_misfit(ii,:) = +Functions_NO_EDIT.misfit(model_values,sample_values);  
end
t_best(loop1,:) = temperature(model_misfit == min(model_misfit)); 
p_best(loop1,:) = pressure(model_misfit == min(model_misfit));
end

% Find variability of each variable
T_max(n_variable) = max(t_best)-T_best;
T_min(n_variable) = T_best - min(t_best);
P_max(n_variable) = max(p_best) - P_best;
P_min(n_variable) = P_best - min(p_best);

end

%%%% PART 4: Plots %%%%
variables = readtable(forward_model); variables = variables.Properties.VariableNames;
variables = variables(:,3:end);


% Plot T variability
fig1 = figure(1);
subplot(1,2,1)
impact = [-T_min;T_max]'; % Impact on the outcome (positive or negative)

% Sort variables based on their impact
positive_rows = all(impact > 0, 2);
impact(positive_rows, 1) = 0;
negative_rows = all(impact < 0, 2);
impact(negative_rows, 2) = 0;
total_impact = sqrt((impact(:,1) - impact(:,2)).^2);

[~, sortOrder] = sort(total_impact, 'descend');
sortedVariables = variables(sortOrder);
sorted_impact = impact(flipud(sortOrder),:);


% Define base case outcome and calculate outcomes for each variable
baseOutcome = 0; % Base case outcome
outcomes = baseOutcome + sorted_impact(:,2);

% Create tornado plot
barh(outcomes,'FaceColor',[0.3, 0.7, 0.9]); % Blue bars for positive impact
hold on;
barh(find(sorted_impact < 0), sorted_impact(sorted_impact < 0), 'FaceColor', [0.9, 0.3, 0.3]); % Red bars for negative impact
plot(baseOutcome * [1, 1], [0.5, length(variables) + 0.5], 'k--'); % Base case outcome line
set(gca, 'YTick', 1:length(variables), 'YTickLabel', sortedVariables,'Fontsize',12); % Set y-axis labels
xlabel('Temperature variation relative to input (°C)'); % Label x-axis
t = append('@ ',string(T_best),' °C and ',string(P_best),' kbar');
title(t); % Title


subplot(1,2,2)
impact = [-P_min;P_max]'; % Impact on the outcome (positive or negative)

% Sort variables based on their impact
positive_rows = all(impact > 0, 2);
impact(positive_rows, 1) = 0;
negative_rows = all(impact < 0, 2);
impact(negative_rows, 2) = 0;
total_impact = sqrt((impact(:,1) - impact(:,2)).^2);

[sortedImpact, sortOrder] = sort(total_impact, 'descend');
sortedVariables = variables(sortOrder);
sorted_impact = impact(flipud(sortOrder),:);


% Define base case outcome and calculate outcomes for each variable
baseOutcome = 0; % Base case outcome
outcomes = baseOutcome + sorted_impact(:,2);

% Create tornado plot
barh(outcomes,'FaceColor',[0.3, 0.7, 0.9]); % Blue bars for positive impact
hold on;
barh(find(sorted_impact < 0), sorted_impact(sorted_impact < 0), 'FaceColor', [0.9, 0.3, 0.3]); % Red bars for negative impact
plot(baseOutcome * [1, 1], [0.5, length(variables) + 0.5], 'k--'); % Base case outcome line
set(gca, 'YTick', 1:length(variables), 'YTickLabel', sortedVariables,'Fontsize',12); % Set y-axis labels
xlabel('Pressure variation relative to input (bar)'); % Label x-axis
legend('Positive Impact', 'Negative Impact', 'Base Case', 'Location', 'best');

% Save figure
saveas(fig1,"FIGURES/sensitivity_plots.pdf");
disp('FINISHED')










