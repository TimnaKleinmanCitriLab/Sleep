function [data,dffBdff,thetaBdff,SWBdff,powBdff]=cut_FP_by_EEG_quantiles(fullPath,channel,state, num_of_quantiles)
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

[~, sorted_indices] = sort(theta);

end_cut = 0;
for i=1:num_of_quantiles
    start_cut = end_cut + 1;
    end_cut = round(numel(sorted_indices)*i/4);
    qunatile_indices(i) = sorted_indices(start_cut:end_cut);    %Can't initialize before, cause it might not divide exactly into num_of_quantiles and so won't be a matrix
end

thetaBdff=[mean(theta(f1)),mean(theta(f2)),mean(theta(f3)),mean(theta(f4))];
SWBdff=[mean(SW(f1)),mean(SW(f2)),mean(SW(f3)),mean(SW(f4))];
dffBdff=[mean(dff(f1)),mean(dff(f2)),mean(dff(f3)),mean(dff(f4))];
%% go from ACC to power spectrum:
% divide dff data to quarters, align power accordingly and average

powBdff=[mean(pow(f1,:));mean(pow(f2,:));mean(pow(f3,:));mean(pow(f4,:))];

end