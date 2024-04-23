% Convert composition from wt% to mole percent
function st = comp_calc_DO_NOT_EDIT(input,csv)

% Input wt%
if csv == 1
    input = readmatrix(input);
end
oxide_wt = input(1,1:11); 

% Oxide RFM
oxide_RFM = [60.09, 79.9, 101.94, 71.85, 159.7, 70.94, 40.32, 56.08, 61.982, 94.2, 18];

% Cations per mole of oxide
cation = [1, 1, 2, 1, 2, 1, 1, 1, 2, 2, 2];
cation_name = {'SI','TI','AL','FE','MN','MG','CA','NA','K','H'};

% Oxygen anions per mole of oxide
oxygen = [2, 2, 3, 1, 3, 1, 1, 1, 1, 1, 1];

% Input values
xfe3 = input(1,12);
feT = input(1,4);
h2o = input(1,13);

% Normalise to without Fe
oxide_noFe = oxide_wt; oxide_noFe(1,4) = 0;
oxide_noFe = oxide_noFe./sum(oxide_noFe)*100;

% Calculate Fe2O3 and FeO
Fe3 = xfe3 * (oxide_RFM(1,5)/(2*oxide_RFM(1,4))) * feT;
Fe2 = (1-xfe3) * feT;
FeWT = Fe3 + Fe2;

% Add to wt%, and re-normalize
oxide_Fe = (100 - FeWT)*oxide_noFe/100;
oxide_Fe(1,4) = Fe2; oxide_Fe(1,5) = Fe3;

% Make anhydrous
oxide_anhy = oxide_Fe; 
oxide_anhy(1,11) = 0;
oxide_anhy = oxide_anhy./sum(oxide_anhy)*100;

% Make hydrous
oxide_hy = (100 - h2o)*oxide_anhy/100;
oxide_hy(1,end) = h2o;

% Calculate moles of oxide
moles = oxide_hy./oxide_RFM;

% Calculate mole percent
mol_percent = moles./sum(moles)*100;

% Ion moles
cation_moles = mol_percent .* cation;
cation_moles(:,4) = cation_moles(:,4) + cation_moles(:,5);
cation_moles = [cation_moles(:,1:4),cation_moles(:,6:end)];
oxygen = mol_percent .* oxygen;

% Concatenate
for i = 1:length(cation_moles)
    st{i} = append(cation_name{i},'(',string(cation_moles(i)),')');
end
st = append(st{:},'O','(',string(sum(oxygen)),')');

end


