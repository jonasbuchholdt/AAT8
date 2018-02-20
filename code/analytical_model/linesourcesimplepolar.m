% simple line source, normated SPL as polar plot
clear variables
close all
t=0;
rho0=1.21;
c=343;
u0=0.01;
f=4000;
omega=2*pi*f;
k=omega/c;
L=0.2;
a=L/2;
theta=[-pi/2:pi/180:pi/2];
r=10;
%xlength=[-10:0.1:10];
%ylength=[0:0.1:20];
%[coorx,coory]=meshgrid(xlength,ylength);
p=(i/2).*rho0.*c.*u0.*(a./r).*k.*L.*((sin(0.5.*k.*L.*sin(theta)))./(0.5.*k.*L.*sin(theta))).*exp(i.*(omega.*t-k.*r));
p=abs(p)./abs(max(p));
Lp=20.*log10(abs(p));
figure
polarplot(theta,Lp)
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
ax.ThetaLim=[-90 90];
rlim([-24 0])