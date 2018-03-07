clear variables
close all
load('dat60.mat')
for k=1:length(phi)
if phi(k)>180
    phi(k)=phi(k)-360;
elseif phi(k)<-180
    phi(k)=phi(k)+360;
end
end
phi60=[phi phi(1)];
load('dat100.mat')
for k=1:length(phi)
if phi(k)>180
    phi(k)=phi(k)-360;
elseif phi(k)<-180
    phi(k)=phi(k)+360;
end
end
phi100=[phi phi(1)];
load('dat150.mat')
for k=1:length(phi)
if phi(k)<0
    phi(k)=phi(k)+360;
end
end
phi150=[phi phi(1)];
load('dat200.mat')
for k=1:length(phi)
if phi(k)>360
    phi(k)=phi(k)-360;
elseif phi(k)<0
    phi(k)=phi(k)+360;
end
end
phi200=[phi phi(1)];
for k=1:length(phi)
if phi(k)>360
    phi(k)=phi(k)-360;
elseif phi(k)<-180
    phi(k)=phi(k)+360;
end
end
load('dat250.mat')
for k=1:length(phi)
if phi(k)>360
    phi(k)=phi(k)-360;
elseif phi(k)<-180
    phi(k)=phi(k)+360;
end
end
phi250=[phi phi(1)];
load('dat300.mat')
for k=1:length(phi)
if phi(k)>180
    phi(k)=phi(k)-360;
elseif phi(k)<-180
    phi(k)=phi(k)+360;
end
end
phi300=[phi phi(1)];

angles=[0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120 125 130 135 140 145 150 155 160 165 170 175 180 185 190 195 200 205 210 215 220 225 230 235 240 245 250 255 260 265 270 275 280 285 290 295 300 305 310 315 320 325 330 335 340 345 350 355];
angles=angles.*(pi/180);
angles=[angles angles(1)]
figure
polarplot(angles,phi60)
hold on
polarplot(angles,phi100)
polarplot(angles,phi150)
polarplot(angles,phi200)
polarplot(angles,phi250)
polarplot(angles,phi300)
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
%ax.ThetaLim=[-90 90];
rlim([-180 270])
rticks([-180:30:270])
thetaticks([0:20:360])
ax.RTickLabel={'','-150','','-90','','-30','','30','','90','','150','','210','','270'};
ax.ThetaTickLabel={'0','20','40','60','80','100','120','140','160','180','-160','-140','-120','-100','-80','-60','-40','-20'};
ax.RAxis.Label.String = 'Phase Angle [Deg]';
legend('f =  60 Hz','f = 100 Hz','f = 150 Hz','f = 200 Hz','f = 250 Hz','f = 300 Hz')
