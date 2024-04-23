% This script runs the grid-search and bootstrapping uncertainty
clear;clc;

%%%%%%%%% INPUTS %%%%%%%%%
% data
model = 'inputs/forward_model.csv';
observations =  'inputs/observations.csv';
synthetic_data = 'inputs/synthetic.csv';    % This will only be used if bootstrap_type = -1 below

% parameters
bootstrap_type = 1;      % What type of bootstrapping do you want to use? Parametric = 1, non-parametric = 0, synthetic Gaussian = -1
it = 50;        % How many random iterations do you want to calculate?
confidence_level = 0.58;  % Confidence level for 2D ellipse
boxplots = 0;   % Do you want boxplots or histograms? 1 = boxplot, 0 = histogram
Nbins = 5;  % Number of histogram bins. Only used if boxplots = 0


%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%%

%%%% PART 1: Input the data and create the Pressure-temperature grid %%%%
% Read in data
model = readtable(model);
observations = readtable(observations);

% Create Pressure-Temperature grid
data = table2array(model);
temperature = data(:,1);
pressure = data(:,2);
T = unique(temperature); T = T(~isnan(T)); ix = length(T);
P = unique(pressure); P = P(~isnan(P)); iy = length(P);
variables = model.Properties.VariableNames;
[X,Y] = meshgrid(T,P);
model_data = data(:,3:end);

%%%% PART 2: Boostrapping the observations %%%%
obs = table2array(observations);
syn = readtable(synthetic_data);
syn_mean = table2array(syn(1,2:end)); syn_sigma =table2array(syn(2,2:end));
if bootstrap_type == 1 % Parametric bootstrapping
    sigma = std(obs,1); mu = mean(obs,1);
    samples = +Functions_NO_EDIT.gaussian_boot(it,mu,sigma);

elseif bootstrap_type == 0 % Non-parametric
    samples = bootstrp(it,@mean,obs);

elseif bootstrap_type == -1
    sigma = syn_sigma; mu = syn_mean;
    samples = +Functions_NO_EDIT.gaussian_boot(it,mu,sigma);

end

% Let the final row be a mean of bootstrapped samples to create error
% surface
samples = [samples;mean(samples,1)];


%%%% PART3: Perform the grid-search inversion %%%%
loop1 = 0;
for j = 1:size(samples,1)
    
% Find the sample values
loop1 = loop1 + 1;
sample_values = samples(j,:);

% Loop over every grid point
for ii = 1:length(temperature)
    
    % Get forward model values
    model_values = model_data(ii,:);

    % Calculate the misfit between the sample value and the forward model 
    model_misfit(ii,:) = +Functions_NO_EDIT.misfit(model_values,sample_values);
    
end

% Find best T and P
t_best(loop1,:) = temperature(model_misfit == min(model_misfit));
p_best(loop1,:) = pressure(model_misfit == min(model_misfit));

end

%%%% PART5: Plot misfit surface and perform statistics %%%%
% Plot grid
fig1 = figure(1);
plot(X,Y,'ko');
xlabel('Temperature (°C)')
ylabel('Pressure (bar)')
minY = min(Y,[],'all'); maxY = max(Y,[],'all');
minX = min(X,[],'all'); maxX = max(X,[],'all');
ylim([(minY-0.05*maxY) (maxY+0.05*maxY)])
xlim([(minX-0.05*maxX) (maxX+0.05*maxX)])
title('Model grid')


% Plot the misfit surface
fig2 = figure(2);
fig2.Position = [380,138,681,813];
subplot(3,2,[1 2 3 4])
res = reshape(log(model_misfit),[ix iy])';
contourf(X,Y,res); hold on
c = colorbar;
c.Label.String = 'Misfit';
ylabel('Pressure (bars)')
xlabel('Temperature (°C)')
ylim([min(P) max(P)])
xlim([min(T) max(T)])

% Add the best-fit solutions and plot error elipse
plot(t_best(:,1),p_best(:,1),'k.','MarkerSize',10);

% Standard and mean calculation
mu_T = mean(t_best); mu_P = mean(p_best);
covariance = cov(t_best,p_best);
std_T = std(t_best); std_P = std(p_best);

% Plot error ellipse
[eigen_vectors, eigen_values] = eig(covariance);
major_axis_length = sqrt(eigen_values(1, 1) * chi2inv(confidence_level, 2));
minor_axis_length = sqrt(eigen_values(2, 2) * chi2inv(confidence_level, 2));
rotation_angle = atan2(eigen_vectors(2, 1), eigen_vectors(1, 1));
theta = linspace(0, 2 * pi, 100);
x_ellipse = major_axis_length * cos(theta);
y_ellipse = minor_axis_length * sin(theta);
x_rotated = x_ellipse * cos(rotation_angle) - y_ellipse * sin(rotation_angle);
y_rotated = x_ellipse * sin(rotation_angle) + y_ellipse * cos(rotation_angle);
x_rotated = x_rotated + mu_T;
y_rotated = y_rotated + mu_P;
plot(x_rotated, y_rotated, 'r-', 'LineWidth', 3);
plot(mu_T,mu_P,'k*','LineWidth',4)
ellipse_name = append(string(confidence_level),' uncertainty ellipse');
legend('Misfit map','Monte Carlo points of minimum misfit',ellipse_name,'Mean P-T point')
title('Grid-search results')


% Plot boxplots
if boxplots == 1
    subplot(3,2,5)
    boxplot(t_best,'Orientation','horizontal')
    t = append(string(mu_T),' ± ',string(std_T),' °C (1 s.d.)');
    title(t)
    xlabel('Temperature (°C)')
    subplot(3,2,6)
    boxplot(p_best,'Orientation','horizontal')
    t = append(string(mu_P),' ± ',string(std_P),' bar (1 s.d.)');
    title(t)
    xlabel('Pressure (bars)')

% Or plot histograms
else
    % T
    subplot(3,2,5)
    m1hmin = min(t_best);
    m1hmax = max(t_best);
    Dm1bins = (m1hmax - m1hmin)/(Nbins - 1);
    m1bins = m1hmin + Dm1bins*[0:Nbins-1]';
    m1hist = hist(t_best,m1bins);
    pm1 = m1hist/(Dm1bins*sum(m1hist));
    Pm1 = Dm1bins*cumsum(pm1);
    m1low = m1bins(find(Pm1>0.025,1));
    m1high = m1bins(find(Pm1>0.975,1));
    top_Y = max(m1hist + 0.02*max(m1hist));
    histfit(t_best,Nbins,'kernel'); hold on
    ylim([0 top_Y])
    line([m1low, m1low], [0,top_Y],'Color', 'r', 'LineStyle', '--','LineWidth',2)
    t = append(string(mu_T),' ± ',string(std_T),' °C (1 s.d.)');
    title(t)
    xlabel('Temperature (°C)')
    legend('Histogram','Fitted kernel','95% confidence')
    
    % P
    subplot(3,2,6)
    m1hmin = min(p_best);
    m1hmax = max(p_best);
    Dm1bins = (m1hmax - m1hmin)/(Nbins - 1);
    m1bins = m1hmin + Dm1bins*[0:Nbins-1]';
    m1hist = hist(p_best,m1bins);
    pm1 = m1hist/(Dm1bins*sum(m1hist));
    Pm1 = Dm1bins*cumsum(pm1);
    m1low = m1bins(find(Pm1>0.025,1));
    m1high = m1bins(find(Pm1>0.975,1));
    top_Y = max(m1hist + 0.02*max(m1hist));
    histfit(p_best,Nbins,'kernel'); hold on
    ylim([0 top_Y])
    line([m1low, m1low], [0,top_Y],'Color', 'r', 'LineStyle', '--','LineWidth',2)
    line([m1high, m1high], [0,top_Y],'Color', 'r', 'LineStyle', '--','LineWidth',2)
    t = append(string(mu_P),' ± ',string(std_P),' bar (1 s.d.)');
    title(t)
    xlabel('Pressure (bars)')
    legend('Histogram','Fitted kernel','95% confidence')

end

% Plot results on the contour plot
fig3 = figure(3);
load('output_variables\percentage_overlap.mat');
pcolor(X,Y,p_field); shading flat; c = colorbar; hold on
c.Label.String = 'Percentage of observations which overlap';
plot(t_best(:,1),p_best(:,1),'k.','MarkerSize',10);
xlabel('Temperature (°C)')
ylabel('Pressure (bars)'); hold off
title('Best-fit solutions and overlapping contours')

% Save plots and PT solutions
saveas(fig1,"FIGURES/model_grid.pdf");
saveas(fig2,"FIGURES/grid_solution.pdf");
saveas(fig3,"FIGURES/contour_solution.pdf");
T = table(t_best, p_best, 'VariableNames', {'Temperature (°C)', 'Pressure (bar)'});
writetable(T,'output_variables/PT_solutions.csv');
disp('FINISHED')

