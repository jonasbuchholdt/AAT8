% simple line source, normated SPL as polar plot
%clear variables
L=0.24*2.4;
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
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
ax.ThetaLim=[-180 180];

rlim([-24 0])
rlim([-27 0])
rticks([-27:3:0])
thetaticks([-180:20:180])
%thetaticks([360-80:20:360])
ax.RTickLabel={'','-24','','-18','','-12','','-6','','0'};
ax.RAxis.Label.String = 'normed SPL [dB]';
legend('f =  60 Hz','f = 100 Hz','f = 150 Hz','f = 200 Hz','f = 250 Hz','f = 300 Hz')
