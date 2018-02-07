%% Minimum ripple shelving and peak filters

clear all;

G1_peak = 0.4125;
G2_peak = 0.9952;
G3_peak = 1.8183;
G4_peak = 2.9810;
G5_peak = 4.6234;

G1_shelv = 0.4125;
G2_shelv = 0.9953;
G3_shelv = 1.8185;
G4_shelv = 2.9812;
G5_shelv = 4.623;

s = tf('s');

min_ripple = 50;

for j = 1:50

% Shelving filter Low 
om_zero = 100*2*pi;
G = G5_shelv;
s_LS = s/om_zero;
Hs = G*om_zero/(s+om_zero);
Hs_low = Hs;

% Shelving filter High 
om_zero = 6400*2*pi;
%G = 2;
s_HS = om_zero/s;
Hs = G*(s/(s+om_zero));
Hs_high = Hs;

% Peak filter 1
om_zero = 200*2*pi;
x = 1;
G = G5_peak;
Q = 0.2*j;
Hs = s/(om_zero*Q);
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2);
H_BP_1 = G*H_LP*Hs

% Peak filter 2
om_zero = 400*2*pi;
G = G5_peak;
%Q = 2;
Hs = s/(om_zero*Q);
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2);
H_BP_2 = G*H_LP*Hs;

% Peak filter 3
om_zero = 800*2*pi;
G = G5_peak;
%Q = 2;
Hs = s/(om_zero*Q);
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2);
H_BP_3 = G*H_LP*Hs;

% Peak filter 4
om_zero = 1600*2*pi;
G = G5_peak;
%Q = 2;
Hs = s/(om_zero*Q);
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2);
H_BP_4 = G*H_LP*Hs;

% Peak filter 5
om_zero = 3200*2*pi;
G = G5_peak;
%Q = 2;
Hs = s/(om_zero*Q);
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2);
H_BP_5 = G*H_LP*Hs;

H = 1+H_BP_1+H_BP_2+H_BP_3+H_BP_4+H_BP_5+Hs_low+Hs_high;

% Finding ripple
fband = [100*2*pi,6400*2*pi];
[gpeak,fpeak] = getPeakGain(H,0.01,fband);
[gmin,fmin] = getPeakGain(H^(-1),0.01,fband);
Maximum = 20*log10(gpeak);
Minimum = 20*log10(gmin);
ripple = Maximum-abs(Minimum);

fband2 =[400*2*pi,500*2*pi];
[gpeak2,fpeak2] = getPeakGain(H_BP_1);
[gpeak3,fpeak3] = getPeakGain(H_BP_1,0.01,fband2);
w_0 = 20*log10(gpeak2);
w_1 = 20*log10(gpeak3);
diff = w_0-w_1;
if (ripple <= min_ripple) && (diff >=6)
    H_final = H;
    H_final_BP_1 = H_BP_1;
    H_final_BP_2 = H_BP_2;
    H_final_BP_3 = H_BP_3;
    H_final_BP_4 = H_BP_4;
    H_final_BP_5 = H_BP_5;
    j;
    min_ripple = ripple;
    Q_final = Q;
    diff_final = diff;
end
j
end
min_ripple
Q_final
diff_final
%% plotting
figure(1)
%bodemag(Hs_low_1,Hs_low_2,Hs_low_3,Hs_high_1,Hs_high_2,Hs_high_3)
opts = bodeoptions('cstprefs');
opts.FreqUnits = 'Hz';
bodemag(1+Hs_low,1+H_final_BP_1,(1+H_final_BP_2),1+H_final_BP_3,1+H_final_BP_4,1+H_final_BP_5,1+Hs_high,H_final,opts)
hold on
grid on
legend('Low shelving filter','Peak filter1','Peak filter2','Peak filter3','Peak filter4','Peak filter5','High shelving filter','Combined filter','Location','southwest')
% ylabel('Magnitude [dB]')
% xlabel('Frequency [rad/s]')
hold off
%FigureToPDF(gcf, '../eq_s_domain_comb')
figure(2)
bode(H_final)