% analytical beamforming fitnes function
% based on point sources
% cost are weighted based on the desired emission characteristic
% CK 18-03-20
%
% %%% IN  %%%
% population: population that should be evaluated                  [struct]
% n: number of individuals in population                              [int]
% f: frequencies that should be optimized                               [int]
% phi_cor: angular matrix of the correction table                  [matrix]
% f_cor: frequency matrix of the correction table                  [matrix]
% p_cor: pressure matrix of the correction table                   [matrix]
% speakerangle: angle for tilting the twin speakers inwards         [float]
% 
% %%% OUT %%%
% sourcepar: parameter set that only depends on source positions   [struct]      
% ------------------------------------------------------------------------
function [sourcepar]=fitness_pargen(population,n,f,phi_cor,f_cor,p_cor,phase_cor,speakerangle)

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
sourcepar.corrections=struct;
sourcepar.coordinates=struct;
sourcepar.corrections1=[];
sourcepar.f=f;
for h=1:length(f)
sourcepar.coordinates.yshift1=coory-s1y;
sourcepar.coordinates.xshift1=coorx-s1x;
phis1=2*pi-mod(angle(sourcepar.coordinates.xshift1+i.*sourcepar.coordinates.yshift1)+deg2rad(270),2*pi)';
sourcepar.corrections.pcor1(h,:)=interp2(phi_cor,f_cor,p_cor,phis1,f(h),'spline');
sourcepar.corrections.phasecor1(h,:)=interp2(phi_cor,f_cor,phase_cor,phis1,f(h),'spline');

sourcepar.coordinates.yshift2=coory-s2y;
sourcepar.coordinates.xshift2=coorx-s2x;
phis1=2*pi-mod(angle(sourcepar.coordinates.xshift2+i.*sourcepar.coordinates.yshift2)-deg2rad(90)-speakerangle,2*pi)';
sourcepar.corrections.pcor2(h,:)=interp2(phi_cor,f_cor,p_cor,phis1,f(h),'spline');
sourcepar.corrections.phasecor2(h,:)=interp2(phi_cor,f_cor,phase_cor,phis1,f(h),'spline');

sourcepar.coordinates.yshift3=coory-s3y;
sourcepar.coordinates.xshift3=coorx-s3x;
phis1=2*pi-mod(angle(sourcepar.coordinates.xshift3+i.*sourcepar.coordinates.yshift3)-deg2rad(90)+speakerangle,2*pi)';
sourcepar.corrections.pcor3(h,:)=interp2(phi_cor,f_cor,p_cor,phis1,f(h),'spline');
sourcepar.corrections.phasecor3(h,:)=interp2(phi_cor,f_cor,phase_cor,phis1,f(h),'spline');

end