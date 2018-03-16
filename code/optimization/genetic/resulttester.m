[~,fitsort]=sort(fit);
h=fitsort(1);


r=10;                   % radius for pressure calculation

c=343;                  % speed of sound
rho0=1.21;              % density of air
t=0;                    % time for pressure calculation, does not influence result

omega=2*pi*f;
k=omega/c;

a=0.1651;                         % radius of the point source / m
thetaa=tan(k/a);

angles=[-pi:pi/120:pi];         % measurement points along the radius
coorx=cos(angles).*r;
coory=sin(angles).*r;

% positions of the speakers are determined by tricenter function
[s1x,s1y,s2x,s2y,s3x,s3y]=tricenter(population.(strcat('gene',int2str(h))).Lx,population.(strcat('gene',int2str(h))).Ly);

% shifting values according to the position of the individual sources
% this leads to calculating the pressure at the same points in the room
% for each of the three point sources, so that they can be added together.
yshift1=coory-s1y;
xshift1=coorx-s1x;

yshift2=coory-s2y;
xshift2=coorx-s2x;

yshift3=coory-s3y;
xshift3=coorx-s3x;

% calculating the pressure, caused by each source, at every point of the grid
p1=rho0.*c.*population.(strcat('gene',int2str(k))).Va.*(a./sqrt((xshift1.^2)+(yshift1.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift1.^2)+(yshift1.^2))-a)+thetaa+population.(strcat('gene',int2str(k))).Phia));
p2=rho0.*c.*population.(strcat('gene',int2str(k))).Vb.*(a./sqrt((xshift2.^2)+(yshift2.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift2.^2)+(yshift2.^2))-a)+thetaa+population.(strcat('gene',int2str(k))).Phib));
p3=rho0.*c.*population.(strcat('gene',int2str(k))).Vc.*(a./sqrt((xshift3.^2)+(yshift3.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift3.^2)+(yshift3.^2))-a)+thetaa+population.(strcat('gene',int2str(k))).Phic));
psum=p1+p2+p3;

Lp=20.*log10(abs(psum)/max(abs(psum)));
figure

figure
polarplot(angles,Lp)
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
%ax.ThetaLim=[-90 90];
rlim([-48 0])

population.(strcat('gene',int2str(fitsort(1))))