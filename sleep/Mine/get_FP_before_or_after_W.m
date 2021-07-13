function [mean_signal, sem_signal, all_signals] = get_FP_before_or_after_W(state, W_before_other, time_window, scoring, transition, FP)
% Returns the mean signal of the wanted signal (over all found instances),
% the SEM of the signal, and all the found instances.

% state - state to check vs. awake, choose from {'N', 'R'}.
% W_before_other - boolian of should wake be before or after other state
% time_window - time to look before / after.
% scoring - vector of the signal scoring (NREM / REM / Awake etc).
% transition - difference between the wanted state and wake.
% FP - vector of the signal.

% NOTE: Wake before isn't useful.

FS = 1000;

if W_before_other
    if state == 'N'
        interest_indx = find(([transition, 0] == -1) & (scoring == 'W'))';  % Including this index
    elseif state == 'R'    % From what I unserstand - is'nt supposed to be possible
        interest_indx = find(([transition, 0] == -2) & (scoring == 'W'))'; % Including this index
    end
    matrix = repmat(-(time_window * FS - 1):0, size(interest_indx, 1), 1);
else                                                                       % W after other
    if state == 'N'
        interest_indx = find(([0, transition] == 1) & (scoring == 'W'))'; % Including this index
    elseif state == 'R'
        interest_indx = find(([0, transition] == 2) & (scoring == 'W'))';  % Including this index
    end
    matrix = repmat(0:time_window * FS - 1, size(interest_indx, 1), 1);
end

wanted_indices = repmat(interest_indx, 1, time_window * FS) + matrix;
signals = NaN(size(wanted_indices));

for row_index = 1:size(wanted_indices, 1)
    indices = wanted_indices(row_index, :);
    if indices(1) > 0 && indices(end) < length(scoring) && all(scoring(indices) == 'W') % All the chosen signal is Wake
        signals(row_index, :) = FP(indices);
    end
end

signals = signals(all(~isnan(signals),2),:);
mean_signal = mean(signals, 1);
sem_signal = std(signals, 0, 1)./sqrt(size(signals, 1));

all_signals = signals;

end