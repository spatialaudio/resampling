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
l_min = 0;


fb = 1.9 .*logspace(0,4,100);

% Sender should pass receiver at t(end)/2
l_0 = 35*t(end)+1;

% Neue Abtastzeitpunkte durch den Dopplereffekt
[td, pre] = doppler_effect(vs, c, l_min, l_0, t); 

% Fehlervektoren erzeugen
err_zoh = fb;
err_bandlimited = fb;
err_lagrange_1 = fb;
err_lagrange_3 = fb;

err_zoh_u4i  = fb;
err_lagrange_1_ui = fb;
err_lagrange_3_ui = fb;

err_upsample4 = fb;
err_zoh_u  = fb;
err_lagrange_1_u = fb;
err_lagrange_3_u = fb;

err_zoh_u8i  = fb;
err_lagrange_1_u8i = fb;
err_lagrange_3_u8i = fb; 

err_upsample8 = fb;
err_zoh_u8  = fb;
err_lagrange_1_u8 = fb;
err_lagrange_3_u8 = fb;



for idx = 1:length(fb)
    % Sinussignal mit der entsprechenden Frequenz Erzeugen
    y = sin(2*pi*fb(idx)*t);
    
   
    
    % Interpolationsverfahren
    [zoh, t_zoh] = zoh_rsp(y, sample_rate, td);
    [bandlimited, t_bandlimited] = bandlimited_rsp(y, sample_rate, td, 5);
    [lagrange_1, t_lagrange_1] = lagrange_splitting(y, sample_rate, td, 1);
    [lagrange_3, t_lagrange_3] = lagrange_splitting(y, sample_rate, td, 3);
    
    % Abtastratenerhöhung des Ausgangssignals um X = 4;
    % ideal
    
    y4i = sin(2*pi*fb(idx)*t4); interp(y,4);
    [zoh_u4i, t_zoh_u4i] = zoh_rsp(y4i(1:length(y4i)-3), sample_rate*4, td);
    [lagrange_1_ui, t_lagrange_1_ui] = lagrange_splitting(y4i(1:length(y4i)-3), sample_rate*4, td, 1);
    [lagrange_3_ui, t_lagrange_3_ui] = lagrange_splitting(y4i(1:length(y4i)-3), sample_rate*4, td, 3);
    
    % via Bandlimited interpolation with X = 100
    [y4, ty4] = bandlimited_rsp(y, sample_rate, t4, 50); 
    
    [zoh_u, t_zoh_u] = zoh_rsp(y4(1:length(y4)-3), sample_rate*4, td);
    [lagrange_1_u, t_lagrange_1_u] = lagrange_splitting(y4(1:length(y4)-3), sample_rate*4, td, 1);
    [lagrange_3_u, t_lagrange_3_u] = lagrange_splitting(y4(1:length(y4)-3), sample_rate*4, td, 3);
    
    % Abtastratenerhöhung des Ausgangssignals um X = 8;
    
    % ideal
    
    y8i = sin(2*pi*fb(idx)*t8); 
    [zoh_u8i, t_zoh_u8i] = zoh_rsp(y8i(1:length(y8i)-7), sample_rate*8, td);
    [lagrange_1_u8i, t_lagrange_1_u8i] = lagrange_splitting(y8i(1:length(y8i)-7), sample_rate*8, td, 1);
    [lagrange_3_u8i, t_lagrange_3_u8i] = lagrange_splitting(y8i(1:length(y8i)-7), sample_rate*8, td, 3);

    % via Bandlimited interpolation with X = 100
    [y8, ty8] = bandlimited_rsp(y, sample_rate, t8, 50); 
    [zoh_u8, t_zoh_u8] = zoh_rsp(y8(1:length(y8)-7), sample_rate*8, td);
    [lagrange_1_u8, t_lagrange_1_u8] = lagrange_splitting(y8(1:length(y8)-7), sample_rate*8, td, 1);
    [lagrange_3_u8, t_lagrange_3_u8] = lagrange_splitting(y8(1:length(y8)-7), sample_rate*8, td, 3);
    
    
    % Fehlerberechnung
    err_zoh(idx) = error_mse(zoh,sin(2*pi*fb(idx)*t_zoh));
    err_bandlimited(idx)  = error_mse(bandlimited,sin(2*pi*fb(idx)*t_bandlimited));
    err_lagrange_1(idx) = error_mse(lagrange_1,sin(2*pi*fb(idx)*t_lagrange_1));
    err_lagrange_3(idx) = error_mse(lagrange_3,sin(2*pi*fb(idx)*t_lagrange_3));

    err_zoh_u4i(idx)  = error_mse(zoh_u4i,sin(2*pi*fb(idx)*t_zoh_u4i));
    err_lagrange_1_ui(idx)= error_mse(lagrange_1_ui,sin(2*pi*fb(idx)*t_lagrange_1_ui));
    err_lagrange_3_ui(idx)= error_mse(lagrange_3_ui,sin(2*pi*fb(idx)*t_lagrange_3_ui));

    err_upsample4(idx) = error_mse(y4,sin(2*pi*fb(idx)*ty4));
    err_zoh_u(idx)  = error_mse(zoh_u,sin(2*pi*fb(idx)*t_zoh_u));
    err_lagrange_1_u(idx)= error_mse(lagrange_1_u,sin(2*pi*fb(idx)*t_lagrange_1_u));
    err_lagrange_3_u(idx)= error_mse(lagrange_3_u,sin(2*pi*fb(idx)*t_lagrange_3_u));

    err_zoh_u8i(idx)  = error_mse(zoh_u8i,sin(2*pi*fb(idx)*t_zoh_u8i));
    err_lagrange_1_u8i(idx)= error_mse(lagrange_1_u8i,sin(2*pi*fb(idx)*t_lagrange_1_u8i));
    err_lagrange_3_u8i(idx)= error_mse(lagrange_3_u8i,sin(2*pi*fb(idx)*t_lagrange_3_u8i));
    
    err_upsample8(idx) = error_mse(y8,sin(2*pi*fb(idx)*ty8));
    err_zoh_u8(idx)  = error_mse(zoh_u8,sin(2*pi*fb(idx)*t_zoh_u8));
    err_lagrange_1_u8(idx)= error_mse(lagrange_1_u8,sin(2*pi*fb(idx)*t_lagrange_1_u8));
    err_lagrange_3_u8(idx)= error_mse(lagrange_3_u8,sin(2*pi*fb(idx)*t_lagrange_3_u8));
end

figure %standard
semilogx(fb, mag2db(sqrt(err_zoh)));
hold on
semilogx(fb, mag2db(sqrt(err_bandlimited)));
hold on
semilogx(fb, mag2db(sqrt(err_lagrange_1)));
hold on
semilogx(fb, mag2db(sqrt(err_lagrange_3)));
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('ZoH', 'Bandlimited W = 5', 'Lagrange N = 1', 'Lagrange N = 3', 'Location', 'Southeast')
 
   
figure % W = 100;  ZoH
semilogx(fb, mag2db(sqrt(err_zoh)));
hold on
semilogx(fb, mag2db(sqrt(err_zoh_u)));
hold on
semilogx(fb, mag2db(sqrt(err_zoh_u8)));
hold on
semilogx(fb, mag2db(sqrt(err_upsample4)));
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('ZoH', 'ZoH X = 4', 'ZoH X = 8', 'Abtastratenerhöhung', 'Location', 'Southeast')

figure % ideal; ZoH
semilogx(fb, mag2db(sqrt(err_zoh)));
hold on
semilogx(fb, mag2db(sqrt(err_zoh_u4i)'));
hold on
semilogx(fb, mag2db(sqrt(err_zoh_u8i)));
hold on
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('ZoH', 'ZoH X = 4', 'ZoH X = 8', 'Location', 'Southeast')

figure %ideal; L1
semilogx(fb, mag2db(sqrt(err_lagrange_1)));
hold on
semilogx(fb, mag2db(sqrt(err_lagrange_1_ui)));
hold on
semilogx(fb, mag2db(sqrt(err_lagrange_1_u8i)));
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('Lagrange N = 1', 'Lagrange N = 1 X = 4', 'Lagrange N = 1 X = 8', 'Location', 'Southeast')
% 

figure %W = 100; L1
semilogx(fb, mag2db(sqrt(err_lagrange_1)));
hold on
semilogx(fb, mag2db(sqrt(err_lagrange_1_u)));
hold on
semilogx(fb, mag2db(sqrt(err_lagrange_1_u8)));
hold on
semilogx(fb, mag2db(sqrt(err_upsample4)));
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('Lagrange N = 1', 'Lagrange N = 1 X = 4', 'Lagrange N = 1 X = 8', 'Abtastratenerhöhung', 'Location', 'Southeast')

figure %ideal; L3
semilogx(fb, mag2db(sqrt(err_lagrange_3)));
hold on
semilogx(fb, mag2db(sqrt(err_lagrange_3_ui)));
hold on
semilogx(fb, mag2db(sqrt(err_lagrange_3_u8i)));
hold on
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('Lagrange N = 3', 'Lagrange N = 3 X = 4', 'Lagrange N = 3 X = 8', 'Location', 'Southeast')

figure %W = 50; L3
semilogx(fb, mag2db(sqrt(err_lagrange_3)));
hold on
semilogx(fb, mag2db(sqrt(err_lagrange_3_u)));
semilogx(fb, mag2db(sqrt(err_lagrange_3_u8)));
semilogx(fb,  mag2db(sqrt(err_upsample4)));
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('Lagrange N = 3', 'Lagrange N = 3 X = 4',  'Lagrange N = 3 X = 8','Abtastratenerhöhung', 'Location', 'Southeast')

figure % ideal vs W = 50; ZoH
semilogx(fb, mag2db(sqrt(err_zoh_u4i)));
hold on
semilogx(fb, mag2db(sqrt(err_zoh_u)));
semilogx(fb,  mag2db(sqrt(err_upsample4)));
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('ZoH X = 4 ideal', 'ZoH X = 4 W = 50', 'Abtastratenerhöhung', 'Location', 'Southeast')

figure % ideal vs W = 50; ZoH
semilogx(fb, mag2db(sqrt(err_zoh_u8i)));
hold on
semilogx(fb, mag2db(sqrt(err_zoh_u8)));
semilogx(fb, mag2db(sqrt(err_upsample8)));
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('ZoH X = 8 ideal', 'ZoH X = 8 W = 50', 'Abtastratenerhöhung', 'Location', 'Southeast')


figure % ideal vs W = 50; Lagrange N = 1
semilogx(fb, mag2db(sqrt(err_lagrange_1_ui)));
hold on
semilogx(fb, mag2db(sqrt(err_lagrange_1_u)));
semilogx(fb, mag2db(sqrt(err_upsample4)));
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('Lagrange N=1 X = 4 ideal', 'Lagrange N=1 X = 4 W = 50', 'Abtastratenerhöhung', 'Location', 'Southeast')

figure % ideal vs W = 100; Lagrange N = 3
semilogx(fb, mag2db(sqrt(err_lagrange_3_ui)));
hold on
semilogx(fb, mag2db(sqrt(err_lagrange_3_u)));
semilogx(fb, mag2db(sqrt(err_upsample4)));
xlabel('Frequenz [Hz]');
ylabel('Fehler [dB]');
legend('Lagrange N = 3 X = 4 ideal', 'Lagrange N = 3 X = 4 W = 50', 'Abtastratenerhöhung', 'Location', 'Southeast')