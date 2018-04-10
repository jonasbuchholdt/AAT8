function [coordinates,corrections]=prep(population,coorx,coory,phi_cor,f_cor,p_cor,phase_cor,speakerangle,f,h)

[s1x,s1y,s2x,s2y,s3x,s3y]= tricenter(population.(strcat('gene',int2str(h))).Lx, population.(strcat('gene',int2str(h))).Ly);
% shifting values according to the position of the individual sources
% this leads to calculating the pressure at the same points in the room
% for each of the three point sources, so that they can be added together.
coordinates=struct;
corrections=struct;
coordinates.yshift1=coory-s1y;
coordinates.xshift1=coorx-s1x;
phis1=2*pi-mod(angle(coordinates.xshift1+i.*coordinates.yshift1)+deg2rad(270),2*pi)';
corrections.pcor1=interp2(phi_cor,f_cor,p_cor,phis1,f,'spline');
corrections.phasecor1=interp2(phi_cor,f_cor,phase_cor,phis1,f,'spline');

coordinates.yshift2=coory-s2y;
coordinates.xshift2=coorx-s2x;
phis1=2*pi-mod(angle(coordinates.xshift2+i.*coordinates.yshift2)-deg2rad(90)-speakerangle,2*pi)';
corrections.pcor2=interp2(phi_cor,f_cor,p_cor,phis1,f,'spline');
corrections.phasecor2=interp2(phi_cor,f_cor,phase_cor,phis1,f,'spline');

coordinates.yshift3=coory-s3y;
coordinates.xshift3=coorx-s3x;
phis1=2*pi-mod(angle(coordinates.xshift3+i.*coordinates.yshift3)-deg2rad(90)+speakerangle,2*pi)';
corrections.pcor3=interp2(phi_cor,f_cor,p_cor,phis1,f,'spline');
corrections.phasecor3=interp2(phi_cor,f_cor,phase_cor,phis1,f,'spline');

end