%% z-domain equalizer
clear all;
format long g;
Fs = 44100;
Fp = 44100;
Td = 1/Fs;
om_zero_sh = [100, 6400]*2*pi;
om_zero_peak = [200,400,800,1600,3200]*2*pi;
%om_zero_pw = 2/Td*tan(om_zero/2)
%om_zero_pw = 2*atan(om_zero_peak*Td/2)
om_zero_pw = 2*Fs*tan(om_zero_peak/(2*Fs))
om_zero_pw_sh = 2*Fs*tan(om_zero_sh/(2*Fs))
% om_zero_pw = om_zero_peak;
% om_zero_pw_sh = om_zero_sh;
Q = 1.4; 

G1_peak = 0.4125;
G2_peak = 0.9952;
G3_peak = 1.8183;
G4_peak = 2.9810;
G5_peak = 4.6234;

G_shelv = 4.623;
s = tf('s');
z = tf('z',Td);
a = zeros(3,5);
b = zeros(3,5);
c = zeros(2,2);
d = zeros(2,2);

%Low Shelving coefficients
c(1,1) = G_shelv*om_zero_pw_sh(1)*Td;
c(2,1) = G_shelv*om_zero_pw_sh(1)*Td;
d(1,1) = 2+om_zero_pw_sh(1)*Td;
d(2,1) = -2+om_zero_pw_sh(1)*Td;

%High Shelving coefficients
c(1,2) = 2*G_shelv;
c(2,2) = -2*G_shelv;
d(1,2) = 2+om_zero_pw_sh(2)*Td;
d(2,2) = -2+om_zero_pw_sh(2)*Td;
 

%Peak coefficients 
% for k = 1:5
% b(1,k) = Q*4+om_zero_pw(k)*2*Td+Q*om_zero_pw(k)^2*Td^2;
% b(2,k) = (-Q*8+2*Q*om_zero_pw(k)^2*Td^2)
% b(3,k) = (Q*4-om_zero_pw(k)*2*Td+Q*om_zero_pw(k)^2*Td^2)
% a(1,k) = (Q*4+(G+1)*2*om_zero_pw(k)*Td+Q*om_zero_pw(k)^2*Td^2)
% a(2,k) = (-Q*8+2*Q*om_zero_pw(k)^2*Td^2)
% a(3,k) = (Q*4-(G+1)*om_zero_pw(k)*2*Td+Q*om_zero_pw(k)^2*Td^2)
% end

for k = 1:5
G = G5_peak;
    if k == 3
        G = G5_peak;
    end
b(1,k) = (4*Q+2*om_zero_pw(k)*Td+om_zero_pw(k)^2*Td^2*Q);
b(2,k) = (-8*Q+2*om_zero_pw(k)^2*Td^2*Q);
b(3,k) = (4*Q-om_zero_pw(k)*2*Td+om_zero_pw(k)^2*Td^2*Q);
a(1,k) = G*(om_zero_pw(k)*2*Td);
a(2,k) = 0;
a(3,k) = G*(-2*om_zero_pw(k)*Td); 
end

%Low shelving filter
H_z_LS = (z*c(1,1)+c(2,1))/(z*d(1,1)+d(2,1));

%Peak 1
H_z1 = (z^2*a(1,1)+z*a(2,1)+a(3,1))/(z^2*b(1,1)+z*b(2,1)+b(3,1));

%Peak 2
H_z2 = (z^2*a(1,2)+z*a(2,2)+a(3,2))/(z^2*b(1,2)+z*b(2,2)+b(3,2));

%Peak 3
H_z3 = (z^2*a(1,3)+z*a(2,3)+a(3,3))/(z^2*b(1,3)+z*b(2,3)+b(3,3));

%Peak 4
H_z4 = (z^2*a(1,4)+z*a(2,4)+a(3,4))/(z^2*b(1,4)+z*b(2,4)+b(3,4));

%Peak 5
H_z5 = (z^2*a(1,5)+z*a(2,5)+a(3,5))/(z^2*b(1,5)+z*b(2,5)+b(3,5))

%High shelving filter
H_z_HS = (z*c(1,2)+c(2,2))/(z*d(1,2)+d(2,2));

H_z_01 = H_z4+H_z5+H_z_HS;
H_z_02 = 1+H_z2+H_z3+H_z4;
H_z_03 = H_z_LS+H_z1+H_z2;
H_z = 1+H_z1+H_z2+H_z3+H_z4+H_z5+H_z_LS+H_z_HS;


% Plot
% figure(1)
% bodemag(H_z1,{0.1,10^6})
% 
% figure(2)
% bodemag(H_z2,{0.1,10^6})
% 
% figure(3)
% bodemag(H_z3,{0.1,10^6})
% 
% figure(4)
% bodemag(H_z4,{0.1,10^6})
% 
% figure(5)
% bodemag(H_z5,{0.1,10^6})
% 
% figure(6)
% bodemag(H_z_LS,{0.1,10^6})
% 
% figure(7)
% bodemag(H_z_HS,{0.1,10^6})

figure(8)
opts = bodeoptions('cstprefs');
opts.FreqUnits = 'Hz';
bodemag(H_z,1/H_z,1/(1+H_z_LS),1/(1+H_z1),1/(1+H_z2),1/(1+H_z3),1/(1+H_z4),1/(1+H_z5),1/(1+H_z_HS),(1+H_z_LS),(1+H_z1),(1+H_z2),(1+H_z3),(1+H_z4),(1+H_z5),(1+H_z_HS),{1,10^6},opts)
%legend('Low shelving filter','Peak filter1','Peak filter2','Peak filter3','Peak filter4','Peak filter5','High shelving filter','Combined filter','Location','northeast')
legend('Combined filter','Combined inv filter')
hold on
grid on
hold off
%FigureToPDF(gcf, '../eq_z_domain_final')


figure(9)
opts = bodeoptions('cstprefs');
opts.FreqUnits = 'Hz';
bodemag(1+H_z_LS,1+H_z1,1+H_z2,1+H_z3,1+H_z4,1+H_z5,1+H_z_HS,H_z_02,{0.1,10^6},opts)
hold on
grid on
hold off

