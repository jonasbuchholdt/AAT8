clear variables
close all
load('p60.mat')
phi60=valuesnorm;
load('p100.mat')
phi100=valuesnorm;
load('p150.mat')
phi150=valuesnorm;
load('p200.mat')
phi200=valuesnorm;
load('p250.mat')
phi250=valuesnorm;

angles=[0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120 125 130 135 140 145 150 155 160 165 170 175 180 185 190 195 200 205 210 215 220 225 230 235 240 245 250 255 260 265 270 275 280 285 290 295 300 305 310 315 320 325 330 335 340 345 350 355];
angles=angles.*(pi/180);

figure
polarplot(angles,phi60)
hold on
polarplot(angles,phi100)
polarplot(angles,phi150)
polarplot(angles,phi200)
polarplot(angles,phi250)
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
%ax.ThetaLim=[-90 90];
rlim([-18 0])
rruler = ax.RAxis;
rruler.Label.String = 'Relative Sound Pressure [dB]';
legend('f =  60 Hz','f = 100 Hz','f = 150 Hz','f = 200 Hz','f = 250 Hz')
