function [resampled_signal, t_new, idx] = bandlimited_rsp (original_signal, sample_rate, sample_values, X)
%Function bandlimited interpolation
%
%This function interpolates the new sample values of the input signal by
%bandlimited interpolation with the sinc-function beeing cut-off at the 5th
%cero crossing.
%
%Syntax:    [resampled_signal] = bandlimited_rsp (original_signal, sample_rate, sample_values)
%           bandlimited_rsp (original_signal, sample_rate, sample_values)
%
%Input:     Input Signal
%           Sample rate of the input signal
%           Sample values to be interpolated
%           X: Zero crossing to cutoff the signal
%
%Output:    Resampled signal
%           The time values of the resampled signal
%           The idx of the first resampled value

dt = 1 / sample_rate;         % calculate sampling interval
N = length(original_signal);       % calculate number of points
time_input = (0:dt:(N-1)*dt);   % time = all points between 0 until the end of the Signal

% for loop to interpolate the value to every sample
n_b = 1;
while sample_values(n_b) < time_input(1)
    n_b = n_b + 1;
end
n_e = length(sample_values);
while sample_values(n_e) > time_input(end)
    n_e = n_e - 1;
end
% 
% sample_values = sample_values(1:n_e);
resampled_signal = sample_values;
t_new = sample_values;


for idx = n_b:n_e
    
    % check if the sample position is one of the original sample positions
    if ~mod(sample_values(idx),dt)
        help = round(sample_values(idx)/dt)+1;
        resampled_signal(idx) = original_signal(help);
        
    % if it is not: A sinc-function is placed at the sample position and
    % cut off at its 5th zero crossing
    else
        value = 0;
        %calculate X-th zero crossing
        cutoff = X/sample_rate;
        
        % first sample lying within the range of the cutoff sinc
        n_begin = 1;
        while  time_input(n_begin) < sample_values(idx)-cutoff
            n_begin = n_begin + 1;
        end

        
        % last sample lying within the range of the cutoff sinc
        n_end = N;
        while time_input(n_end) > sample_values(idx)+ cutoff
            n_end = n_end - 1;
        end
 
       
        % add up all the sample_points within the range of the cutoff sinc
        % in order to interpolate the value
        for n_idx = n_begin:n_end
            value = value + original_signal(n_idx) * sinc(sample_rate*(sample_values(idx) - time_input(n_idx)));
        end
        resampled_signal(idx) = value;
    end
end
resampled_signal = resampled_signal(n_b:n_e);
t_new = t_new(n_b:n_e);
idx = n_b;

        