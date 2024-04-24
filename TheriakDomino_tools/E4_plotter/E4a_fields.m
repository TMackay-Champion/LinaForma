% This script will plot the assemblage and allow you to check where fields
% are
clear;clc;

%%% INPUTS. PLEASE ALTER %%%
input_file = 'forward_models.csv';

% Plot stability field of particular phase?
phase = 1; % 1 = YES; 0 = NO
mineral = 'GRT'; % This corresponds to the name given to the mineral in the database

% Plot stability field of particular assemblage?
field = 1; % 1 = YES; 0 = NO
f_no = 25; % This corresponds to the field number provided by DOMINO in pixa.txt.

% Plot variance?
assemblage = 1; % 1 = YES; 0 = NO
components = 10; % !!! Give the number of components of the system


%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%
% Read in data and construct P-T grid
input = readmatrix(input_file);
input1 = readtable(input_file);

% Construct P-T grid
temperature = input(:,1);
pressure = input(:,2);
[X,Y] = meshgrid(unique(temperature),unique(pressure));
ix = size(X,2);
iy = size(Y,2);

% Assemblage info.
if phase == 1
    figure(1)
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
xlabel('Temperature (°C)')
ylabel('Pressure (bars)')
file = append('FIGURES/',mineral,'_stability.pdf');
saveas(figure(1),file);
end

if field == 1
    figure(2)
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
xlabel('Temperature (°C)')
ylabel('Pressure (bars)')
file = append('FIGURES/Field',string(f_no),'_stability.pdf');
saveas(figure(2),file);
end



% ASSEMBLAGE FIELDS
if assemblage == 1
figure(3)
data5a = input(:,3);
data5 = reshape(data5a,[ix iy]);
data5 = data5';
data5(data5 == 0) = NaN;
map = DO_NOT_EDIT(length(unique(data5a)));
hP = pcolor(X,Y,data5); shading flat;colormap(map); colorbar; hold on
hP.ZData = hP.CData;
field_range = 1:max(input(:,3));
c.Ticks = field_range(1:2:end);
c.Label.String = 'Assemblage fields';
title("Pseudosection");
xlabel('Temperature (°C)')
ylabel('Pressure (bars)')
saveas(figure(3),'FIGURES/assemblage.pdf')

figure(4)
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



