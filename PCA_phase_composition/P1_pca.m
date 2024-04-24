% This computes the PCA of probe data
clear;clc;

%%%%%%% INPUTS. Please edit. %%%%%%%
% data
observations = 'observations.csv';

% editable parameters
k_plot = 0; % Do you want to run K-means clustering? 1 = YES, 0 = NO
number_of_groups = 3; % This is a guess for the number of clusters, which can be changed. MAX = 5
output = 'Kmeans_output.csv'; % This will only be created if k_plot = 1


%%%%%%% CODE %%%%%%%
%%% BEST NOT TO EDIT %%%
observations = readtable(observations);
plabel = table2cell(observations(:,1));
observations = observations(:,2:end);
variables = observations.Properties.VariableNames;
data = table2array(observations);
data_std = zscore(data);

% Perform PCA
[coeff, score, latent, ~, explained] = pca(data_std);

% Reduce dimensions
% Select a number of components (e.g., num_components)
num_components = 2;

% Reduce dimensionality
data_pca = score(:, 1:num_components);
X = [data_pca(:, 1), data_pca(:, 2)];

k_values = 1:size(data,1);
for i = 1:length(k_values)
    k = k_values(i);
    [idx, C, sumd] = kmeans(X, k);
    ssd_values(i) = sum(sumd); % Sum of squared distances
end

if k_plot == 1
figure(1)
subplot(1,3,1)
biplot(coeff(:,1:2),"Scores",score(:,1:2),"VarLabels",variables,'MarkerSize',15); hold on
title('{\bf PCA plot with variable vectors}')

subplot(1,3,2)
idx = kmeans(X,number_of_groups); 
color = {'r.','b.','g.','k.','b*'};
for i = 1:number_of_groups
plot(X(idx==i,1),X(idx==i,2),string(color(i)),'MarkerSize',15)
hold on
title('{\bf K-means clusters}')
end
hold off

subplot(1,3,3)
plot(k_values, ssd_values, 'bo-');
title('{\bf K-means clustering elbow}')

final = table(idx, 'VariableNames',{'K_mean_group'});
observations.K_mean_group = final.K_mean_group;
writetable(observations,output);
else
    figure(1)
    biplot(coeff(:,1:2),"Scores",score(:,1:2),"VarLabels",variables,'ObsLabels',plabel,'MarkerSize',25); hold on
    title('{\bf PCA}')
end
figure(2)
if k_plot == 1
kde = observations(:,1:(end-1));
else
    kde = observations;
end
var = kde.Properties.VariableNames;
for i = 1:size(kde,2)
    obs = kde(:,i); obs = table2array(obs);
    sigma = string(std(obs)); mu = string(mean(obs));
[f, xi] = ksdensity(obs);
row = ceil(size(kde,2)/3);
subplot(row,3,i)
plot(xi,f)
ylabel('Probability density estimate')
xlabel(var{i})
t = append('μ = ',mu,', σ = ',sigma);
title(t)
end

disp('FINISHED')
