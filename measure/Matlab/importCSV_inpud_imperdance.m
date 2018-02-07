clear all;
filename = 'guitar_neck_picup.csv';
delimiterIn = ',';
headerlinesIn = 6;
mag_neck = importdata(filename,delimiterIn,headerlinesIn);

filename = 'guitar_neck_phase_picup.csv'; %fasen ligger i nr 4
delimiterIn = ',';
headerlinesIn = 6;
phase_neck = importdata(filename,delimiterIn,headerlinesIn);

for n = 1:5000
        lenght_neck(n) = (mag_neck.data(n,3)/mag_neck.data(n,2))*9980;
end

deg_neck(:) = (phase_neck.data(:,4));

for n = 1:5000
  z_neck(n) = lenght_neck(n)*(cos(deg_neck(n)*pi/180)+i*sin(deg_neck(n)*pi/180));     
end

filename = 'guitar_bridge_picup.csv';
delimiterIn = ',';
headerlinesIn = 6;
mag_bridge = importdata(filename,delimiterIn,headerlinesIn);

filename = 'guitar_bridge_phase_picup.csv'; %fasen ligger i nr 4
delimiterIn = ',';
headerlinesIn = 6;
phase_bridge = importdata(filename,delimiterIn,headerlinesIn);

for n = 1:5000
        lenght_bridge(n) = (mag_bridge.data(n,3)/mag_bridge.data(n,2))*9980;
end

deg_bridge(:) = (phase_bridge.data(:,4));

for n = 1:5000
  z_bridge(n) = lenght_bridge(n)*(cos(deg_bridge(n)*pi/180)+i*sin(deg_bridge(n)*pi/180));     
end

filename = 'guitar_neck_and_bridge_picup.csv';
delimiterIn = ',';
headerlinesIn = 6;
mag_both = importdata(filename,delimiterIn,headerlinesIn);

filename = 'guitar_neck_and_bridge_phase_picup.csv'; %fasen ligger i nr 4
delimiterIn = ',';
headerlinesIn = 6;
phase_both = importdata(filename,delimiterIn,headerlinesIn);

for n = 1:5000
        lenght_both(n) = (mag_both.data(n,3)/mag_both.data(n,2))*9980;
end

deg_both(:) = (phase_both.data(:,4));

for n = 1:5000
  z_both(n) = lenght_both(n)*(cos(deg_both(n)*pi/180)+i*sin(deg_both(n)*pi/180));     
end


figure
semilogx(mag_neck.data(:,1),real(z_neck(:)),mag_bridge.data(:,1),real(z_bridge(:)),mag_both.data(:,1),real(z_both(:)),'m')
axis([10 22000 0 100000])
set(gca,'fontsize',18)
hold on
grid on
legend('Neck','Bridge','Neck and bridge')
ylabel('Real impedance [Ohm]')
xlabel('Frequency [Hz]')
hold off

figure
semilogx(mag_neck.data(:,1),imag(z_neck(:)),mag_bridge.data(:,1),imag(z_bridge(:)),mag_both.data(:,1),imag(z_both(:)),'m')
axis([10 22000 -10000 10000])
set(gca,'fontsize',18)
hold on
grid on
legend('Neck','Bridge','Neck and bridge')
ylabel('Imaginary impedance [Ohm]')
xlabel('Frequency [Hz]')
hold off

