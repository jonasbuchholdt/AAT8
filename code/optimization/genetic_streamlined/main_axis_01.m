clear variables




speakerangle=0;
load('G01.mat')

fbot=60;
fres=10;
ftop=300;

load('pressure_table_neutral.mat')
phi_cor=phi_mat;
f_cor=flip(f_mat);
p_cor=p_mat;
botlim=-27;

f=flip([fbot:fres:ftop]);

solutions=master.og.S_90_60;


r=10;

Lpolar=[];
thetasort=[];

angles=[0:pi/180:2.*pi];         % measurement points along the radius
c=343;
a=0.13*2.54/2;
rho0=1.21;
t=0;
Lpref=[];



for h=1:length(f)
    
omega=2*pi*f(h);
k=omega/c;
thetaa=tan(k*a);
velo(h)=(0.00002*10^(67.56/20))/(rho0.*c.*(a./10.*cos(thetaa).*exp(i.*(omega.*t-k.*(10-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phib))));%.*refcorrections1;
end

for h=1:length(f)

[s1x,s1y,s2x,s2y,s3x,s3y]=tricenter(solutions.(strcat('f',int2str(f(h)))).Lx,solutions.(strcat('f',int2str(f(h)))).Ly);



refs1x=s1x;
refs1y=s2y;
refs2x=s2x;
refs2y=s2y;
refs3x=s3x;
refs3y=s3y;

coorx=sin(angles).*r;
coory=cos(angles).*r;


omega=2*pi*f(h);
k=omega/c;
thetaa=tan(k*a);

yshift1=coory-s1y;
xshift1=coorx-s1x;

phis1=2*pi-mod(angle(xshift1+i.*yshift1)+deg2rad(270),2*pi)';
corrections1=interp2(phi_cor,f_cor,p_cor,phis1,f(h),'spline');

yshift2=coory-s2y;
xshift2=coorx-s2x;
phis2=2*pi-mod(angle(xshift2+i.*yshift2)-deg2rad(90)-speakerangle,2*pi)';
corrections2=interp2(phi_cor,f_cor,p_cor,phis1,f(h),'spline');

yshift3=coory-s3y;
xshift3=coorx-s3x;
phis3=2*pi-mod(angle(xshift3+i.*yshift3)-deg2rad(90)+speakerangle,2*pi)';
corrections3=interp2(phi_cor,f_cor,p_cor,phis1,f(h),'spline');

refyshift1=coory-refs1y;
refxshift1=coorx-refs1x;

refphis1=2*pi-mod(angle(refxshift1+i.*refyshift1)+deg2rad(270),2*pi)';
refcorrections1=interp2(phi_cor,f_cor,p_cor,refphis1,f(h),'spline');

refyshift2=coory-refs2y;
refxshift2=coorx-refs2x;
refphis2=2*pi-mod(angle(refxshift2+i.*refyshift2)-deg2rad(90),2*pi)';
refcorrections2=interp2(phi_cor,f_cor,p_cor,refphis2,f(h),'spline');

refyshift3=coory-refs3y;
refxshift3=coorx-refs3x;
refphis3=2*pi-mod(angle(refxshift3+i.*refyshift3)-deg2rad(90),2*pi)';
refcorrections3=interp2(phi_cor,f_cor,p_cor,refphis3,f(h),'spline');

p1=rho0.*c.*velo(h).*((solutions.(strcat('f',int2str(f(h)))).Va)/(solutions.(strcat('f',int2str(f(h)))).Vb).*(a./sqrt((xshift1.^2)+(yshift1.^2)))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift1.^2)+(yshift1.^2))-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phia)).*corrections1;
p2=rho0.*c.*velo(h).*(a./sqrt((xshift2.^2)+(yshift2.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift2.^2)+(yshift2.^2))-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phib)).*corrections2;
p3=rho0.*c.*velo(h).*(a./sqrt((xshift3.^2)+(yshift3.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift3.^2)+(yshift3.^2))-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phib)).*corrections3;

psum=p1+p2+p3;
Lpbeam=20*log10(abs(psum(1)));


refp1=rho0.*c.*(velo(h)).*(a./sqrt((refxshift1.^2)+(refyshift1.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((refxshift1.^2)+(refyshift1.^2))-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phib));%.*refcorrections1;
refp2=rho0.*c.*(velo(h)).*(a./sqrt((refxshift2.^2)+(refyshift2.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((refxshift2.^2)+(refyshift2.^2))-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phib));%.*refcorrections2;
refp3=rho0.*c.*(velo(h)).*(a./sqrt((refxshift3.^2)+(refyshift3.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((refxshift3.^2)+(refyshift3.^2))-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phib));%.*refcorrections3;

refpsum=refp1+refp2+refp3;
Lpref(h,:)=20*log10(abs(refpsum)./0.00002);


ppnorm=psum./max(psum);
Lppolar(h,:)=20.*log10(abs(psum)./0.00002);
deltaLp(h)=-(Lppolar(h,1)-Lpref(h,1));
for z=1:size(Lppolar,2)
    if Lppolar(h,z)<botlim
        Lppolar(h,z)=Lppolar(h,z-1);
    end
end
end

% close all
% figure
% polarplot(angles,Lpref(end,:))
% hold on
% polarplot(angles,Lpref(21,:))
% polarplot(angles,Lpref(16,:))
% polarplot(angles,Lpref(11,:))
% polarplot(angles,Lpref(6,:))
% polarplot(angles,Lpref(1,:))
% bx = gca;
% thetaticks([0:20:360])
% bx.ThetaTickLabel={'0','20','40','60','80','100','120','140','160','180','-160','-140','-120','-100','-80','-60','-40','-20'};
% bx.ThetaZeroLocation = 'top';
% bx.ThetaDir='clockwise';
% legend('f =  60 Hz','f = 100 Hz','f = 150 Hz','f = 200 Hz','f = 250 Hz','f = 300 Hz')
% bx.RAxis.Label.String = 'SPL [dB]';

for h=1:length(f)
    solutions.(strcat('f',int2str(f(h)))).Pa=1*(10^(deltaLp(h)/20))*(solutions.(strcat('f',int2str(f(h)))).Va)/(solutions.(strcat('f',int2str(f(h)))).Vb);
    solutions.(strcat('f',int2str(f(h)))).Pb=1*(10^(deltaLp(h)/20));
    solutions.(strcat('f',int2str(f(h)))).Pc=1*(10^(deltaLp(h)/20));
end


figure
plot(f,Lppolar(:,1))
hold on
plot(f,Lpref(:,1))
yyaxis right
plot(f,deltaLp)

% h=1;
% figure
% polarplot(angles,Lppolar(end,:))
% hold on
% polarplot(angles,Lppolar(21,:))
% polarplot(angles,Lppolar(16,:))
% polarplot(angles,Lppolar(11,:))
% polarplot(angles,Lppolar(6,:))
% polarplot(angles,Lppolar(1,:))
% save('pressureout_03.mat','solutions')
% ax = gca;
% thetaticks([0:20:360])
% rticks([-27:3:0])
% ax.RTickLabel={'','-24','','-18','','-12','','-6','','0'};
% 
% ax.ThetaTickLabel={'0','20','40','60','80','100','120','140','160','180','-160','-140','-120','-100','-80','-60','-40','-20'};
% ax.ThetaZeroLocation = 'top';
% ax.ThetaDir='clockwise';
% %ax.ThetaLim=[-90 90];
% rlim([botlim 0])
% legend('f =  60 Hz','f = 100 Hz','f = 150 Hz','f = 200 Hz','f = 250 Hz','f = 300 Hz')
% ax.RAxis.Label.String = 'normed SPL [dB]';
