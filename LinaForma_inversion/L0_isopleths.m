%% This script will show overlap between different probe data fields and thermobarometers
clear;clc;

%%%%%%%%% INPUTS %%%%%%%%%
% ====== Data ======
model = 'inputs/forward_model.csv'; % Forward models.
measurements = 'inputs/measurement_distributions.csv'; % Measurements

% ====== Data type ======
raw = 1; % What type of data do you have? 1 = all measurements. 0 = mean and std. of variables.

% ====== Range of values (only applicable if raw = 0) ======
sd = 0.5; % Range of values given as standard deviation from the mean

% ====== PLOTS ======
% PLOT 1 = percentage overlap plot
all1 = 0; % Do you want to plot all of the variables? 1 = YES, 0 = NO.
columns1 = [1,2,3,4]; % List the columns you want to plot, beginning from first variable. Only relevant if all = 0.

% PLOT 2 = individual isopleths
all2 = 0; % Do you want to plot all of the variables? 1 = YES, 0 = NO.
columns2 = [1,2,3,4]; % List the columns you want to plot, beginning from first variable. Only relevant if all = 0.

% PLOT 3 will use the contours from Plot2 and the max. percentage from 
% Plot1


%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%

% Read in data
input = readtable(model,'VariableNamingRule','preserve');
input = sortrows(input,2);
forward_model = readmatrix(model);
forward_model = sortrows(forward_model,2);

if raw == 1
    measurements = readmatrix(measurements); 
    if isnan(measurements(1,1))
        error('This data only contains MEAN or STD information, not real measurements.')
    end
else
    measurements = readtable(measurements,'ReadRowNames',true);
    variables = measurements.Properties.RowNames;
    if ~any(strcmp(variables, 'MEAN'))
        error('This data does not contain MEAN or STD information.')
    end
    all_mean = measurements('MEAN',:);
    all_std = measurements('STD',:);
    max_samples = all_mean{"MEAN",:} + sd * all_std{"STD",:};
    min_samples = all_mean{"MEAN",:} - sd * all_std{"STD",:};
    measurements = [max_samples;min_samples];
end

% Create P-T grid
temperature = forward_model(:,1);
T = unique(temperature); T = T(~isnan(T)); ix = length(T);
pressure = forward_model(:,2);
P = unique(pressure); P = P(~isnan(P)); iy = length(P);
[X,Y] = meshgrid(T,P);


% Remove T and P columns from contour_data and inputs
forward_model = forward_model(:,3:end);
input = input(:,3:end);
variables_all = input.Properties.VariableNames;


% Find which model areas fit the observations
for i = 1:size(forward_model,2)
    model = forward_model(:,i);
    observed = measurements(:,i);
    model_fit = zeros([length(temperature) 1]);

    if sum(isnan(observed)) > 0
        model_fit(model == observed(1,1)) = 1;
    else
        model_fit(model > min(observed) & model < max(observed)) = 1;
    end
    model_comparison(:,i) = model_fit;
    model_comparison(model_comparison == 0) = NaN;
end


% Choosing fields to include in PLOT 1
if all1 == 1
fields = model_comparison;
variables = variables_all;
else
fields = model_comparison(:,columns1);
variables = variables_all(:,columns1);
end

% Field overlap combinations
[idx,idy]=meshgrid(1:width(fields));
idx=tril(idx);idx(idx==0)=[];
idy=tril(idy);idy(idy==0)=[];

% Find overlap areas
overlap_variables = zeros([max(idx) max(idy)]);
loop = 0;
for i = 1:length(idx)
    f1 = idx(i);
    f2 = idy(i);
    field1 = fields(:,f1);
    field1(field1 == 0) = -1;
    field2 = fields(:,f2);
    field2(field2 == 0) = -2;
    t = find(field1 == field2);
    if sum(t) ~= 0
        overlap_variables(f1,f2) = 1;
    end
end
overlap_variables = triu(overlap_variables,1);


% Calculate percentage plot
fields(isnan(fields)) = 0;
percentage_field = sum(fields,2)/size(fields,2)*100;
maxT = temperature(percentage_field == max(percentage_field));
maxP = pressure(percentage_field == max(percentage_field));
fig1 = figure(1);
set(fig1,'Units','centimeters')
set(fig1,'Position',[0 0 0.9*21 0.9*21])
p_field = reshape(percentage_field,[ix iy])';
map = +Functions_NO_EDIT.viridis;
pcolor(X,Y,p_field); shading flat; colormap(map); c = colorbar; c.Label.String = 'Percentage'; hold on
xlabel('Temperature (°C)')
ylabel('Pressure (bars)')
n = size(fields,2);
sole_field = 1/n *100;
st = append('n compositional fields = ',string(n),'  |   1 field = ', ...
    string(sole_field),'%   |   Max = ',string(max(percentage_field)),'% (i.e., ', ...
    string(max(sum(fields,2))),' fields)');
title('Percentage of fields in a given area')
subtitle(st)
axis square
sTable = array2table(overlap_variables,'RowNames',variables,'VariableNames',variables);


% Choosing fields to include in PLOT 2
if all2 == 1
fields = model_comparison;
variables = variables_all;
else
fields = model_comparison(:,columns2);
variables = variables_all(:,columns2);
end


% Plotting fields
map = Functions_NO_EDIT.linspecer(size(fields,2));
loop = -1;
fig2 = figure(2);
set(fig2,'Units','centimeters')
set(fig2,'Position',[0 0 0.9*21 0.9*21])
for i = 1:size(fields,2)
    loop = loop + 1;
    field = reshape(fields(:,i),[ix iy]);
    field = field';
    field(field == 0) = NaN;
    field = field + loop;
    p1 = pcolor(X,Y,field); shading flat; hold on;colormap(map)
    p1.FaceAlpha = 0.4;
end
legend(variables)
axis square
xlabel('Temperature (°C)')
ylabel('Pressure (bars)')
title('Isopleth fields')


% Choosing fields to include in PLOT 3
if all2 == 1
contour_fields = forward_model;
fields = model_comparison;
variables = variables_all;
else
contour_fields = forward_model(:,columns2);
fields = model_comparison(:,columns2);
variables = variables_all(:,columns2);
end


% PLOT 3
fig3 = figure(3);
set(fig3,'Units','centimeters')
set(fig3,'Position',[0 0 0.9*21 0.9*21])
overlap = sum(fields,2);
max_overlap = max(overlap);
overlap(overlap ~= max_overlap) = NaN;
overlap = reshape(overlap,[ix iy]);
overlap = overlap';
p1 = pcolor(X,Y,overlap); shading flat; hold on;

map =  Functions_NO_EDIT.linspecer(size(contour_fields,2));
for iii = 1:size(contour_fields,2)
    tmp = reshape(contour_fields(:,iii),[ix iy]);
    tmp = tmp';
    [R,e] = contour(X,Y,tmp,'Color',map(iii,:));
    clabel(R,e,'Color',map(iii,:));  
    hold on;
end
leg = [{'Overlap area'},variables(:)'];
legend(leg)
axis square
xlabel('Temperature (°C)')
ylabel('Pressure (bars)')
title('Contour plot with overlap')

% Save table and figures
save("output_variables/percentage_overlap.mat",'X','Y','p_field');
saveas(fig1,"FIGURES/percentage_overlap.pdf");
saveas(fig2,'FIGURES/overlapping_fields.pdf');
saveas(fig3,'FIGURES/contours_overlap.pdf');
disp('FINISHED')

