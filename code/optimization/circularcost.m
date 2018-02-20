% analytical beamforming cost function
% based on point sources
% cost are weighted based on the desired emission characteristic
% CK 18-02-13
%
% f : frequency / Hz
% Lx: distance between the two rear speakers / m
% Ly: distance between front speaker & line between rear speakers / m
% u1: surface velocity for front speaker / (m/s)
% phi1: phase for front speaker / radiant
% .
% .
% .
% r: radius at which directivity is calculated
% ------------------------------------------------------------------------
function [cost]= circularcost(f,Lx,Ly,u1,phi1,u2,phi2,u3,phi3,r)

% positions of the speakers are determined by tricenter function
[s1x,s1y,s2x,s2y,s3x,s3y]=tricenter(Lx,Ly);

c=343;
rho0=1.21;
t=0;

omega=2*pi*f;
k=omega/c;

a=0.15;                         % radius of the point source / m
thetaa=tan(k/a);

xlength=[-11:0.025:11];         % X dimensions, resolution of grid
ylength=[-11:0.025:11];         % Y dimensions, resolution of grid
% meshgrid is making two matrices with X and Y values for the grid
[coorx,coory]=meshgrid(ylength,xlength);

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
p1=rho0.*c.*u1.*(a./sqrt((xshift1.^2)+(yshift1.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift1.^2)+(yshift1.^2))-a)+thetaa+phi1));
p2=rho0.*c.*u2.*(a./sqrt((xshift2.^2)+(yshift2.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift2.^2)+(yshift2.^2))-a)+thetaa+phi2));
p3=rho0.*c.*u3.*(a./sqrt((xshift3.^2)+(yshift3.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift3.^2)+(yshift3.^2))-a)+thetaa+phi3));

% adding the pressures together
psum=p1+p2+p3;

% initializing matrices to store pressure on a given radius within the grid
pp=[];
thetap=[];

% very crappy section that scans along for points at approx. radius r to
% the center of the grid (0|0)
% saves pressure of these points in pp and calculates the angle,
% stores the latter in thetap
for n=1:size(psum,1)
   for m=1:size(psum,2)
       if round(sqrt(((coorx(m,n))^2)+((coory(m,n))^2)),2)==r
           pp=[pp psum(m,n)];
           if coory(m,n)>0
               thetap=[thetap atan(coorx(m,n)/coory(m,n))];
           elseif (coory(m,n)<0)&&(coorx(m,n)>=0)
               thetap=[thetap (atan(coorx(m,n)/coory(m,n))+pi)];
           elseif (coory(m,n)<0)&&(coorx(m,n)<0)
               thetap=[thetap (atan(coorx(m,n)/coory(m,n))-pi)];
           elseif (coory(m,n)==0)&&(coorx(m,n)>0)
               thetap=[thetap (pi/2)];
           elseif (coory(m,n)==0)&&(coorx(m,n)<0)
               thetap=[thetap (-pi/2)];
           end
       end
   end
end


ppnorm=pp./max(pp);             % normalizing the pressure on the circle
Lppolar=20.*log10(abs(ppnorm)); % logarithmic representation

% IMPORTANT: Weighting section
% weight function is based on heuristics,
% low cost near zero degrees, high cost near +-180,
% this should lead to results with good emission towards the front and
% low emissions towards the back
weight=1-(cos(thetap./2)).^4;

weightedlp=(1000+Lppolar).*weight;
cost=sum(weightedlp);