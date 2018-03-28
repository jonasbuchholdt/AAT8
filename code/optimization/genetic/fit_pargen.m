% analytical beamforming fitnes function
% based on point sources
% cost are weighted based on the desired emission characteristic
% CK 18-03-20
%
% %%% IN  %%%
% population: population that should be evaluated                  [struct]
% n: number of individuals in population                              [int]
% f: frequency that should be optimized                               [int]
% phi_cor: angular matrix of the correction table                  [matrix]
% f_cor: frequency matrix of the correction table                  [matrix]
% p_cor: pressure matrix of the correction table                   [matrix]
% 
% %%% OUT %%%
% sourcepar: parameter set that only depends on source positions   [struct]      
% ------------------------------------------------------------------------
function [sourcepar]=fitness_pargen(population,n,f,phi_cor,f_cor,p_cor)

r=10;                   % radius for pressure calculation 

c=343;                  % spee' gen. computed'd of sound
rho0=1.21;              % density of air
t=0;                    % time for pressure calculation, does not influence result

a=0.1651;                         % radius of the point source / m

angles=[0:pi/90:2.*pi];         % measurement points along the radius
coorx=sin(angles).*r;
coory=cos(angles).*r;

h=1;
% positions of the speakers are determined by tricenter function
[s1x,s1y,s2x,s2y,s3x,s3y]=tricenter( population.(strcat('gene',int2str(h))).Lx, population.(strcat('gene',int2str(h))).Ly);
% shifting values according to the position of the individual sources
% this leads to calculating the pressure at the same points in the room
% for each of the three point sources, so that they can be added together.
sourcepar=struct;
sourcepar.corrections1=[];
for h=1:length(f)
sourcepar.yshift1=coory-s1y;
sourcepar.xshift1=coorx-s1x;

phis1=2*pi-mod(angle(sourcepar.xshift1+i.*sourcepar.yshift1)+deg2rad(270),2*pi)';
sourcepar.corrections1(h,:)=interp2(phi_cor,f_cor,p_cor,phis1,f(h),'spline');

sourcepar.yshift2=coory-s2y;
sourcepar.xshift2=coorx-s2x;
phis2=2*pi-mod(angle(sourcepar.xshift2+i.*sourcepar.yshift2)-deg2rad(270),2*pi)';
sourcepar.corrections2(h,:)=interp2(phi_cor,f_cor,p_cor,phis1,f(h),'spline');

sourcepar.yshift3=coory-s3y;
sourcepar.xshift3=coorx-s3x;
phis3=2*pi-mod(angle(sourcepar.xshift3+i.*sourcepar.yshift3)-deg2rad(270),2*pi)';
sourcepar.corrections3(h,:)=interp2(phi_cor,f_cor,p_cor,phis1,f(h),'spline');
sourcepar.f=f;

end