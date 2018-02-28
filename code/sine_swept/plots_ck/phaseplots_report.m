clear variables
close all
load('dat60.mat')
phi60=phi;
load('dat100.mat')
phi100=phi;
load('dat150.mat')
phi150=phi;
load('dat200.mat')
phi200=phi;
load('dat250.mat')
phi250=phi;

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
rlim([0 360])
rruler = ax.RAxis;
rruler.Label.String = 'Phase Angle [Deg]';
legend('f =  60 Hz','f = 100 Hz','f = 150 Hz','f = 200 Hz','f = 250 Hz')