function [RMSE] = error_rmse (x_measure, x)
% Funktion: Mean Square Error
%
%This function calculates the mean square error of a signal
%
%Syntax:    [MSE] = error_mse(x', x)
%           error_mse(x', x)
%
%Input:     Signal whose accuracy has to be calculated
%           Signal with the correct values
%
%Output:    mean square error


RMSE =sqrt(mean((x - x_measure).^2));