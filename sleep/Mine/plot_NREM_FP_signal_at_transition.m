function plot_NREM_FP_signal_at_transition(FP_area, time_window)

FS = 1000;
[mice_paths, mice_names] = get_mice_path_and_names(FP_area);
amount_of_mice = length(mice_names);

% mean signal by mouse
mice_N_before_W = zeros(amount_of_mice, FS * time_window);
mice_N_before_R = zeros(amount_of_mice, FS * time_window);
mice_N_after_W = zeros(amount_of_mice, FS * time_window);
mice_N_after_R = zeros(amount_of_mice, FS * time_window);

% signal sem by mouse
mice_N_before_W_sem = zeros(amount_of_mice, FS * time_window);
mice_N_before_R_sem = zeros(amount_of_mice, FS * time_window);
mice_N_after_W_sem = zeros(amount_of_mice, FS * time_window);
mice_N_after_R_sem = zeros(amount_of_mice, FS * time_window);

% Amount of trials per mouse
mice_N_before_W_trial_amount = zeros(amount_of_mice, 1);
mice_N_before_R_trial_amount = zeros(amount_of_mice, 1);
mice_N_after_W_trial_amount = zeros(amount_of_mice, 1);
mice_N_after_R_trial_amount = zeros(amount_of_mice, 1);

% Init by mouse figure
x_axe = linspace(1, time_window, FS * time_window);
fig_all_mice_one_fig = figure();
ax_b_W_by_mouse = subplot(2, 2, 1);
ax_b_R_by_mouse = subplot(2, 2, 2);
ax_a_W_by_mouse = subplot(2, 2, 3);
ax_a_R_by_mouse = subplot(2, 2, 4);

fig_each_mouse_dif_subplot = figure();

% Gather data + plot by mouse - all mice same figure and each mouse
%                               different subplot
for iter=1:amount_of_mice
    fullPath=mice_paths{iter};
    load([fullPath '\ZnormalizedGcamp.mat']);                              % normalizedGcamp
    scoring = load([fullPath '\SleepScore.mat']);
    
    scoring = scoring.SleepScore;
    num_scoring = zeros(size(scoring));
    num_scoring(scoring == 'W') = 3;
    num_scoring(scoring == 'N') = 2;
    num_scoring(scoring == 'R') = 1;
    transition = diff(num_scoring);
    
    [mean_signal, sem_signal, all_signals] = get_FP_before_or_after_N('W', true, time_window, scoring, transition, normalizedGcamp);
    mice_N_before_W(iter, :) = mean_signal;
    mice_N_before_W_sem(iter, :) = sem_signal;
    mice_N_before_W_trial_amount(iter) = size(all_signals, 1);
    plot(ax_b_W_by_mouse, x_axe, mean_signal)
    hold(ax_b_W_by_mouse, 'on')
    
    [mean_signal, sem_signal, all_signals] = get_FP_before_or_after_N('R', true, time_window, scoring, transition, normalizedGcamp);
    mice_N_before_R(iter, :) = mean_signal;
    mice_N_before_R_sem(iter, :) = sem_signal;
    mice_N_before_R_trial_amount(iter) = size(all_signals, 1);
    plot(ax_b_R_by_mouse, x_axe, mean_signal);
    hold(ax_b_R_by_mouse, 'on')
    
    [mean_signal, sem_signal, all_signals] = get_FP_before_or_after_N('W', false, time_window, scoring, transition, normalizedGcamp);
    mice_N_after_W(iter, :) = mean_signal;
    mice_N_after_W_sem(iter, :) = sem_signal;
    mice_N_after_W_trial_amount(iter) = size(all_signals, 1);
    plot(ax_a_W_by_mouse, x_axe, mean_signal);
    hold(ax_a_W_by_mouse, 'on')
    
    [mean_signal, sem_signal, all_signals] = get_FP_before_or_after_N('R', false, time_window, scoring, transition, normalizedGcamp);
    mice_N_after_R(iter, :) = mean_signal;
    mice_N_after_R_sem(iter, :) = sem_signal;
    mice_N_after_R_trial_amount(iter) = size(all_signals, 1);
    plot(ax_a_R_by_mouse, x_axe, mean_signal);
    hold(ax_a_R_by_mouse, 'on')
    
    % Plots each mouse in different subplot
    set(0, 'CurrentFigure', fig_each_mouse_dif_subplot)
    mouse_before_subplot = subplot(2, amount_of_mice, iter);
    shadedErrorBar(x_axe, mice_N_before_W(iter, :),  mice_N_before_W_sem(iter, :), 'lineProps', 'b')
    hold on
    shadedErrorBar(x_axe, mice_N_before_R(iter, :),  mice_N_before_R_sem(iter, :), 'lineProps', 'm')
    hold on
    title(mouse_before_subplot, mice_names(iter))
    mouse_after_subplot = subplot(2, amount_of_mice, iter + amount_of_mice);
    shadedErrorBar(x_axe, mice_N_after_W(iter, :),  mice_N_after_W_sem(iter, :), 'lineProps', 'g')
    hold on
    shadedErrorBar(x_axe, mice_N_after_R(iter, :),  mice_N_after_R_sem(iter, :), 'lineProps', 'c')
    
end
% All mice same plot
legend(ax_b_R_by_mouse, mice_names)

title(ax_b_W_by_mouse, "Mean mosue signal - N before W")
title(ax_b_R_by_mouse, "Mean mosue signal - N before R")
title(ax_a_W_by_mouse, "Mean mosue signal - N after W")
title(ax_a_R_by_mouse, "Mean mosue signal - N after R")

% Each mouse dif subplot
% set(0, 'CurrentFigure', fig_each_mouse_dif_subplot)
mouse_before_subplot = subplot(2, amount_of_mice, amount_of_mice);
legend("N before W", "N before R")
mouse_after_subplot = subplot(2, amount_of_mice, 2 * amount_of_mice);
legend("N after W", "N after R")
sgtitle("Signal of mice type " + FP_area)


% Calculate + plot all mice 
b_W_mean = mice_N_before_W(all(~isnan(mice_N_before_W),2),:);
b_R_mean = mice_N_before_R(all(~isnan(mice_N_before_R),2),:);
a_W_mean = mice_N_after_W(all(~isnan(mice_N_after_W),2),:);
a_R_mean = mice_N_after_R(all(~isnan(mice_N_after_R),2),:);

fig2 = figure();
ax_before = subplot(1, 2, 1);
shadedErrorBar(x_axe, mean(b_W_mean, 1),  std(b_W_mean, 0, 1)./sqrt(size(b_W_mean, 1)), 'lineProps', 'b')
hold(ax_before, 'on')
shadedErrorBar(x_axe, mean(b_R_mean, 1),  std(b_R_mean, 0, 1)./sqrt(size(b_R_mean, 1)), 'lineProps', 'm')
legend(ax_before, "N before W", "N before R")
ax_after = subplot(1, 2, 2);
shadedErrorBar(x_axe, mean(a_W_mean, 1),  std(a_W_mean, 0, 1)./sqrt(size(a_W_mean, 1)), 'lineProps', 'g')
hold(ax_after, 'on')
shadedErrorBar(x_axe, mean(a_R_mean, 1),  std(a_R_mean, 0, 1)./sqrt(size(a_R_mean, 1)), 'lineProps', 'c')
legend(ax_after, "N after W", "N after R")

title(ax_before, "Mean signal all mice before")
title(ax_after, "Mean signal all mice after")
end