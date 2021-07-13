function [data, dffBdff, thetaBdff, SWBdff, powBdff] = cut_by_quantiles(fullPath, channel, state, num_quantiles, quantilesBy)
% Cuts the signal into 4 sec windws, and then breaks it into quantiles.

% fullPath - the path of the mouse data
% channel - the wanted EEG channel (0 / 1)
% state - choose from {'W','N','R'}
% num_quantiles - standrd is 4
% quantilesBy - by what are the quantiles chosen, choose from {'SW', 'theta', 'dff'}


allowed_quantiles_divide = ["dff", "theta", "SW"];

if (~any(strcmp(quantilesBy,allowed_quantiles_divide)))
    error("Problem with chosen quantilesBy!")
end


data = cut_signals_to_windows(fullPath,channel,state);

dff=data.dff;
theta=data.alpha;
pow=data.pow;
SW=data.SW;

%% Divide dff data to quantiles, align rest of data accordingly and average

[~, sorted_indices] = sort(eval(quantilesBy));

end_cut = 0;
for i=1:num_quantiles
    start_cut = end_cut + 1;
    end_cut = round(numel(sorted_indices)*i/4);
    qunatile_indices = sorted_indices(start_cut:end_cut);    % Can't initialize before, cause it might not divide exactly into num_of_quantiles and so won't be a matrix
    thetaBdff(i) = mean(theta(qunatile_indices));
    SWBdff(i) = mean(SW(qunatile_indices));
    dffBdff(i) = mean(dff(qunatile_indices));
    
    % Go from ACC to power spectrum:
    % divide dff data to quarters, align power accordingly and average
    powBdff(i, :) = mean(pow(qunatile_indices,:));
end

end