% Run Theriak
clear;clc

%%%%%%%%% INPUTS %%%%%%%%%
% ====== Run parameters ======
directory = 'C:/Users/tober/OneDrive - Nexus365/Projects/Lina Forma/software_package/EXTRA_TD_tools/E3_loop_THERIAK/THERIAK_automation/'; % This needs to be the 
% full-path to the folder containing your THERIAK-DOMINO programs
database = 'td_pelite.txt';     % This should match the name of the database file in the automation folder
path = 'PT_path.csv';   % This should be a csv file with the path info. Grids can be created using script E3a.
mac = 1; % Are you using a MAC or WINDOWS machine? Mac = 1, Windows = 0;

%%%%%%%%%%%%%%%%%%%%% CODE %%%%%%%%%%%%%%%%%%%%
%%%% BEST NOT TO ALTER UNLESS YOU ARE SURE %%%%

% WRITE AUTOMATE_THERIAK.sh file
path = readmatrix(path);
T = path(:,1); P = path(:,2);
name1 = append(directory,'automate_theriak.sh');
if mac == 0
    string1 = append('cd "',directory,'"\n"',directory,'"theriak.exe <automate.txt');
elseif mac == 1
    string1 = append('cd "',directory,'"\n"',directory,'"theriak <automate.txt');
end
autoID1 = fopen(name1,'w');
fprintf(autoID1,string1);
fclose(autoID1);

% WRITE automat.txt file
name2 = append(directory,'/automate.txt');
string2 = append(database,'\nptpoint.txt','\naut');
autoID2 = fopen(name2,'w');
fprintf(autoID2,string2);
fclose(autoID2);

for i = 1:length(P)

    % Create P-T point file
    clc;
    name3 = append(directory,'/ptpoint.txt');
    string3 = append('TP  ',string(T(i)),'  ',string(P(i)));
    autoID3 = fopen(name3,'w');
    fprintf(autoID3,string3);
    fclose(autoID3);

    % Run Theriak at this new point
    path = append(directory,'automate_theriak.sh');
    status = system(['bash "',path]);

    % Save output into file
    results = append(directory,"thktab.tab");
    if i == 1
        [data,varnames,casenames]  = tblread(results,',');
        data1 = array2table(data,'VariableNames',cellstr(varnames)');
    elseif i == 2
        [data,varnames,casenames]  = tblread(results,',');
        data2 = array2table(data,'VariableNames',cellstr(varnames)');
        data1 = outerjoin(data1, data2,'MergeKeys',true);
    else
        [data,varnames,casenames]  = tblread(results,',');
        data3 = array2table(data,'VariableNames',cellstr(varnames)');
        data1 = outerjoin(data1, data3,'MergeKeys',true);
    end
end
        
% Replace NaN
data_nan = table2array(data1);
data_nan(isnan(data_nan)) = 0;
final_table = array2table(data_nan,'VariableNames',data1.Properties.VariableNames');
final_table = sortrows(final_table,2);

% Save data
output = 'THERIAK_models.csv';
writetable(final_table,output);
disp("FINSIHED")



