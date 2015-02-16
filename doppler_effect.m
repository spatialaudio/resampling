function [sample_position, prefactor] = doppler_effect(v_s, c, l_min, l_0, t)
% Funktion: Doppler Effect for moving audio source
%
%This function calculates sample points and the correstponding prefactors due to the Doppler-Effect,
%which takes place when the source is moving
%
%Syntax:    [sample_position, prefactor] = doppler_effect(vs, c, l_min, l_0, t)
%
%Input:     Velocity of the source in m/s
%           audio velocity in m/s
%           Minimal distance between source and receiver in m
%           Distance between source and receiver at time = 0 in m
%           sample_time of the input signal in s
%
%Output:    new sample points
%           their correspondending prefactor


if l_min == 0
    tau = (( l_0 + v_s .* t ) .* ( v_s - c )) ./ ( c^2 - v_s^2 );
else
    tau = (( l_0 - v_s .* t ).* v_s + sqrt(( -l_0 + v_s .* t).^2 .* c^2 + l_min^2 * ( c^2 - v_s^2 ))) ./ (c^2 - v_s^2);
end


sample_position = t - tau;

prefactor = 1 ./(c*tau);