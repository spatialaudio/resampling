function [li, L] = lagrange_polynoms(xi, yi)
% inputs:
%   xi: row vector sampling positions x_i with i = 0, ..., N
%   yi: optional row vector of values of sampling positions y_i = f(x_i)
%
% outputs:
%   li: matrix of lagrange polynoms l_i(x) with i = 0, ..., N
%       l_i(x) = (x - x_0)/(x_i - x_0) * ... * (x - x_i-1) /(x_i - x_i-1) *
%                (x - x_i+1) /(x_i - x_i+1) ... (x - x_N)/(x_i - x_N)
%              = c_{i,N} x^N + c_{i, N-1} x^(N-1) + ... + c_{i, 0} x^(0)
%       each row of li stores the coefficients c_{i,k} with k = N, ..., 0 
%   L: optional interpolation polynom L(x)
%      L(x) = y_0 * l_0(x) + y_1 * l_1(x) + ... + y_N * l_N(x)

% number elements in x_i determines degree of the lagrange polynoms
N = length(xi);  

% each row contains [1 x_i] which is equivalent to m_i(x) = (x - x_i)
mi = [ones(N,1), -xi'];

% generate polynom p(x) 
% p(x) = m_0(x) * m_1(x) ... * m_N(x) = (x - x_0) * (x - x_1) * ... * (x - x_N)
p = 1;
for idx=1:N
  % convolution of coefficients means multiplication of polynoms
  p = conv(p,mi(idx,:));  
end

li = zeros(N,N);
for idx=1:N
  % nom_i(x) = p(x) / m_i(x) 
  %          = (x - x_0) * ... * (x - x_{i-1}) * (x - x_{i+1}) * ... * (x - x_N)  
  nominator = deconv(p,mi(idx,:));
  % denom_i = nom_i(x_i) evaluated with "polyval"
  denominator = polyval(nominator,xi(idx));  
  % l_i(x) = nom_i(x) / denom_i;
  li(idx,:) = nominator./denominator;
end

% optional computation of interpolation polynom L(x)
% L(x) = y_0 * l_0(x) + y_1 * l_1(x) + ... + y_N * l_N(x)
if nargin == 2
  L = yi * li;  % row vector * matrix = row vector
end