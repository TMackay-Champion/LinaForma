% Convert composition from wt% to mole percent
function st = comp_calc_DO_NOT_EDIT(input,csv,monazite_fraction,h2o)

% Input wt%
if csv == 1
    input = readtable(input,'VariableNamingRule','preserve');
end
input = addvars(input,0, 'Before', 5, 'NewVariableName','Fe2O3');
oxide_wt = input(1,1:12);

%
% Oxide RFM
oxide_RFM = [60.09, 79.9, 101.94, 71.85, 159.7, 70.94, 40.32, 56.08, 61.982, 94.2, 141.94, 18];
oxide_RFM = array2table(oxide_RFM,'VariableNames',oxide_wt.Properties.VariableNames);

% Ions per mole of oxide
cation_name = {'SI','TI','AL','FE2','FE3','MN','MG','CA','NA','K','P','H'};
cation = [1,1,2,1,2,1,1,1,2,2,2,2]; % Cations per mole
oxygen = [2,2,3,1,3,1,1,1,1,1,5,1]; % Oxygen anions per mole
ions = [cation;oxygen];
molecules = array2table(ions,'VariableNames',cation_name,'RowNames',{'Cations','Oxygen'});

% Input values
xfe3 = table2array(input(1,"XFe3+"));
feT = table2array(input(1,'FeO'));

% Remove Fe and normalise wt% (i.e., composition without any Fe)
oxide_noFe = oxide_wt; oxide_noFe.FeO(1) = 0;
noFe_sum = sum(oxide_noFe{1,:});
oxide_noFe{1,:} = oxide_noFe{1,:}./noFe_sum*100;

% Calculate Fe2O3 wt% and FeO wt%
Fe3_rfm = oxide_RFM{1,'Fe2O3'};
Fe2_rfm = oxide_RFM{1,'FeO'};
Fe3 = xfe3 * (Fe3_rfm/(2*Fe2_rfm)) * feT;
Fe2 = (1-xfe3) * feT;
FeWT = Fe3 + Fe2;

% Add Fe2O3 and FeO wt% back to bulk-comp
oxide_Fe = (100 - FeWT)*oxide_noFe{1,:}/100;
oxide_Fe = array2table(oxide_Fe,'VariableNames',oxide_wt.Properties.VariableNames);
oxide_Fe{1,"FeO"} = Fe2; oxide_Fe{1,"Fe2O3"} = Fe3;

% Calculate mole percent
mole_percent = oxide_Fe;
mole_percent{1,:} = oxide_Fe{1,:}./oxide_RFM{1,:};

% Remove P2O5 effects
mol_P2O5 = mole_percent{1,'P2O5'};
mol_CaO = mole_percent{1,'CaO'};
mol_apatite = (1 - monazite_fraction) * mol_P2O5;
mol_P = mol_apatite * 2;
mol_CaP = mol_P/3 * 5;   % Formula for apatite = Ca5(PO4)3(OH). Therefore, 5 x Ca for 3 x P
mole_percent{1,'P2O5'} = 0;
mole_percent{1,"CaO"} = mol_CaO - mol_CaP;

% Remove moles of H2O, then normalize anhydrous mole%
oxide_anhy = mole_percent; 
oxide_anhy{1,'H2O'} = 0;
oxide_anhy{1,:} = oxide_anhy{1,:}./sum(oxide_anhy{1,:})*100;

% Add given mole% of water, then re-normalize
oxide_hy = (100 - h2o)*oxide_anhy{1,:}/100;
oxide_hy = array2table(oxide_hy,'VariableNames',oxide_anhy.Properties.VariableNames);
oxide_hy{1,'H2O'} = h2o;

% Calculate moles of oxide
mol_percent = oxide_hy;

% Ion moles
cation_moles = molecules("Cations",:);
cation_moles{1,:} = mol_percent{1,:}.*molecules{'Cations',:};
oxygen_moles = molecules("Cations",:);
oxygen_moles{1,:} = mol_percent{1,:}.*molecules{"Oxygen",:};
total_Fe = cation_moles{1,"FE2"} + cation_moles{1,"FE3"};
total_oxygen = sum(oxygen_moles{1,:});

% Combine Fe2 and Fe3 in cation table
cation_moles{1,'FE2'} = total_Fe;
cation_moles = renamevars(cation_moles, 'FE2', 'FE');
cation_moles(:, 'FE3') = [];
cation_moles(:, 'P') = [];
variables = cation_moles.Properties.VariableNames;

% Concatenate
for i = 1:width(cation_moles)
    st{i} = append(variables{i},'(',string(round(cation_moles{1,i}, 2)),')');
end
st = append(st{:},'O','(',string(total_oxygen),')');