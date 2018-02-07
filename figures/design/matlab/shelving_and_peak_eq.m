%% Shelving and peak filters

clear all;

s = tf('s');

%% Shelving filter Low 1
om_zero = 100;
G = 5.7355;
s_LS = s/om_zero
Hs = (s_LS^2+sqrt(2*G)*s_LS+G)/(s_LS^2+sqrt(2)*s_LS+1);
Hs_low = Hs;

%% Shelving filter High 1
om_zero = 6400;
%G = 2;
s_HS = om_zero/s
Hs = (s_HS^2+sqrt(2*G)*s_HS+G)/(s_HS^2+sqrt(2)*s_HS+1);
Hs_high = Hs;

% %% Shelving filter low 2
% om_zero = 100;
% G = 2;
% Hs_low_2 = 1+G*om_zero/(s+om_zero)

% %% Shelving filter High 2
% om_zero = 1/10000;
% G = 2;
% Hs_high_2 = 1+G*om_zero/(1/s+om_zero)
% 
% %% Shelving filter low 3
% om_zero = 500;
% G = 2;
% Hs_low_3 = 1+G*om_zero/(s+om_zero)

% %% Shelving filter High 3
% om_zero = 1/50000;
% G = 2;
% Hs_high_3 = 1+G*om_zero/(1/s+om_zero)

%% Peak filter 1
om_zero = 200;
G = 4.6234;
Q = 1.5;
Hs = s/(om_zero*Q);
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2)
H_BP_1 = 1+G*H_LP*Hs

%% Peak filter 2
om_zero = 400;
G = 4.6234;
%Q = 2;
Hs = s/(om_zero*Q);
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2)
H_BP_2 = 1+G*H_LP*Hs

%% Peak filter 3
om_zero = 800;
G = 4.6234;
%Q = 2;
Hs = s/(om_zero*Q);
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2);
H_BP_3 = 1+G*H_LP*Hs;

%% Peak filter 4
om_zero = 1600;
G = 4.6234;
%Q = 2;
Hs = s/(om_zero*Q);
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2);
H_BP_4 = 1+G*H_LP*Hs;

%% Peak filter 5
om_zero = 3200;
G = 4.6234;
%Q = 2;
Hs = s/(om_zero*Q);
H_LP = om_zero^2/(s^2+om_zero/Q*s+om_zero^2);
H_BP_5 = 1+G*H_LP*Hs;

%% plotting
figure(1)
%bodemag(Hs_low_1,Hs_low_2,Hs_low_3,Hs_high_1,Hs_high_2,Hs_high_3)
H = H_BP_1*H_BP_2*H_BP_3*H_BP_4*H_BP_5*Hs_low*Hs_high;
bodemag(Hs_low,H_BP_1,H_BP_2,H_BP_3,H_BP_4,H_BP_5,Hs_high,H)
hold on
grid on
legend('Peak filter G = 6','Peak filter G = 3','Peak filter G = 1','High omega1 = 3000','High omega1 = 10000','High omega1 = 50000','Location','southwest')
% ylabel('Magnitude [dB]')
% xlabel('Frequency [rad/s]')
hold off
%FigureToPDF(gcf,'peak_filter')
H = H_BP_1*H_BP_2*H_BP_3*H_BP_4*H_BP_5*Hs_low*Hs_high;
% figure(2)
% bodemag(H)
% hold on
% grid on
% legend('Peak filter G = 6','Peak filter G = 3','Peak filter G = 1','High omega1 = 3000','High omega1 = 10000','High omega1 = 50000','Location','southwest')
% % ylabel('Magnitude [dB]')
% % xlabel('Frequency [rad/s]')
% hold off
% % FigureToPDF(gcf,'high_shelfing')
% done = 1
