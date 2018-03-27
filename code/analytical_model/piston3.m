% simple line source, normed SPL as polar plot
clear variables
L=0.13*2.54;
a=L/2;
r=2.74;
c=343;
rho0=1.21;
t=0;
u0=0.01;
theta=[-pi:pi/180:pi];
%close all


f=60;
omega=2*pi*f;
k=omega/c;
p=(i/2).*rho0.*c.*u0.*(a./r).*k.*a.*((2*besselj(1,k.*a.*sin(theta)))./(k.*a.*sin(theta))).*exp(i.*(omega.*t-k.*r));
p=abs(p)./abs(max(p));
Lp=20.*log10(abs(p));
figure
polarplot(theta,Lp)
hold on

% 100 Hz
f=100;
omega=2*pi*f;
k=omega/c;
p=(i/2).*rho0.*c.*u0.*(a./r).*k.*a.*((2*besselj(1,k.*a.*sin(theta)))./(k.*a.*sin(theta))).*exp(i.*(omega.*t-k.*r));
p=abs(p)./abs(max(p));
Lp=20.*log10(abs(p));
polarplot(theta,Lp)

% 150 Hz
f=150;
omega=2*pi*f;
k=omega/c;
p=(i/2).*rho0.*c.*u0.*(a./r).*k.*a.*((2*besselj(1,k.*a.*sin(theta)))./(k.*a.*sin(theta))).*exp(i.*(omega.*t-k.*r));

c.*u0.*(a./r).*k.*a.*((2*besselj(1,k.*a.*sin(theta)))./(k.*a.*sin(theta))).*exp(i.*(omega.*t-k.*r));
p=abs(p)./abs(max(p));
Lp=20.*log10(abs(p));
polarplot(theta,Lp)

% 200 Hz
f=200;
omega=2*pi*f;
k=omega/c;
p=(i/2).*rho0.*c.*u0.*(a./r).*k.*a.*((2*besselj(1,k.*a.*sin(theta)))./(k.*a.*sin(theta))).*exp(i.*(omega.*t-k.*r));
p=abs(p)./abs(max(p));
Lp=20.*log10(abs(p));
polarplot(theta,Lp)

% 250 Hz
f=250;
omega=2*pi*f;
k=omega/c;
p=(i/2).*rho0.*c.*u0.*(a./r).*k.*a.*((2*besselj(1,k.*a.*sin(theta)))./(k.*a.*sin(theta))).*exp(i.*(omega.*t-k.*r));
p=abs(p)./abs(max(p));
Lp=20.*log10(abs(p));
polarplot(theta,Lp)

% 300 Hz
f=300;
omega=2*pi*f;
k=omega/c;
p=(i/2).*rho0.*c.*u0.*(a./r).*k.*a.*((2*besselj(1,k.*a.*sin(theta)))./(k.*a.*sin(theta))).*exp(i.*(omega.*t-k.*r));
p=abs(p)./abs(max(p));
Lp=20.*log10(abs(p));
polarplot(theta,Lp)



ax = gca;


rlim([-6 0])
rticks([-6:1:0])
%thetaticks([360-80:20:360])
thetaticks([0:20:360])
ax.ThetaTickLabel={'0','20','40','60','80','100','120','140','160','180','-160','-140','-120','-100','-80','-60','-40','-20'};
ax.RTickLabel={'','-5','','-3','','-1',''};
ax.RAxis.Label.String = 'normed SPL [dB]';
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
legend('f =  60 Hz','f = 100 Hz','f = 150 Hz','f = 200 Hz','f = 250 Hz','f = 300 Hz')
