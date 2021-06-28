function [mean_signal, sem_signal, all_signals] = get_FP_before_or_after_N(state, should_take_before, time_window, scoring, transition, FP)

FS = 1000;

if should_take_before
    if state == 'W'
        interest_indx = find(([0, transition] == -1) & (scoring == 'N'))';
    elseif state == 'R'
        interest_indx = find(([0, transition] == 1) & (scoring == 'N'))'; % TODO - problem here!!!!! doesnt find the right transitions!
    end
    matrix = repmat(0:time_window * FS - 1, size(interest_indx, 1), 1);
    
else                                                           % take after
    if state == 'W'
        interest_indx = find(([transition, 0] == 1) & (scoring == 'N'))';
    elseif state == 'R'
        interest_indx = find(([transition, 0] == -1) & (scoring == 'N'))';
    end
     matrix = repmat(time_window * FS - 1:-1:0, size(interest_indx, 1), 1);
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