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
t4= 0:dt/4:t(end);
t8= 0:dt/8:t(end);
vs = 35;
c = 343;
l_min = 1;

f = 1.9 .* logspace(1,4,100);


% Sender should pass receiver at t(end)/2
l_0 = vs*t(end)/2;

% Neue Abtastzeitpunkte durch den Dopplereffekt
[td, pre] = doppler_effect(vs, c, l_min, l_0, t); 

% Fehlervektoren erzeugen
err_zoh = f;
err_bandlimited = f;
err_lagrange_1 = f;
err_lagrange_3 = f;

err_zoh_u4i  = f;
err_lagrange_1_ui = f;
err_lagrange_3_ui = f;

err_upsample4 = f;
err_zoh_u4  = f;
err_lagrange_1_u = f;
err_lagrange_3_u = f;

err_zoh_u8i  = f;
err_lagrange_1_u8i = f;
err_lagrange_3_u8i = f;

err_upsample8 = f;
err_zoh_u8  = f;
err_lagrange_1_u8 = f;
err_lagrange_3_u8 = f;

for idx = 1:length(f)
    % Sinussignal mit der entsprechenden Frequenz Erzeugen
    y = sin(2*pi*f(idx)*t);
    
    % Interpolationsverfahren
    
    [zoh, t_zoh] = zoh_rsp(y, sample_rate, td);
    [bandlimited, t_bandlimited] = bandlimited_rsp(y, sample_rate, td, 5);
    [lagrange_1, t_lagrange_1] = lagrange_splitting(y, sample_rate, td, 1);
    [lagrange_3, t_lagrange_3] = lagrange_splitting(y, sample_rate, td, 3);
    
    % Abtastratenerhöhung des Ausgangssignals um X = 4;
    
    % ideal
    y4i = sin(2*pi*f(idx)*t4);
    [zoh_u4i, t_zoh_u4i] = zoh_rsp(y4i(1:length(y4i)-3), sample_rate*4, td);
    [lagrange_1_ui, t_lagrange_1_ui] = lagrange_splitting(y4i(1:length(y4i)-3), sample_rate*4, td, 1);
    [lagrange_3_ui, t_lagrange_3_ui] = lagrange_splitting(y4i(1:length(y4i)-3), sample_rate*4, td, 3);
    
    %via bandlimitied interpolation with W = 100
    [y4, ty4] = bandlimited_rsp(y, sample_rate, t4, 100); 
    [zoh_u4, t_zoh_u4] = zoh_rsp(y4(1:length(y4)-3), sample_rate*4, td);
    [lagrange_1_u, t_lagrange_1_u] = lagrange_splitting(y4(1:length(y4)-3), sample_rate*4, td, 1);
    [lagrange_3_u, t_lagrange_3_u] = lagrange_splitting(y4(1:length(y4)-3), sample_rate*4, td, 3);
    
    
    % Abtastratenerhöhung des Ausgangssignals um X = 8;
    
    % ideal
    y8i = sin(2*pi*f(idx)*t8);
    [zoh_u8i, t_zoh_u8i] = zoh_rsp(y8i(1:length(y8i)-7), sample_rate*8, td);
    [lagrange_1_u8i, t_lagrange_1_u8i] = lagrange_splitting(y8i(1:length(y8i)-7), sample_rate*8, td, 1);
    [lagrange_3_u8i, t_lagrange_3_u8i] = lagrange_splitting(y8i(1:length(y8i)-7), sample_rate*8, td, 3);
    
%   %via bandlimitied interpolation with W = 100
    ty8 = t8;
    y8 = sin(2*pi*f(idx)*t8);
    [zoh_u8, t_zoh_u8] = zoh_rsp(y8(1:length(y8)-7), sample_rate*8, td);
    [lagrange_1_u8, t_lagrange_1_u8] = lagrange_splitting(y8(1:length(y8)-7), sample_rate*8, td, 1);
    [lagrange_3_u8, t_lagrange_3_u8] = lagrange_splitting(y8(1:length(y8)-7), sample_rate*8, td, 3);
    
    
%     Fehlerberechnung
    err_zoh(idx) = error_rmse(zoh,sin(2*pi*f(idx)*t_zoh));
    err_bandlimited(idx)  = error_mse(bandlimited,sin(2*pi*f(idx)*t_bandlimited));
    err_lagrange_1(idx) = error_rmse(lagrange_1,sin(2*pi*f(idx)*t_lagrange_1));
    err_lagrange_3(idx) = error_rmse(lagrange_3,sin(2*pi*f(idx)*t_lagrange_3));
    
    err_zoh_u4i(idx)  = error_rmse(zoh_u4i,sin(2*pi*f(idx)*t_zoh_u4i));
    err_lagrange_1_ui(idx)= error_rmse(lagrange_1_ui,sin(2*pi*f(idx)*t_lagrange_1_ui));
    err_lagrange_3_ui(idx)= error_rmse(lagrange_3_ui,sin(2*pi*f(idx)*t_lagrange_3_ui));
    
    err_upsample4(idx) = error_rmse(y4,sin(2*pi*f(idx)*ty4));
    err_zoh_u4(idx)  = error_rmse(zoh_u4,sin(2*pi*f(idx)*t_zoh_u4));
    err_lagrange_1_u(idx)= error_rmse(lagrange_1_u,sin(2*pi*f(idx)*t_lagrange_1_u));
    err_lagrange_3_u(idx)= error_rmse(lagrange_3_u,sin(2*pi*f(idx)*t_lagrange_3_u));
    
    err_zoh_u8i(idx)  = error_rmse(zoh_u8i,sin(2*pi*f(idx)*t_zoh_u8i));
    err_lagrange_1_u8i(idx)= error_rmse(lagrange_1_u8i,sin(2*pi*f(idx)*t_lagrange_1_u8i));
    err_lagrange_3_u8i(idx)= error_rmse(lagrange_3_u8i,sin(2*pi*f(idx)*t_lagrange_3_u8i));
    
    err_upsample8(idx) = error_rmse(y8,sin(2*pi*f(idx)*ty8));
    err_zoh_u8(idx)  = error_rmse(zoh_u8,sin(2*pi*f(idx)*t_zoh_u8));
    err_lagrange_1_u8(idx)= error_rmse(lagrange_1_u8,sin(2*pi*f(idx)*t_lagrange_1_u8));
    err_lagrange_3_u8(idx)= error_rmse(lagrange_3_u8,sin(2*pi*f(idx)*t_lagrange_3_u8));


end


figure % Standard Verfahren
semilogx(f, mag2db(err_zoh));
hold on
semilogx(f, mag2db(err_bandlimited)); 
hold on
semilogx(f, mag2db(err_lagrange_1));
hold on
semilogx(f, mag2db(err_lagrange_3));

xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('ZoH', 'Bandlimited', 'Lagrange = 1', 'Lagrange = 3', 'Location', 'Southeast')


figure %standard
semilogx(f,  mag2db(err_zoh));
hold on
semilogx(f,  mag2db(err_bandlimited));
hold on
semilogx(f,  mag2db(err_lagrange_1));
hold on
semilogx(f,  mag2db(err_lagrange_3));


xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('ZoH', 'Bandlimited W = 5', 'Lagrange N = 1', 'Lagrange N = 3', 'Location', 'Southeast')
 
   
figure % W = 100;  ZoH
semilogx(f, mag2db(err_zoh));
hold on
semilogx(f, mag2db(err_zoh_u4));
hold on
semilogx(f, mag2db(err_zoh_u8));

xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('ZoH', 'ZoH X = 4', 'ZoH X = 8','Location', 'Southeast')

figure % ideal; ZoH
semilogx(f, mag2db(err_zoh));
hold on
semilogx(f, mag2db(err_zoh_u4i)');
hold on
% semilogx(f, mag2db(err_upsample4));
% hold on
semilogx(f, mag2db(err_zoh_u8i));
hold on
% semilogx(f, mag2db(err_upsample8));

xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('ZoH', 'ZoH X = 4', 'ZoH X = 8', 'Location', 'Southeast')

figure %ideal; L1
semilogx(f, mag2db(err_lagrange_1));
hold on
semilogx(f, mag2db(err_lagrange_1_ui));
hold on
semilogx(f, mag2db(err_lagrange_1_u8i));

xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('Lagrange N = 1', 'Lagrange N = 1 X = 4', 'Lagrange N = 1 X = 8', 'Location', 'Southeast')


figure %W = 100; L1
semilogx(f, mag2db(err_lagrange_1));
hold on
semilogx(f, mag2db(err_lagrange_1_u));
hold on
semilogx(f, mag2db(err_lagrange_1_u8));

xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('Lagrange N = 1', 'Lagrange N = 1 X = 4', 'Lagrange N = 1 X = 8', 'Location', 'Southeast')

figure %ideal; L3
semilogx(f, mag2db(err_lagrange_3));
hold on
semilogx(f, mag2db(err_lagrange_3_ui));
hold on
semilogx(f, mag2db(err_lagrange_3_u8i));
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('Lagrange N = 3', 'Lagrange N = 3 X = 4', 'Lagrange N = 3 X = 8', 'Location', 'Southeast')

figure %W = 100; L3
semilogx(f, mag2db(err_lagrange_3));
hold on
semilogx(f, mag2db(err_lagrange_3_u));
hold on
% semilogx(f, 20*log(err_upsample4));
% hold on
semilogx(f, mag2db(err_lagrange_3_u8));
hold on
% semilogx(f, 20*log(err_upsample8));
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('Lagrange N = 3', 'Lagrange N = 3 X = 4', 'Lagrange N = 3 X = 8', 'Location', 'Southeast')

figure % ideal vs W = 100; ZoH
semilogx(f, mag2db(err_zoh_u4i));
hold on
semilogx(f, mag2db(err_zoh_u4));
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('ZoH X = 4 ideal', 'ZoH X = 4 W = 100', 'Location', 'Southeast')

figure % ideal vs W = 100; Lagrange N = 1
semilogx(f, mag2db(err_lagrange_1_ui));
hold on
semilogx(f, mag2db(err_lagrange_1_u));
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('Lagrange N=1 X = 4 ideal', 'Lagrange N=1 X = 4 W = 100', 'Location', 'Southeast')

figure % ideal vs W = 100; Lagrange N = 3
semilogx(f, mag2db(err_lagrange_3_ui));
hold on
semilogx(f, mag2db(err_lagrange_3_u));
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('Lagrange N = 3 X = 4 ideal', 'Lagrange N = 3 X = 4 W = 100', 'Location', 'Southeast')
