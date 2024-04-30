% This script runs the grid-search and bootstrapping uncertainty
clear;clc;

%%%%%%%%% INPUTS %%%%%%%%%
% ====== Data ======
model = 'inputs/forward_model.csv'; % Forward models.
measurements = 'inputs/measurement_distributions.csv'; % Measurements

% ====== Data type ======
raw = 0; % What type of data do you have? 1 = all measurements. 0 = mean and std. of variables.

% ====== Bootstrapping parameters ======
bootstrap_type = 1;      % Parametric = 1, non-parametric = 0. Only parametric is available if raw = 0.
it = 500;        % How many random iterations do you want to calculate?

% ====== PLOTS ======
confidence_level = 0.68;  % Confidence level for 2D ellipse
boxplots = 0;   % Do you want boxplots or histograms? 1 = boxplot, 0 = histogram
Nbins = 5;  % Number of histogram bins. Only used if boxplots = 0
plot_type = 0; % What type of plot do you want? 1 = contour plot, 0 = heatmap;
resT = 10; % Width of temperature (°C) bins in 2D histogram (Figure 4)
resP = 100; % Width of pressure (bar) bins in 2D histogram (Figure 4)


%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%%

%%%% PART 1: Input the data and create the Pressure-temperature grid %%%%
% Read in data
model = readtable(model); model = sortrows(model,2);

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

% Read in measurements
if raw == 0
    syn = readtable(measurements,'ReadRowNames',true);
    var_tmp = syn.Properties.RowNames;
    if ~any(strcmp(var_tmp, 'MEAN'))
        error('This data does not contain MEAN or STD information.')
    end
    syn_mean = table2array(syn(1,:)); syn_sigma =table2array(syn(2,:));
else
    measurements = readtable(measurements);
    var_tmp = measurements.Properties.VariableNames;
    if any(strcmp(var_tmp, 'Statistic'))
        error('This data only contains MEAN or STD information.')
    end
    obs = table2array(measurements);

end

% Bootstrapping
if bootstrap_type == 1 % Parametric bootstrapping
    % Find mean and standard deviation of distribution
    if raw == 0
        sigma = syn_sigma; mu = syn_mean;
    else
        sigma = std(obs,1); mu = mean(obs,1);
    end
    samples = +Functions_NO_EDIT.gaussian_boot(it,mu,sigma);
elseif bootstrap_type == 0 % Non-parametric
    if raw ~= 1
        error('Non-parametric bootstrapping is not possible on this dataset.')
    end
    samples = bootstrp(it,@mean,obs);
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
set(fig1,'Units','centimeters')
set(fig1,'Position',[0 0 0.9*21 0.9*21])
plot(X,Y,'ko');
xlabel('Temperature (°C)')
ylabel('Pressure (bar)')
minY = min(Y,[],'all'); maxY = max(Y,[],'all');
minX = min(X,[],'all'); maxX = max(X,[],'all');
ylim([(minY-0.05*maxY) (maxY+0.05*maxY)])
xlim([(minX-0.05*maxX) (maxX+0.05*maxX)])
axis square
title('Model grid')


% Plot the misfit surface
fig2 = figure(2);
map = +Functions_NO_EDIT.viridis;
set(fig2,'Units','centimeters')
set(fig2,'Position',[0 0 0.9*21 0.9*21])
subplot(3,2,[1 2 3 4])
res = reshape(log(model_misfit),[ix iy])';
if plot_type == 1
    contourf(X,Y,res);
else
    pcolor(X,Y,res); shading flat
end
colormap(flipud(map)); hold on
c = colorbar;
c.Label.String = 'Log misfit';
axis square
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

% Mode calculation
mode(1,1) = median(t_best);
mode(1,2) = median(p_best);


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
plot(mu_T,mu_P,"pentagram",'MarkerFaceColor','yellow','MarkerEdgeColor','k','MarkerSize',20)
plot(mode(1,1),mode(1,2),"pentagram",'MarkerFaceColor','blue','MarkerEdgeColor','k','MarkerSize',20)
ellipse_name = append(string(confidence_level),' uncertainty ellipse');
legend('Misfit map','Monte Carlo points of minimum misfit',ellipse_name,'Mean P-T point','Median P-T point')
title('Grid-search results')


% Round mean and standard deviations
mu_T = ceil(mu_T/5)*5;
mu_P = ceil(mu_P/5)*5;
std_T = ceil(std_T/5)*5; 
std_P = ceil(std_P/5)*5;


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
set(fig3,'Units','centimeters')
set(fig3,'Position',[0 0 0.9*21 0.9*21])
load('output_variables\percentage_overlap.mat');
pcolor(X,Y,p_field); colormap(map); shading flat; c = colorbar; hold on
c.Label.String = 'Percentage of observations which overlap';
plot(t_best(:,1),p_best(:,1),'k.','MarkerSize',10);
plot(mu_T,mu_P,"pentagram",'MarkerFaceColor','yellow','MarkerEdgeColor','k','MarkerSize',20)
plot(mode(1,1),mode(1,2),"pentagram",'MarkerFaceColor','blue','MarkerEdgeColor','k','MarkerSize',20)
axis square
xlabel('Temperature (°C)')
ylabel('Pressure (bars)'); hold off
title('Best-fit solutions and overlapping contours')
legend('Contour plot','best-fit solutions','Mean best-fit solution','Median best-fit solution')

% Plot grid of results
fig4 = figure(4);
set(fig4,'Units','centimeters')
set(fig4,'Position',[0 0 0.9*21 0.9*21])
histogram2(t_best(:,1),p_best(:,1),'DisplayStyle','tile','ShowEmptyBins','on','BinWidth',[resT resP]); 
colormap(map)
c = colorbar;
c.Label.String = 'Log number of solutions'; hold on
set(gca,'ColorScale','log')
plot(mu_T,mu_P,"pentagram",'MarkerFaceColor','yellow','MarkerEdgeColor','k','MarkerSize',20)
plot(mode(1,1),mode(1,2),"pentagram",'MarkerFaceColor','blue','MarkerEdgeColor','k','MarkerSize',20)
axis square
xlabel('Temperature (°C)')
ylabel('Pressure (bar)')
title('Best-fit solution 2D histogram')
legend('2D histogram','Mean best-fit solution','Median best-fit solution');


% Save plots and PT solutions
saveas(fig1,"FIGURES/model_grid.pdf");
saveas(fig2,"FIGURES/grid_solution.pdf");
saveas(fig3,"FIGURES/contour_solution.pdf");
saveas(fig4,"FIGURES/solution_2Dhistogram.pdf");
T = table(t_best, p_best, 'VariableNames', {'Temperature (°C)', 'Pressure (bar)'});
writetable(T,'output_variables/PT_solutions.csv');
disp('FINISHED')

