function [upsampled_signal] = upsample_b (original_signal, sampling_rate, sample_value)
%Funktion Bandlimited Interpolation.
%
%The Bandlimited Interpolation approaches the ideal Interpolation (Shannon
%Therem) with an ideal Lowpass. 
%
%Syntax:    [resampled_signal] = bandlimited (original_signal, sample_rate, sample_value)
%           bandlimited (original_signal, sample_rate, sample_value, X)
%
%Input:     Original Signal
%           Sample Rate of the Original Signal
%           The Upsampling Faktor X
%
%Output     Resampled Signal


dt = 1 / sampling_rate;         % calculate sampling interval
N = length(original_signal);       % calculate number of points
time_input = (0:dt:(N-1)*dt);   % time = all points between 0 until the end of the Signal


h = 0;
for n = 1:N
    h = h + original_signal(n) * sinc(sampling_rate*(sample_value - time_input(n)));
end

upsampled_signal = h;


    
