function observed_boot = parametric_boot(n,observed,sig)

% For each number of bootstrap re-sampling
for i = 1:n

    % For each point in the observed vector
    for ii = 1:length(observed)
        mu = observed(ii); s = sig(ii);
        distribution = -1;
        while distribution < 0
            distribution = normrnd(mu,s);
        end
        observed_boot(i,ii) = distribution;

    end
end
end