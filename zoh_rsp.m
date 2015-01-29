function [resampled_signal, t_new] = zoh_rsp (original_signal, sample_rate, sample_value)
%This function interpolates the new sample values of the input signal by holding the last input value.
%The methode used is called Zero-order Hold.
%
%Syntax:    [resampled_Signal] = ZoH (LTI_Signal, Samle_time)
%           ZoH (LTI_Signal, Samle_time)
%
%Input:     Input Signal
%           sample rate of the input signal
%           new sample_points (in time)
%
%Output:    Resampled signal

dt = 1/sample_rate;
N = length(original_signal);  

n_end = length(sample_value);

resampled_signal=sample_value;

for i = 1 : length(sample_value)
    h1 = sample_value(i) / dt;
    if h1 < N
        resampled_signal(i) = original_signal(h1 - mod(h1,1)+1);
        %resampled_signal(i) = original_signal(sample_value(i) - mod(sample_value(i),1) + 1);
    else
        % resampled_signal (i) = original_signal(length(original_signal));
        n_end = n_end - 1;
    end
end

resampled_signal = resampled_signal(1:n_end);
t_new = sample_value(1:n_end);

% resampled_signal=resampled_signal';
