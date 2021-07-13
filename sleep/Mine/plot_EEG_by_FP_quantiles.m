function plot_EEG_by_FP_quantiles(state, FP_area, EEG_area, num_quantiles)
% Plots the different EEG waves by FP quantiles - similar to the plot in
% the paper only I added shaded error bars (was a sanity check)

% state - choose from {'W','N','R'}
% FP_area - {'ACC', 'OFC'}
% EEG_area - {'frontal', 'parietal'}
% num_quantiles - standrd is 4

COLORS = ['b', 'c', 'g', 'y'];

%% Validation of input tests
allowed_states = {'W', 'N', 'R'};
allowed_FP_areas = {'ACC', 'OFC'};
allowed_EEG_areas = {'frontal', 'parietal'};

if (~any(strcmp(state,allowed_states)) || ~any(strcmp(FP_area,allowed_FP_areas)) || ~any(strcmp(EEG_area,allowed_EEG_areas)))
    error("Problem with chosen area/state!")
end

%% Choose and load data
[mice_paths, mice_names] = get_mice_path_and_names(FP_area);

% Should change path to relavent path !
channels=load('C:\Users\owner\Google Drive\University\ElscLab\Actual Work\Noa Tel Aviv Sleep Project\Open Source\sleep\claustrumEEGch.mat');     

data=cell(length(mice_names));
dffBdff=zeros(length(mice_names), num_quantiles);
thetaBdff=zeros(length(mice_names), num_quantiles);
SWBdff=zeros(length(mice_names), num_quantiles);
powBdff=zeros(length(mice_names), num_quantiles,2000);

% Recieve loaded data
% (powBdff: dim1-mice, dim2-quantiles, dim3-freq)
for iter=1:length(mice_names)
    ID=mice_names{iter};
    channel=channels.claustrumEEGch{EEG_area, ID};
    fullPath=mice_paths{iter};
    [data{iter}, dffBdff(iter,:), thetaBdff(iter,:), SWBdff(iter,:),...
        powBdff(iter,:,:)]=cut_by_quantiles(fullPath, channel, state, num_quantiles, "dff");
end

%% plots

% SW / theta
s2t=SWBdff./thetaBdff;
dffF=figure;set(dffF,'outerposition',[2,42,958,954]);
plot(s2t','--ok');hold on;
plot([1 2 3 4],mean(s2t),'-k');
xlim([0.75 4.25])
ylabel('Slow to Theta Ratio');
set(gca, 'xticklabel' , {'quartile 1','quartile 2','quartile 3','quartile 4'});
xlabel('Activity Level')
box off
set(gca, 'xtick', [1,2,3,4]);
set(gca, 'fontsize',22);

% Plot EEG by FP quantiles - run throw quantiles
quaniles_pow_mean = zeros(num_quantiles,2000);
quaniles_pow_sem = zeros(num_quantiles,2000);

for i = 1:num_quantiles
    quaniles_pow_mean(i, :)= mean(powBdff(:,i,:),1).*100;
    quaniles_pow_sem(i, :) = std(powBdff(:,i,:).*100,[],1)./sqrt(numel(mice_names));
end

powF=figure;
set(powF,'outerposition',[2,42,958,954]);
legends = strings(1, num_quantiles);
for i = 1:num_quantiles
%     plot(data{1}.freq, squeeze(quaniles_pow_mean(i, :)),COLORS(i));
    shadedErrorBar(data{1}.freq, squeeze(quaniles_pow_mean(i, :)), squeeze(quaniles_pow_sem(i, :)), 'lineProps', COLORS(i))
    hold on
    legends(i) = "quartile " + int2str(i);
end
hold off
legend(legends)
ylabel('Relative Power (%)');
xlabel('Frequency (Hz)')
title({"Average EEG by FP Quantiles", "State: " + state + ", FP area: " + FP_area + ", EEG area: " + EEG_area})
xlim([3 12])
set(gca,'fontsize',22);
box off

end