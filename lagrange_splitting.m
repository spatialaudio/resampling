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

% auxiliary variable
xi_old = x_in(1)-1;

% Eliminating samples that are out of the range of the input signal
if N ~= 0
    x_b = (N+1)*0.5;
    x_e = length(x_in) - (N+1)*0.5;
end

if mod(x_b,1) == 0.5
    x_b = x_in(floor(x_b)) + dt/2;
    x_e = x_in(floor(x_e)) + dt/2;
else
    x_b = x_in(x_b);
    x_e = x_in(x_e);
end

% Determine the first new sample that can be interpolated
x_begin = 1;

while x_b > x_new(x_begin)
    x_begin = x_begin + 1;
end

% Determine the last new sample that can be interpolated
x_end = length(x_new);
while x_e <  x_new(x_end)
    x_end = x_end - 1;
end

% x_new = x_new(x_begin:x_end);

% function calculating the positions of the new (fractional) samples
x_samples = time_to_position(x_in, x_new(x_begin:x_end));

% determining the length of the filtered_signal
filtered_signal = zeros(size(x_samples));


% for-loop interpolating the values for each new (fractional) sample by a
% lagrange filter using the N+1 nearest interegs
for idx = 1:length(x_samples)
    
    % function calculating the N+1 nearest interegs for the new
    % (fractional) sample
    xi = next_integers(x_samples(idx), N+1);
    
    % xi(1) is set to 1 to calculate the polynoms, so x_samples(idx) has to
    % be 
    position = x_samples(idx) - xi(1) + 1;
    
    % Check if the nearest integers stayed the same, because then the
    % lagrange polynoms can be reused
    if xi_old ~= xi
        % Calculating the lagrange polynom for the new fracional sample
        yi = signal_in(xi);
        [li, L] = lagrange_polynoms(1:N+1, yi);
        xi_old = xi;
    end
    
    % Interpolation of the value
    value = polyval(L, position);

    
    filtered_signal(idx) = value;

end

x_filtered = x_new(x_begin:x_end);