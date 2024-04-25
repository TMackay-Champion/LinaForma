%% This script will show overlap between different probe data fields and thermobarometers
clear;clc;

%%%%%%%%% INPUTS %%%%%%%%%
% data
model = 'inputs/forward_model.csv';
observations = 'inputs/observations.csv';

% parameters
all = 0; % Do you want to plot all of the variables? 1 = YES, 0 = NO
columns = [1,2,3,4]; % List the columns you are interested in. Will only be selected if all = 0.


%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%

% Read in data
input = readtable(model,'VariableNamingRule','preserve');
contour_data = readmatrix(model);
probe_data = readmatrix(observations);

% Create P-T grid
temperature = contour_data(:,1);
T = unique(temperature); T = T(~isnan(T)); ix = length(T);
pressure = contour_data(:,2);
P = unique(pressure); P = P(~isnan(P)); iy = length(P);
[X,Y] = meshgrid(T,P);


% Remove T and P columns from contour_data and inputs
contour_data = contour_data(:,3:end);
input = input(:,3:end);
variables_all = input.Properties.VariableNames;


% Find which model areas fit the probe data
for i = 1:size(contour_data,2)
    model = contour_data(:,i);
    observed = probe_data(:,i);
    model_fit = zeros([length(temperature) 1]);

    if sum(isnan(observed)) > 0
        model_fit(model == observed(1,1)) = 1;
    else
        model_fit(model > min(observed) & model < max(observed)) = 1;
    end
    model_comparison(:,i) = model_fit;
    model_comparison(model_comparison == 0) = NaN;
end


% Choosing fields to plot
if all == 1
fields = model_comparison;
variables = variables_all;
else
fields = model_comparison(:,columns);
variables = variables_all(:,columns);
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
p_field = reshape(percentage_field,[ix iy])';
pcolor(X,Y,p_field); shading flat; colorbar; hold on
xlabel('Temperature (°C)')
ylabel('Pressure (bars)')
n = size(fields,2);
sole_field = 1/n *100;
st = append('n compositional fields = ',string(n),'  |   1 field = ', ...
    string(sole_field),'%   |   Max = ',string(max(percentage_field)),'% (i.e., ', ...
    string(max(sum(fields,2))),' fields)');
title('% of fields in a given area')
subtitle(st)
axis square

% Plotting fields
map = Functions_NO_EDIT.linspecer(size(fields,2));
loop = -1;
fig2 = figure(2);
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
xlabel('Temperature (°C)')
ylabel('Pressure (bars)')

sTable = array2table(overlap_variables,'RowNames',variables,'VariableNames',variables);

% Plotting max overlap area
fig3 = figure(3);
overlap = sum(fields,2);
max_overlap = max(overlap);
overlap(overlap ~= max_overlap) = NaN;
overlap = reshape(overlap,[ix iy]);
overlap = overlap';
p1 = pcolor(X,Y,overlap); shading flat; hold on;

if all == 1
contour_fields = contour_data;
variables = variables_all;
else
contour_fields = contour_data(:,columns);
variables = variables_all(:,columns);
end

map =  Functions_NO_EDIT.linspecer(size(contour_fields,2));
for iii = 1:size(contour_fields,2)
    tmp = reshape(contour_fields(:,iii),[ix iy]);
    tmp = tmp';
    [R,e] = contour(X,Y,tmp,'Color',map(iii,:));
    clabel(R,e,'Color',map(iii,:));  
    hold on
end
leg = [{'Overlap area'},variables(:)'];
legend(leg)
xlabel('Temperature (°C)')
ylabel('Pressure (bars)')
title('Contour plot, with peak field')

% Save table and figures
save("output_variables/percentage_overlap.mat",'X','Y','p_field');
saveas(fig1,"FIGURES/percentage_overlap.pdf");
saveas(fig2,'FIGURES/overlapping_fields.jpeg');
disp('FINISHED')
