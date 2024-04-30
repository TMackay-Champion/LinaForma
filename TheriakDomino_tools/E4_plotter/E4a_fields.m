% This script will plot the assemblage and allow you to check where fields
% are
clear;clc;

%%%%%%%%% INPUTS %%%%%%%%%
% ====== Data ======
model = 'forward_models.csv';

% ====== PLOTS ======
% Plot stability field of particular phase?
phase = 0; % 1 = YES; 0 = NO
mineral = 'GRT'; % This corresponds to the name given to the mineral in the database

% Plot stability field of particular assemblage?
field = 0; % 1 = YES; 0 = NO
f_no = 25; % This corresponds to the field number provided by DOMINO in pixa.txt.

% Plot pseudosection and variance?
%%% If you click on the pseudosection, MATLAB will print the equilibrium
%%% phase assemblage
assemblage = 1; % 1 = YES; 0 = NO
components = 10; % Give the number of components of the system


%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%
% Read in data and construct P-T grid
input = readmatrix(model);
input = sortrows(input,2);
input1 = readtable(model,'VariableNamingRule','preserve');
input1 = sortrows(input1,2);

% Construct P-T grid
temperature = input(:,1);
pressure = input(:,2);
[X,Y] = meshgrid(unique(temperature),unique(pressure));
ix = size(X,2);
iy = size(Y,2);

% Assemblage info.
if phase == 1
fig1 = figure(1);
set(fig1,'Units','centimeters')
set(fig1,'Position',[0 0 0.9*21 0.9*21])
data5a = input(:,3);
ass = input1(:,4);
matchingRows = contains(ass.Assemblage, mineral);
data5 = double(matchingRows);
data5 = reshape(data5,[ix iy]);
data5 = data5';
data5(data5 == 0) = NaN;
pcolor(X,Y,data5);shading flat;hold on
t = append(mineral,' stability field');
title(t);
axis square
xlabel('Temperature (°C)')
ylabel('Pressure (bars)')
file = append('FIGURES/',mineral,'_stability.pdf');
saveas(figure(1),file);
end

if field == 1
fig2 = figure(2);
set(fig2,'Units','centimeters')
set(fig2,'Position',[0 0 0.9*21 0.9*21])
data5a = input(:,3);
ass = input(:,3);
phases = input1(:,4);
phases  = phases(find(ass == f_no),"Assemblage");
phases = phases(1,'Assemblage');
phases = table2cell(phases);
matchingRows = (ass == f_no);
data5 = double(matchingRows);
data5 = reshape(data5,[ix iy]);
data5 = data5';
data5(data5 == 0) = NaN;
pcolor(X,Y,data5);shading flat;hold on
title(phases);
axis square
xlabel('Temperature (°C)')
ylabel('Pressure (bars)')
file = append('FIGURES/Field',string(f_no),'_stability.pdf');
saveas(figure(2),file);
end


% Pseudosection
if assemblage == 1
fig3 = figure(3);
set(fig3,'Units','centimeters')
set(fig3,'Position',[0 0 0.9*21 0.9*21])
data5a = input(:,3);
data5 = reshape(data5a,[ix iy]);
data5 = data5';
data5(data5 == 0) = NaN;
eq = table2cell(input1(:,'Assemblage'));
map = DO_NOT_EDIT(length(unique(data5a)));
hP = pcolor(X,Y,data5); shading flat;colormap(map); hold on
text(800,900,'text')
set(hP, 'ButtonDownFcn',@(~,~)clickCallback(temperature,pressure,eq));
field_range = 1:max(input(:,3));
c.Ticks = field_range(1:2:end);
c.Label.String = 'Assemblage fields';
title("Pseudosection");
axis square
xlabel('Temperature (°C)')
ylabel('Pressure (bars)')
saveas(figure(3),'FIGURES/assemblage.pdf')

% Variance
fig4 = figure(4);
set(fig4,'Units','centimeters')
set(fig4,'Position',[0 0 0.9*21 0.9*21])
phases = input1(:,5); phases = table2array(phases);
variance = components - phases + 2;
data5 = reshape(variance,[ix iy]);
data5 = data5';
data5(data5 == 0) = NaN;
hP = pcolor(X,Y,data5); shading flat;colormap(gray); colorbar; hold on
hP.ZData = hP.CData;
field_range = 1:max(input(:,3));
c.Ticks = field_range(1:2:end);
c.Label.String = 'Assemblage fields';
title('Variance')
xlabel('Temperature (°C)')
ylabel('Pressure (bars)')
saveas(figure(4),'FIGURES/variance.pdf')

end

function clickCallback(temperature,pressure,Z)
    % Get the clicked point
    clickedPoint = get(gca, 'CurrentPoint');
    x = clickedPoint(1,1);
    y = clickedPoint(1,2);
    
    % Find closest temp.
    absolute_diff = abs(x - temperature);
    [~, index_closest] = min(absolute_diff);
    t = temperature(index_closest);

    % Find closest pressure
    absolute_diff = abs(y - pressure);
    [~, index_closest] = min(absolute_diff);
    p = pressure(index_closest);

    index = find(temperature == t & pressure == p);
    ass = Z(index);

    % Display label at the clicked point
    disp(ass)
    text(x, y, ass, 'Color', 'black', 'FontSize', 12, 'FontWeight', 'bold');
end
