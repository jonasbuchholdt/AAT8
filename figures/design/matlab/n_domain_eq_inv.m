%% n-domain equalizer inverse

clear all;

om_zero_sh = [100, 6400]*2*pi;
om_zero_peak = [200,400,800,1600,3200]*2*pi;
om_zero_pw = om_zero_peak;
om_zero_pw_sh = om_zero_sh;
Q = 3.2;
G1_peak = 0.4125;
G2_peak = 0.9952;
G3_peak = 1.8183;
G4_peak = 2.9810;
G5_peak = 4.6234;
G = [G5_peak 0 G2_peak 0 0];
G_shelv = 1/(1+G2_peak);

%insert your input in this table
filename = 'gtr-jazz-3.wav';%'16Hz-20kHz-Lin-CA-10sec.mp3';
[input, fs] = audioread(filename);
fs
Td = 1/fs;

% Generate sweep for simulation
t = 0:Td:10;
fo = 20;
f1 = 20000;
sweep = chirp(t,fo,10,f1,'logarithmic');

sample_no = length(input); %Length of the input
filter_no = 5;
output = zeros(sample_no,1);
y = zeros(sample_no,filter_no+1);
sweep = sweep.';
sweep_l = length(sweep);
sweep_out = zeros(sweep_l,1);
sweep_out2 = zeros(sweep_l,1);
x = input;

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

%Peak coeff
for k = 1:5
b(1,k) = (4*Q+2*om_zero_pw(k)*Td+om_zero_pw(k)^2*Td^2*Q);
b(2,k) = (-8*Q+2*om_zero_pw(k)^2*Td^2*Q);
b(3,k) = (4*Q-om_zero_pw(k)*2*Td+om_zero_pw(k)^2*Td^2*Q);
a(1,k) = (4*Q+2*(G(k)+1)*om_zero_pw(k)*Td+om_zero_pw(k)^2*Td^2*Q);
a(2,k) = (-8*Q+2*om_zero_pw(k)^2*Td^2*Q);
a(3,k) = (4*Q-(G(k)+1)*om_zero_pw(k)*2*Td+om_zero_pw(k)^2*Td^2*Q); 
end


% for plot:
clear y;
clear x;
y = zeros(sweep_l,filter_no+1);
y_sh = zeros(sweep_l,2);
xin = zeros(sweep_l,filter_no+1);
x = zeros(sweep_l,filter_no+1);
xin = sweep;
x = xin;
% 
% %shelving filters
% for j = 1:2
% %filter:
% y_sh(1,j) = c(1,j)/d(1,j)*x(1,1);
% y_sh(2,j) = c(1,j)/d(1,j)*x(2,1)+c(2,j)/d(1,j)*x(1,1)-d(2,j)/d(1,j)*y_sh(1,j);
% for n = 3:1:sweep_l
% y_sh(n,j) = c(1,j)/d(1,j)*x(n,1)+c(2,j)/d(1,j)*x(n-1,1)-d(2,j)/d(1,j)*y_sh(n-1,j); %shelving 1
% end
% end

%peak filters
for j = 1:1:filter_no
%filter:
y(1,j) = a(1,j)/b(1,j)*x(1,1);
y(2,j) = a(1,j)/b(1,j)*x(2,1)+a(2,j)/b(1,j)*x(1,1)-b(2,j)/b(1,j)*y(2-1,j);
sweep_out(1,1) = y(1,j);
sweep_out(2,1) = y(2,j);
for n = 3:1:sweep_l
y(n,j) = b(1,j)/a(1,j)*x(n,1)+b(2,j)/a(1,j)*x(n-1,1)+b(3,j)/a(1,j)*x(n-2,1)-a(2,j)/a(1,j)*y(n-1,j)-a(3,j)/a(1,j)*y(n-2,j); %peak 1
%y(n,6) = y(n,6)+y(n,j);
sweep_out(n,1) = y(n,5);

end
%because its serial
x = y(:,j);
end

K = [1 2; 3 4]
L = zeros(2,1)

L = K(:,1)

b(1,1)/a(1,1)

%plot
figure(1)
hold on
grid on
plot(t,sweep_out(:,1),'b')
%plot(sweep(:,1),'r')
ylabel('Magnitude [V]')
xlabel('second')
hold off

% %plot
% figure(2)
% hold on
% grid on
% plot(t,sweep_out2(:,1),'b')
% %plot(sweep(:,1),'r')
% ylabel('Magnitude [V]')
% xlabel('second')
% hold off