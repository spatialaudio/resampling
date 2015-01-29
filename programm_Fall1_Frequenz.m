% Verschiedene Methoden zur Darstellung zeitinvariante Verzögerung -
% Fehleranalyse
%
% zeitvariante Verzögerung:
% Der 1 Fall für den Dopplereffekt wird verwendet. Das bedeutet, dass l_min
% gleich Null ist und d(x) damit eine lineare Funktion.
%
% Verwendete Verfahren:
%       zoh - Resampling
%       Bandlimitierte Interpolation
%       Lagrange N = 1
%       Lagrange N = 3
%       zoh + Upsampling X = 4
%       Lagrange N = 3 + Upsampling X = 4
%       zoh + Upsampling X = 8
%
% Fehlerfunktion: Root Mean Square Error
%
% Konstanten:
%               Abtastfrequenz: sample rate =   48 kHz
%               Geschwindigkeit:                vs = 35
%               Schallgeschwindigkeit:          c = 300
%               Länge der Zeit:                 t(end) = 5  
%
% Variable:
%               Frequenz des Sinus Signals
%               26 versch. Frequenzen: 50,100,150, 200, 300, 400, 500, 600,
%               700, 800, 900, 1k, 2k, 3k, 4k, 5k, 6k, 7k, 8k, 9k, 10k,
%               12k, 14k, 16k, 18k, 20k

sample_rate = 48000;
dt = 1/ sample_rate;
t = 0:dt:0.5;
vs = 35;
c = 300;
l_min = 0;

f = [50, 100, 150, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 12000, 14000, 16000, 18000, 20000];

% Sender should pass receiver at t(end)/2
l_0 = 35*t(end)/2;

% Neue Abtastzeitpunkte durch den Dopplereffekt
[td, pre] = doppler_effect(vs, c, l_min, l_0, t); 

% Fehlervektoren erzeugen
err_zoh = f;
err_bandlimited = f;
err_lagrange_1 = f;
err_lagrange_3 = f;
err_zoh_u4  = f;
err_lagrange_2_u = f;
err_lagrange_3_u = f;
err_zoh_u8  = f;


for idx = 1:length(f)
    % Sinussignal mit der entsprechenden Frequenz Erzeugen
    y = sin(2*pi*f(idx)*t);
    
   
    
    % Interpolationsverfahren
    [zoh, t_zoh] = zoh_rsp(y, sample_rate, td);
    [bandlimited, t_bandlimited] = bandlimited_rsp(y, sample_rate, td);
    [lagrange_1, t_lagrange_1] = lagrange_splitting(y, sample_rate, td, 1);
    [lagrange_3, t_lagrange_3] = lagrange_splitting(y, sample_rate, td, 3);
    % Abtastratenerhöhung des Ausgangssignals um X = 4;
    y4 = interp(y,4);
    [zoh_u4, t_zoh_u4] = zoh_rsp(y4(1:length(y4)-3), sample_rate*4, td);
    [lagrange_2_u, t_lagrange_2_u] = lagrange_splitting(y4(1:length(y4)-3), sample_rate*4, td, 1);
    [lagrange_3_u, t_lagrange_3_u] = lagrange_splitting(y4(1:length(y4)-3), sample_rate*4, td, 3);
    % Abtastratenerhöhung des Ausgangssignals um X = 8;
    y8 = interp(y,8);
    [zoh_u8, t_zoh_u8] = zoh_rsp(y8(1:length(y4)-7), sample_rate*8, td);
    
    
    
    % Fehlerberechnung
    err_zoh(idx) = error_rmse(zoh,sin(2*pi*f(idx)*t_zoh));
    err_bandlimited(idx)  = error_mse(bandlimited,sin(2*pi*f(idx)*t_bandlimited));
    err_lagrange_1(idx) = error_rmse(lagrange_1,sin(2*pi*f(idx)*t_lagrange_1));
    err_lagrange_3(idx) = error_rmse(lagrange_3,sin(2*pi*f(idx)*t_lagrange_3));
    err_zoh_u4(idx)  = error_rmse(zoh_u4,sin(2*pi*f(idx)*t_zoh_u4));
    err_lagrange_2_u(idx)= error_rmse(lagrange_2_u,sin(2*pi*f(idx)*t_lagrange_2_u));
    err_lagrange_3_u(idx)= error_rmse(lagrange_3_u,sin(2*pi*f(idx)*t_lagrange_3_u));
    err_zoh_u8(idx)  = error_rmse(zoh_u8,sin(2*pi*f(idx)*t_zoh_u8));
end

figure
loglog(f, err_zoh);
hold on
loglog(f, err_bandlimited);
hold on
loglog(f, err_lagrange_1);
hold on
loglog(f, err_lagrange_3);
hold on
loglog(f, err_zoh_u4);
hold on
loglog(f, err_lagrange_2_u);
hold on
loglog(f, err_lagrange_3_u);
hold on
loglog(f, err_zoh_u8);
xlabel('Frequenz [Hz]');
ylabel('RMSE');
legend('ZoH', 'Bandlimited',  'Lagrange N = 1','Lagrange N = 3', 'ZoH, X = 4', 'Lagrange N = 1, X = 4', 'Lagrange N = 3, X = 4', 'ZoH, X = 8',  'Location', 'Southwest')
    
