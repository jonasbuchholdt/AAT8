clear variables
close all
load('beamforming_01.mat')
f=100;
[discard index]=min(abs(faxis-f));
angles=[0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120 125 130 135 140 145 150 155 160 165 170 175 180 185 190 195 200 205 210 215 220 225 230 235 240 245 250 255 260 265 270 275 280 285 290 295 300 305 310 315 320 325 330 335 340 345 350 355];
angles=angles.*(pi/180);
n=0;
values=[mean(data3600.tf(index-n:index+n)) mean(data50.tf(index-n:index+n)) mean(data100.tf(index-n:index+n)) mean(data150.tf(index-n:index+n)) mean(data200.tf(index-n:index+n)) mean(data250.tf(index-n:index+n)) mean(data300.tf(index-n:index+n)) mean(data350.tf(index-n:index+n)) mean(data400.tf(index-n:index+n)) mean(data450.tf(index-n:index+n)) mean(data500.tf(index-n:index+n)) mean(data550.tf(index-n:index+n)) mean(data600.tf(index-n:index+n)) mean(data650.tf(index-n:index+n)) mean(data700.tf(index-n:index+n)) mean(data750.tf(index-n:index+n)) mean(data800.tf(index-n:index+n)) mean(data850.tf(index-n:index+n)) mean(data900.tf(index-n:index+n)) mean(data950.tf(index-n:index+n)) mean(data1000.tf(index-n:index+n)) mean(data1050.tf(index-n:index+n)) mean(data1100.tf(index-n:index+n)) mean(data1150.tf(index-n:index+n)) mean(data1200.tf(index-n:index+n)) mean(data1250.tf(index-n:index+n)) mean(data1300.tf(index-n:index+n)) mean(data1350.tf(index-n:index+n)) mean(data1400.tf(index-n:index+n)) mean(data1450.tf(index-n:index+n)) mean(data1500.tf(index-n:index+n)) mean(data1550.tf(index-n:index+n)) mean(data1600.tf(index-n:index+n)) mean(data1650.tf(index-n:index+n)) mean(data1700.tf(index-n:index+n)) mean(data1750.tf(index-n:index+n)) mean(data1800.tf(index-n:index+n)) mean(data1850.tf(index-n:index+n)) mean(data1900.tf(index-n:index+n)) mean(data1950.tf(index-n:index+n)) mean(data2000.tf(index-n:index+n)) mean(data2050.tf(index-n:index+n)) mean(data2100.tf(index-n:index+n)) mean(data2150.tf(index-n:index+n)) mean(data2200.tf(index-n:index+n)) mean(data2250.tf(index-n:index+n)) mean(data2300.tf(index-n:index+n)) mean(data2350.tf(index-n:index+n)) mean(data2400.tf(index-n:index+n)) mean(data2450.tf(index-n:index+n)) mean(data2500.tf(index-n:index+n)) mean(data2550.tf(index-n:index+n)) mean(data2600.tf(index-n:index+n)) mean(data2650.tf(index-n:index+n)) mean(data2700.tf(index-n:index+n)) mean(data2750.tf(index-n:index+n)) mean(data2800.tf(index-n:index+n)) mean(data2850.tf(index-n:index+n)) mean(data2900.tf(index-n:index+n)) mean(data2950.tf(index-n:index+n)) mean(data3000.tf(index-n:index+n)) mean(data3050.tf(index-n:index+n)) mean(data3100.tf(index-n:index+n)) mean(data3150.tf(index-n:index+n)) mean(data3200.tf(index-n:index+n)) mean(data3250.tf(index-n:index+n)) mean(data3300.tf(index-n:index+n)) mean(data3350.tf(index-n:index+n)) mean(data3400.tf(index-n:index+n)) mean(data3450.tf(index-n:index+n)) mean(data3500.tf(index-n:index+n)) mean(data3550.tf(index-n:index+n))];
%valueslin=abs(values);

valueslin=abs(values)
valuesnorm=20.*log10(valueslin./max(valueslin));
save('b100.mat','valuesnorm')

figure
polarplot(angles,valuesnorm)
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
%ax.ThetaLim=[-90 90];
rlim([-27 0])