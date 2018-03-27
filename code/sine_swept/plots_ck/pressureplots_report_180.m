clear variables
close all
load('p60.mat')
valuesnorm1=[valuesnorm valuesnorm(1)];
load('p100.mat')
valuesnorm2=[valuesnorm valuesnorm(1)];
load('p150.mat')
valuesnorm3=[valuesnorm valuesnorm(1)];
load('p200.mat')
valuesnorm4=[valuesnorm valuesnorm(1)];
load('p250.mat')
valuesnorm5=[valuesnorm valuesnorm(1)];
load('p300.mat');
valuesnorm6=[valuesnorm valuesnorm(1)];
load('p1500.mat');
valuesnorm7=[valuesnorm valuesnorm(1)];


angles=[0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120 125 130 135 140 145 150 155 160 165 170 175 180 185 190 195 200 205 210 215 220 225 230 235 240 245 250 255 260 265 270 275 280 285 290 295 300 305 310 315 320 325 330 335 340 345 350 355];
angles=angles.*(pi/180);
angles=[angles angles(1)];

figure
polarplot(angles,valuesnorm1)
hold on
polarplot(angles,valuesnorm2)
polarplot(angles,valuesnorm3)
polarplot(angles,valuesnorm4)
polarplot(angles,valuesnorm5)
polarplot(angles,valuesnorm6)
polarplot(angles,valuesnorm7)
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
%ax.ThetaLim=[-90 90];
rlim([-27 0])
rticks([-27:3:0])
thetaticks([0:20:360])
ax.RTickLabel={'','-24','','-18','','-12','','-6','','0'};
ax.ThetaTickLabel={'0','20','40','60','80','100','120','140','160','180','-160','-140','-120','-100','-80','-60','-40','-20'};
ax.RAxis.Label.String = 'normed SPL [dB]';
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
ax.ThetaLim=[-90 90];
legend('f =  60 Hz','f = 100 Hz','f = 150 Hz','f = 200 Hz','f = 250 Hz','f = 300 Hz','f = 1500 Hz')
