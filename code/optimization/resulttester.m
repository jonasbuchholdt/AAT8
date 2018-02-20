[s1x,s1y,s2x,s2y,s3x,s3y]=tricenter(Lx,Ly);

xlength=[-21:0.1:21];
ylength=[-21:0.1:21];
[coorx,coory]=meshgrid(ylength,xlength);

rho0 = 1.21;
c=343;
a=0.15;
thetaa=tan(k/a);
t=0;

omega=2*pi*f;
k=omega/c;

yshift1=coory-s1y;
xshift1=coorx-s1x;

yshift2=coory-s2y;
xshift2=coorx-s2x;

yshift3=coory-s3y;
xshift3=coorx-s3x;

p1=rho0.*c.*u1.*(a./sqrt((xshift1.^2)+(yshift1.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift1.^2)+(yshift1.^2))-a)+thetaa+phi1));
p2=rho0.*c.*u2.*(a./sqrt((xshift2.^2)+(yshift2.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift2.^2)+(yshift2.^2))-a)+thetaa+phi2));
p3=rho0.*c.*u3.*(a./sqrt((xshift3.^2)+(yshift3.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift3.^2)+(yshift3.^2))-a)+thetaa+phi3));
psum=p1+p2+p3;
Lp=20.*log10(abs(psum)/0.00002);
figure
contour(coorx,coory,Lp,'ShowText','on')
axis equal

pp=[];
thetap=[];

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

[thetasort,sortindex]=sort(thetap);
pp=pp(sortindex);

ppnorm=pp./max(pp);
Lppolar=20.*log10(abs(ppnorm));

figure
polarplot(thetasort,Lppolar)
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
%ax.ThetaLim=[-90 90];
rlim([-32 0])