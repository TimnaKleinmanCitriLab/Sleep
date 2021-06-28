function FP_signal_after_transition(FP_area, time_window)

FS = 1000;
[mice_paths, mice_names] = get_mice_path_and_names(FP_area);

mice_W_before_N = zeros(length(mice_names), FS * time_window);
mice_R_before_N = zeros(length(mice_names), FS * time_window);
mice_W_after_N = zeros(length(mice_names), FS * time_window);
mice_R_after_N = zeros(length(mice_names), FS * time_window);

mice_W_before_N_sem = zeros(length(mice_names), FS * time_window);
mice_R_before_N_sem = zeros(length(mice_names), FS * time_window);
mice_W_after_N_sem = zeros(length(mice_names), FS * time_window);
mice_R_after_N_sem = zeros(length(mice_names), FS * time_window);

fig_W_b = figure();
ax_W_b = axes;
fig_R_b = figure();
ax_R_b = axes;
fig_W_a = figure();
ax_W_a = axes;
fig_R_a = figure();
ax_R_a = axes;

for iter=1:length(mice_names)
    fullPath=mice_paths{iter};
    load([fullPath '\ZnormalizedGcamp.mat']); % normalizedGcamp
    scoring = load([fullPath '\SleepScore.mat']);
    
    scoring = scoring.SleepScore;
    num_scoring = zeros(size(scoring));
    num_scoring(scoring == 'W') = 3;
    num_scoring(scoring == 'N') = 2;
    num_scoring(scoring == 'R') = 1;
    transition = diff(num_scoring);
    
    [mean_signal, sem_signal, ~] = get_FP_before_or_after_N('W', true, time_window, scoring, transition, normalizedGcamp);
    mice_W_before_N(iter, :) = mean_signal;
    mice_W_before_N_sem(iter, :) = sem_signal;
    plot(ax_W_b, mean_signal)
    hold on
    [mean_signal, sem_signal, ~] = get_FP_before_or_after_N('R', true, time_window, scoring, transition, normalizedGcamp);
    mice_R_before_N(iter, :) = mean_signal;
    mice_R_before_N_sem(iter, :) = sem_signal;
    plot(ax_R_b, mean_signal);
    hold on
    
    [mean_signal, sem_signal, ~] = get_FP_before_or_after_N('W', false, time_window, scoring, transition, normalizedGcamp);
    mice_W_after_N(iter, :) = mean_signal;
    mice_W_after_N_sem(iter, :) = sem_signal;
    plot(ax_W_a, mean_signal);
    hold on
    
    [mean_signal, sem_signal, ~] = get_FP_before_or_after_N('R', false, time_window, scoring, transition, normalizedGcamp);
    mice_R_after_N(iter, :) = mean_signal;
    mice_R_after_N_sem(iter, :) = sem_signal;
    plot(ax_R_a, mean_signal);
    hold on
    
%     set(0, 'CurrentFigure', figureHandle)
%     shadedErrorBar(data{1}.freq, squeeze(quaniles_pow_mean(i, :)), squeeze(quaniles_pow_sem(i, :)), 'lineProps', COLORS(i))
    
    
end

end