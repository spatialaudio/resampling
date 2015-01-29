function [l_samples] = next_integers (a, N)
%Funktion next integers.
%
%This function calculates the N integers that are closest to the value a. N
%can be from 1 to 4;
%
%Syntax:    [l_samples] = next_integers (a, N)
%           next_integers (a, N)
%
%Input:     the number
%           the number of integers calculated
%
%Output     the N integers closest to a

l_samples(N) = 0;
switch N
    case 1
        if mod(a,1) <= 0.5;
            l_samples(1)= a - mod(a,1);
        else
            l_samples(1)= a - mod(a,1)+1;
        end
    case 2
        l_samples(1) = a - mod(a,1);
        l_samples(2) = a - mod(a,1)+1;
    case 3
        if mod(a,1) <=0.5;
            l_samples(1) = a - mod(a,1)-1;
            l_samples(2) = a - mod(a,1);
            l_samples(3)= a - mod(a,1)+1;
        else
            l_samples(1) = a - mod(a,1);
            l_samples(2)= a - mod(a,1)+1;
            l_samples(3)= a - mod(a,1)+2;
        end        
    case 4
        l_samples(1) = a - mod(a,1)-1;
        l_samples(2) = a - mod(a,1);
        l_samples(3) = a - mod(a,1)+1;
        l_samples(4)= a - mod(a,1)+2;
    otherwise
        display('Error: next_integers can not calculate that number N. N has to be between 1 and 4.');    
end
