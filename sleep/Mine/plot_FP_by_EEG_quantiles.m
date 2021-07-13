function plot_FP_by_EEG_quantiles(state, FP_area, EEG_area, num_quantiles)
% Plots the different FP by EEG quantiles (opposite of plot_EEG_by_FP_quantiles)

% state - choose from {'W','N','R'}
% FP_area - {'ACC', 'OFC'}
% EEG_area - {'frontal', 'parietal'}

%% Validation tests
allowed_states = {'W', 'N', 'R'};
allowed_FP_areas = {'ACC', 'OFC'};
allowed_EEG_areas = {'frontal', 'parietal'};

if (~any(strcmp(state,allowed_states)) || ~any(strcmp(FP_area,allowed_FP_areas)) || ~any(strcmp(EEG_area,allowed_EEG_areas)))
    error("Problem with chosen area/state!")
end

%% Choose and load data
[mice_paths, mice_names] = get_mice_path_and_names(FP_area);

channels=load('C:\Users\owner\Google Drive\University\ElscLab\Actual Work\Noa Tel Aviv Sleep Project\Open Source\sleep\claustrumEEGch.mat');     %notice path

checked_wavelengths = ["SW", "theta"];

data=cell(length(checked_wavelengths), length(mice_names));
dffBdff=zeros(length(checked_wavelengths), length(mice_names), num_quantiles);
thetaBdff=zeros(length(checked_wavelengths), length(mice_names), num_quantiles);
SWBdff=zeros(length(checked_wavelengths), length(mice_names), num_quantiles);
powBdff=zeros(length(checked_wavelengths), length(mice_names), num_quantiles,2000);


% Recieve loaded data
% (powBdff: dim1-mice, dim2-quantiles, dim3-freq)
for i = 1:length(checked_wavelengths)
    for j=1:length(mice_names)
        ID=mice_names{j};
        channel=channels.claustrumEEGch{EEG_area, ID};
        fullPath=mice_paths{j};
        [data{i, j}, dffBdff(i, j,:), thetaBdff(i, j,:), SWBdff(i, j,:),...
            powBdff(i, j, :, :)]=cut_by_quantiles(fullPath, channel, state, num_quantiles, checked_wavelengths(i));
    end
end
%% plots

powF=figure();
set(powF,'outerposition',[2,42,958,954]);
legends = strings(1, num_quantiles);

FP_mean = squeeze(mean(dffBdff, 2));
FP_sem = squeeze(std(dffBdff, 0, 2)./sqrt(numel(mice_names)));
for i = 1:num_quantiles
    plot(1:length(checked_wavelengths), FP_mean(:, i), '-o')
    % errorbar(1:length(checked_wavelengths), FP_mean(:, i), FP_sem(:, i), '-o') % Can uncomment this line, and comment the prev line if want to show error bars
    hold on
    legends(i) = "quartile " + int2str(i);
end

hold off
legend(legends)
set(gca,'xtick', [1:length(checked_wavelengths)], 'xticklabel', checked_wavelengths)
ylabel('Dff');
xlabel('Wave Lengths')
title({"Average FP by EEG Quantiles", "State: " + state + ", FP area: " + FP_area + ", EEG area: " + EEG_area})
xlim([0.5 length(checked_wavelengths) + 0.5])
set(gca,'fontsize',22);
box off
end