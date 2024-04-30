%% This script will plot two sets of contour lines, and 1 heatmap (i.e., 3 variables total)
clear;clc;

%%%%%%%%% INPUTS %%%%%%%%%
% ====== Data ======
model = 'forward_models.csv';

% ====== PLOTS ======
% HEATMAP INPUT
do_you_want_to_include4 = 1;
column4 = 10;
var = 'Variance'; % This is the label for the heatmap

% CONTOUR 1 INPUT
do_you_want_to_include1 = 0; % 1 = Yes, 0 = No
column1 = 3; % this is the column of your Excel sheet which you want to plot
auto1 = 1; % 1 = MATLAB chooses the contours, 0 = you need to choose using the options below

if auto1 == 0
    max_contour_line1 = 1.5; % Change these values if you have selected 0 above
    min_contour_line1 = 1.3; % Change these values if you have selected 0 above
    contour_step1 = 0.01; % Change these values if you have selected 0 above
end

% CONTOUR 2 INPUT
do_you_want_to_include2 = 0;
column2 = 4;
auto2 = 1;
if auto2 == 0
    max_contour_line2 = 2500;
    min_contour_line2 = 2100;
    contour_step2 = 50;
end

% CONTOUR 3 INPUT
do_you_want_to_include3 = 0;
column3 = 5;
auto3 = 1;

if auto3 == 0
    max_contour_line3 = 2500;
    min_contour_line3 = 2100;
    contour_step3 = 10;
end

% LEGEND
leg  = {'HEATMAP','Column1','Column2','Column3'}; % This creates a legend for your plot. The order must be 


%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%

% Read in data and construct P-T grid
input = readmatrix(model);
input = sortrows(input,2);

% Construct P-T grid
temperature = input(:,1);
pressure = input(:,2);
[X,Y] = meshgrid(unique(temperature),unique(pressure));
ix = size(X,2);
iy = size(Y,2);


% HEATMAP
fig = figure(1);
data4a = input(:,column4);
data4 = reshape(data4a,[ix iy]);
data4 = data4';
data4(data4 == 0) = NaN;
if do_you_want_to_include4 == 1
    contourf(X,Y,data4,25,'edgecolor','none');shading flat; hold on
    caxis([min(min(data4)) max(max(data4))]);
    c = colorbar;
    c.Label.String = 'var';
end


% CONTOUR1
data1 = input(:,column1);
data1 = reshape(data1,[ix iy]);
data1 = data1';
data1(data1 == 0) = NaN;
if do_you_want_to_include1 == 1
    if auto1 == 1
        [C,h] = contour(X,Y,data1,'r-');
        clabel(C,h,'Color','red'); hold on
    else
        lines1 = min_contour_line1:contour_step1:max_contour_line1;
        [C,h] = contour(X,Y,data1,lines1,'r-');
        clabel(C,h,lines1,'Color','red');
    end
    hold on
end


% CONTOUR2
data2 = input(:,column2);
data2 = reshape(data2,[ix iy]);
data2 = data2';
data2(data2 == 0) = NaN;
if do_you_want_to_include2 == 1
    if auto2 == 1
        [W,m] = contour(X,Y,data2,'b-');
        clabel(W,m,'Color','black'); 
    else
        lines2 = min_contour_line2:contour_step2:max_contour_line2;
        [W,m] = contour(X,Y,data2,lines2,'b-');
        clabel(W,m,lines2,'Color','black');  
    end
    hold on
end
xlabel('Temperature (°C)')
ylabel('Pressure (bars)')

% % CONTOUR3
data3 = input(:,column3);
data3 = reshape(data3,[ix iy]);
data3 = data3';
data3(data3 == 0) = NaN;
if do_you_want_to_include3 == 1
    if auto3 == 1
        [R,e] = contour(X,Y,data3,'g--');
        clabel(R,e,'Color','green'); 
    else
        lines3 = min_contour_line3:contour_step3:max_contour_line3;
        [R,e] = contour(X,Y,data3,lines3,'g--');
        clabel(R,e,lines3,'Color','green');  
    end
end
xlabel('Temperature (°C)')
ylabel('Pressure (bars)')
legend(leg)

% Save figure
saveas(fig,"FIGURES/contour_plot.pdf");
disp('FINISHED')
