function [filtered_signal, x_filtered] = lagrange_splitting(signal_in, sample_rate, x_new, N)
%Funktion Interpolation with a Lagrange Filter
%
%This function interpolates the values for the new (fractional) sample by
%a lagrange filter using the N+1 nearest interegs of the new (fractional)
%sample
%
%Syntax:    [filtered_signal, x_filtered] = lagrange_splitting(signal_in, sample_rate, x_new, N)
%           lagrange_splitting(signal_in, sample_rate, x_new, N)
%
%Input:     input signal 
%           sample rate of the input signal
%           to be interpolated (fractional) points
%           Order N of the lagrange filter (possible N = 0,1,2,3)
%
%Output:    filtered signal
%           the points that have been interpolated


% calculate positions of the samples of the input signal    
dt = 1 / sample_rate;
x_in = 0:dt:(length(signal_in)-1)*dt;

% Eliminating samples that are out of the range of the input signal
x_begin = 1;
while x_new(x_begin) < x_in(1)
    x_begin = x_begin + 1;
end
x_end = length(x_new);
while x_new(x_end) > x_in(end)
    x_end = x_end-1;
end

x_new = x_new(x_begin:x_end);

% function calculating the positions of the new (fractional) samples
x_samples = time_to_position(x_in, x_new);

% defining variables
s_begin = 1;
s_end = length(x_samples);
% determining the length of the filtered_signal
filtered_signal = x_samples;


% for-loop interpolating the values for each new (fractional) sample by a
% lagrange filter using the N+1 nearest interegs
for idx = 1:length(x_samples)
    position = x_samples(idx);
    % function calculating the N+1 nearest interegs for the new
    % (fractional) sample
    xi = next_integers(x_samples(idx), N+1);
    if xi(1) < 1
        s_begin = s_begin + 1;
    elseif xi(end) > length(x_in)
        s_end = s_end - 1;
    else            
        yi = signal_in(xi);
        [li, L] = lagrange_polynoms(xi, yi);
        L = fliplr(L);
        value = 0;
        for n = 1:N+1
        value = value + L(n) * position^(n-1);
        end
        filtered_signal(idx) = value;
    end
end

x_filtered = x_new(s_begin:s_end);
filtered_signal = filtered_signal(s_begin:s_end);
    
        
% plot(x_in,signal_in, 'o', x_filtered, filtered_signal)