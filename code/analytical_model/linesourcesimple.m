% simple line source, SPL as grid plot
clear variables
%close all
t=0;
rho0=1.21;
c=343;
u0=0.1;
f=200;
omega=2*pi*f;
k=omega/c;
r=10;

xlength=[-20:0.05:20];
ylength=[0:0.05:20];
[coorx,coory]=meshgrid(ylength,xlength);


yshift1=coory+0.0525+0.0279;
xshift1=coorx-1.0185;
thetashift1=atan(yshift1./xshift1)-deg2rad(32);
L1=0.07;
a1=L1/2;


yshift2=coory-0.0525-0.0279;
xshift2=coorx-1.0185;
thetashift2=atan(yshift2./xshift2)+deg2rad(32);
L2=0.07;
a2=L2/2;

yshift3=coory;
xshift3=coorx-1;
thetashift3=atan(yshift3./xshift3);
L3=0.105;
a3=L3/2;


p1=(i/2).*rho0.*c.*u0.*(a1./sqrt((xshift1.^2)+(yshift1.^2))).*k.*L1.*((sin(0.5.*k.*L1.*sin(thetashift1)))./(0.5.*k.*L1.*sin(thetashift1))).*exp(i.*(omega.*t-k.*sqrt((xshift1.^2)+(yshift1.^2))));
p2=(i/2).*rho0.*c.*u0.*(a2./sqrt((xshift2.^2)+(yshift2.^2))).*k.*L2.*((sin(0.5.*k.*L2.*sin(thetashift2)))./(0.5.*k.*L2.*sin(thetashift2))).*exp(i.*(omega.*t-k.*sqrt((xshift2.^2)+(yshift2.^2))));
p3=(i/2).*rho0.*c.*u0.*(a3./sqrt((xshift3.^2)+(yshift3.^2))).*k.*L3.*((sin(0.5.*k.*L3.*sin(thetashift3)))./(0.5.*k.*L3.*sin(thetashift3))).*exp(i.*(omega.*t-k.*sqrt((xshift3.^2)+(yshift3.^2))));
psum=p1+p2+p3;
Lp=20.*log10(abs(psum)/0.00002);
figure
contour(coorx,coory,Lp,'ShowText','on')
hold on

%surf(coorx,coory,Lp)