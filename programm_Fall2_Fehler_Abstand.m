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
%       zoh + Upsampling X = 2
%       Lagrange N = 1 + Upsampling X = 2
%       Lagrange N = 3 + Upsampling X = 2
%
% Fehlerfunktion: Error
%
% Konstanten:
%               Abtastfrequenz:                 sample rate = 48 kHz
%               Geschwindigkeit:                vs = 35
%               Schallgeschwindigkeit:          c = 300
%               Länge der Zeit:                 t(end) = 5  
%               Frequenz:                       f = 4000
%


sample_rate = 48000;
dt = 1/ sample_rate;
t = 0:dt:0.5;
t2= 0:dt/2:t(end);
vs = 35;
c = 300;
l_min = 1;

f = 4000;


% Sender should pass receiver at t(end)/2
l_0 = vs*t(end)/2;

% Neue Abtastzeitpunkte durch den Dopplereffekt
[td, pre] = doppler_effect(vs, c, l_min, l_0, t); 

% Fehlervektoren erzeugen
err_zoh = t;
err_bandlimited = t;
err_lagrange_1 = t;
err_lagrange_3 = t;

err_zoh_ui  = f;
err_lagrange_1_ui = f;
err_lagrange_3_ui = f;

err_upsample2 = f;
err_zoh_u2  = f;
err_lagrange_1_u = f;
err_lagrange_3_u = f;



% Sinussignal mit der entsprechenden Frequenz Erzeugen
y = sin(2*pi*f*t);
    
% Interpolationsverfahren    
[zoh, t_zoh, begin_zoh] = zoh_rsp(y, sample_rate, td);
[bandlimited, t_bandlimited, begin_bl] = bandlimited_rsp(y, sample_rate, td, 5);
[lagrange_1, t_lagrange_1, begin_l1] = lagrange_splitting(y, sample_rate, td, 1);
[lagrange_3, t_lagrange_3, begin_l3] = lagrange_splitting(y, sample_rate, td, 3);
    
% Abtastratenerhöhung des Ausgangssignals um X = 4;

% ideal
y2i = sin(2*pi*f*t2);
[zoh_ui, t_zoh_ui, begin_zoh_ui] = zoh_rsp(y2i(1:length(y2i)-1), sample_rate*2, td);
[lagrange_1_ui, t_lagrange_1_ui, begin_l1_ui] = lagrange_splitting(y2i(1:length(y2i)-1), sample_rate*2, td, 1);
[lagrange_3_ui, t_lagrange_3_ui, begin_l3_ui] = lagrange_splitting(y2i(1:length(y2i)-1), sample_rate*2, td, 3);
% %     
% %via bandlimitied interpolation with W = 100
[y2, ty2, begin_y2] = bandlimited_rsp(y, sample_rate, t2, 100); 
[zoh_u, t_zoh_u,begin_zoh_u ] = zoh_rsp(y2(1:length(y2)-1), sample_rate*2, td);
[lagrange_1_u, t_lagrange_1_u, begin_l1_u] = lagrange_splitting(y2(1:length(y2)-1), sample_rate*2, td, 1);
[lagrange_3_u, t_lagrange_3_u, begin_l3_u] = lagrange_splitting(y2(1:length(y2)-1), sample_rate*2, td, 3);

% Fehlerberechnung
err_zoh = zoh - sin(2*pi*f*t_zoh);
err_bandlimited  = bandlimited - sin(2*pi*f*t_bandlimited);
err_lagrange_1 = lagrange_1 - sin(2*pi*f*t_lagrange_1);
err_lagrange_3 = lagrange_3 - sin(2*pi*f*t_lagrange_3);
    
err_zoh_ui  = zoh_ui - sin(2*pi*f*t_zoh_ui);
err_lagrange_1_ui = lagrange_1_ui - sin(2*pi*f*t_lagrange_1_ui);
err_lagrange_3_ui = lagrange_3_ui - sin(2*pi*f*t_lagrange_3_ui);

err_upsample2 = y2 - sin(2*pi*f*ty2);
err_zoh_u  = zoh_u - sin(2*pi*f*t_zoh_u);
err_lagrange_1_u = lagrange_1_u - sin(2*pi*f*t_lagrange_1_u);
err_lagrange_3_u = lagrange_3_u - sin(2*pi*f*t_lagrange_3_u);


figure % Standard Verfahren
subplot 221
plot(vs.*t(begin_zoh:length(zoh)+begin_zoh-1) - l_0, err_zoh);
title('ZoH')
xlabel('Abstand l_x [m]');
ylabel('Fehler');
subplot 222
plot(vs.*t(begin_bl:length(bandlimited)+begin_bl-1) - l_0, err_bandlimited);
title('Bandlimitierte Interpolation')
xlabel('Abstand l_x [m]');
ylabel('Fehler');
subplot 223
plot(vs.*t(begin_l1:length(lagrange_1)+begin_l1-1) - l_0, err_lagrange_1);
title('Lagrange N = 1');
xlabel('Abstand l_x [m]');
ylabel('Fehler');
subplot 224
plot(vs.*t(begin_l3:length(lagrange_3)+begin_l3-1) - l_0, err_lagrange_3);
title('Lagrange N = 3');
xlabel('Abstand l_x [m]');
ylabel('Fehler');

% figure % ideal 
% subplot 221
% plot(vs.*t(begin_zoh_ui:length(zoh_ui)+begin_zoh_ui-1) - l_0, err_zoh_ui);
% title('ZoH')
% xlabel('Abstand $l_x$ [m]');
% ylabel('Fehler');
% subplot 223
% plot(vs.*t(begin_l1_ui:length(lagrange_1_ui)+begin_l1_ui-1) - l_0, err_lagrange_1_ui);
% title('Lagrange N = 1');
% xlabel('Abstand $l_x$ [m]');
% ylabel('Fehler');
% subplot 224
% plot(vs.*t(begin_l3_ui:length(lagrange_3_ui)+begin_l3_ui-1) - l_0, err_lagrange_3_ui);
% title('Lagrange N = 3');
% xlabel('Abstand $l_x$ [m]');
% ylabel('Fehler');

figure % W = 100
subplot 221
plot(vs.*t(begin_zoh_u:length(zoh_u)+begin_zoh_u-1) - l_0, err_zoh_u);
title('ZoH')
xlabel('Abstand l_x [m]');
ylabel('Fehler');
subplot 222
plot(vs.*t2(begin_y2:length(y2)+begin_y2-1) - l_0, err_upsample2);
title('Upsample X = 2')
xlabel('Abstand l_x [m]');
ylabel('Fehler');
subplot 223
plot(vs.*t(begin_l1_u:length(lagrange_1_u)+begin_l1_u-1) - l_0, err_lagrange_1_u);
title('Lagrange N = 1');
xlabel('Abstand l_x [m]');
ylabel('Fehler');
subplot 224
plot(vs.*t(begin_l3_u:length(lagrange_3_u)+begin_l3_u-1) - l_0, err_lagrange_3_u);
title('Lagrange N = 3');
xlabel('Abstand l_x [m]');
ylabel('Fehler');