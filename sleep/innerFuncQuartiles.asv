function [data,dffBdff,thetaBdff,SWBdff,powBdff]=innerFuncQuartiles(fullPath,channel,state, num_of_quantiles)
% cut normalized_gcamp and eeg into 4 sec increments.
% each increment gets: average dff,power spectrum, average theta power,
% average SW power.
% correlation between sleep depth and ACC activation for each mouse

data = cut_signals_to_windows(fullPath,channel,state);

dff=data.dff;
theta=data.alpha;
pow=data.pow;
SW=data.SW;

%% go from activation to SW and theta:
% divide dff data to quarters, align powers accordingly and average

[~, sorted_indices] = sort(dff);
end_cut = 0;
for i=1:num_of_quantiles
    start_cut = end_cut + 1;
    end_cut = round(numel(sorted_indices)*i/4);
    qunatile_indices = sorted_indices(start_cut:end_cut);    %Can't initialize before, cause it might not divide exactly into num_of_quantiles and so won't be a matrix
    thetaBdff(i) = mean(theta(qunatile_indices));
    SWBdff(i) = mean(SW(qunatile_indices));
    dffBdff(i) = mean(dff(qunatile_indices));
    
    % go from ACC to power spectrum:
    % divide dff data to quarters, align power accordingly and average
    powBdff(i, :) = mean(pow(qunatile_indices,:));
end

end