% triangular center arranger
% ck 18-02-09
% ------------------------------------------------------------------------
function [s1x,s1y,s2x,s2y,s3x,s3y]=tricenter(Lx,Ly)
xa=Lx/2;
ya=Ly;
xb=Lx;
yb=0;
xc=0;
yc=0;
xs=(xa+xb+xc)/3;
ys=(ya+yb+yc)/3;
s1x=xa-xs;
s1y=ya-ys;
s2x=xb-xs;
s2y=yb-ys;
s3x=xc-xs;
s3y=yc-ys;