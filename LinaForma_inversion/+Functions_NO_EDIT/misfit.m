% This function calculate the misfit between the model and the observations
function m = misfit(model,observations)

m = sum(sqrt(((model - observations)./observations).^2),'all');

end