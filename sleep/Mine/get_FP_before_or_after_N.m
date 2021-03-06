
function [mean_signal, sem_signal, all_signals] = get_FP_before_or_after_N(state, N_before_other, time_window, scoring, transition, FP)
% Returns the mean signal of the wanted signal (over all found instances),
% the SEM of the signal, and all the found instances.

% state - state to check vs. awake, choose from {'W', 'R'}.
% N_before_other - boolian of should NREM be before or after other state
% time_window - time to look before / after.
% scoring - vector of the signal scoring (NREM / REM / Awake etc).
% transition - difference between the wanted state and NREM.
% FP - vector of the signal.

% NOTE: NREM after isn't useful.

FS = 1000;

if N_before_other
    if state == 'W'
        interest_indx = find(([transition, 0] == 1) & (scoring == 'N'))';  % Including this index
    elseif state == 'R'
        interest_indx = find(([transition, 0] == -1) & (scoring == 'N'))'; % Including this index
    end
    matrix = repmat(-(time_window * FS - 1):0, size(interest_indx, 1), 1);
else                                                                       % N after other
    if state == 'W'
        interest_indx = find(([0, transition] == -1) & (scoring == 'N'))'; % Including this index
    elseif state == 'R' % From what I unserstand - is'nt supposed to be possible
        interest_indx = find(([0, transition] == 1) & (scoring == 'N'))';  % Including this index
    end
    matrix = repmat(0:time_window * FS - 1, size(interest_indx, 1), 1);
end

wanted_indices = repmat(interest_indx, 1, time_window * FS) + matrix;
signals = NaN(size(wanted_indices));

for row_index = 1:size(wanted_indices, 1)
    indices = wanted_indices(row_index, :);
    if indices(1) > 0 && indices(end) < length(scoring) && all(scoring(indices) == 'N') % All the chosen signal is NREM
        signals(row_index, :) = FP(indices);
    end
end

signals = signals(all(~isnan(signals),2),:);
% disp("Before:" + should_take_before + ", State:" + state + ", Amount of signals: " + size(signals, 1))
mean_signal = mean(signals, 1);
sem_signal = std(signals, 0, 1)./sqrt(size(signals, 1));

all_signals = signals;



end