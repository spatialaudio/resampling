function [position] = time_to_position (x, x_new)
%Funktion time to position.
%
%This function calculates the sample positions in the signal x for the samples
%of the positions x_new.
%
%Syntax:    [position] = time_to_position (x, x_new)
%           time_to_position (x, x_new)
%
%Input:     sample positions x of the discrete Signal (the distance of the
%           sample is constant)
%           sample points x_new that should be linked to the discrete
%           signal (non-integer)
%
%Output     positions


dt = x(2)-x(1);

position = x_new / dt +1;

x_begin = 1;
while x_new(x_begin) < x(1)
    x_begin = x_begin + 1;
end
x_end = length(x_new);
while x_new(x_end) > x(end)
    x_end = x_end-1;
end

position = position(x_begin:x_end);