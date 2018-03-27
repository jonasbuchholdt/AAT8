clear variables
load('sol14.mat')

load('cor_table_01.mat')
phi_cor=phi_mat;
f_cor=flip(f_mat);
p_cor=p_mat;
botlim=-27;

f=flip([fbot:fres:ftop]);

r=10;

Lpolar=[];
thetasort=[];

angles=[0:pi/180:2.*pi];         % measurement points along the radius
c=343;
a=13*2.54/2;
rho0=1.21;
t=0;

for h=1:length(f)

[s1x,s1y,s2x,s2y,s3x,s3y]=tricenter(solutions.(strcat('f',int2str(f(h)))).Lx,solutions.(strcat('f',int2str(f(h)))).Ly);


coorx=sin(angles).*r;
coory=cos(angles).*r;


omega=2*pi*f(h);
k=omega/c;
thetaa=tan(k*a);

yshift1=coory-s1y;
xshift1=coorx-s1x;
phis1=2*pi-mod(angle(xshift1+i.*yshift1)+deg2rad(270),2*pi)';
corrections1=interp2(phi_cor,f_cor,p_cor,phis1,f(h),'spline');

yshift2=coory-s2y;
xshift2=coorx-s2x;
phis2=2*pi-mod(angle(xshift2+i.*yshift2)-deg2rad(270),2*pi)';
corrections2=interp2(phi_cor,f_cor,p_cor,phis1,f(h),'spline');

yshift3=coory-s3y;
xshift3=coorx-s3x;
phis3=2*pi-mod(angle(xshift3+i.*yshift3)-deg2rad(270),2*pi)';
corrections3=interp2(phi_cor,f_cor,p_cor,phis1,f(h),'spline');

p1=rho0.*c.*solutions.(strcat('f',int2str(f(h)))).Va.*(a./sqrt((xshift1.^2)+(yshift1.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift1.^2)+(yshift1.^2))-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phia)).*corrections1;
p2=rho0.*c.*solutions.(strcat('f',int2str(f(h)))).Vb.*(a./sqrt((xshift2.^2)+(yshift2.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift2.^2)+(yshift2.^2))-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phib)).*corrections2;
p3=rho0.*c.*solutions.(strcat('f',int2str(f(h)))).Vc.*(a./sqrt((xshift3.^2)+(yshift3.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift3.^2)+(yshift3.^2))-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phib)).*corrections3;


psum=p1+p2+p3;
% Lp=20.*log10(abs(psum)/0.00002);
% % figure
% % contour(coorx,coory,Lp,'ShowText','on')
% % hold on
% % plot(10*s1x,10*s1y,'*')
% % plot(10*s2x,10*s2y,'*')
% % plot(10*s3x,10*s3y,'*')
% % axis equal

% pp=[];
% thetap=[];
% 
% for n=1:size(psum,1)
%    for m=1:size(psum,2)
%        if round(sqrt(((coorx(m,n))^2)+((coory(m,n))^2)),2)==r
%            pp=[pp psum(m,n)];
%            if coory(m,n)>0
%                thetap=[thetap atan(coorx(m,n)/coory(m,n))];
%            elseif (coory(m,n)<0)&&(coorx(m,n)>=0)
%                thetap=[thetap (atan(coorx(m,n)/coory(m,n))+pi)];
%            elseif (coory(m,n)<0)&&(coorx(m,n)<0)
%                thetap=[thetap (atan(coorx(m,n)/coory(m,n))-pi)];
%            elseif (coory(m,n)==0)&&(coorx(m,n)>0)
%                thetap=[thetap (pi/2)];
%            elseif (coory(m,n)==0)&&(coorx(m,n)<0)
%                thetap=[thetap (-pi/2)];
%            end
%        end
%    end
% end

% [thetasort(:,h),sortindex]=sort(thetap);
% pp=pp(sortindex);


ppnorm=psum./max(psum);
Lppolar(h,:)=20.*log10(abs(ppnorm));
for z=1:size(Lppolar,2)
    if Lppolar(h,z)<botlim
        Lppolar(h,z)=Lppolar(h,z-1);
    end
end
end

h=1;
figure
polarplot(angles,Lppolar(end,:))
hold on
polarplot(angles,Lppolar(21,:))
polarplot(angles,Lppolar(16,:))
polarplot(angles,Lppolar(11,:))
polarplot(angles,Lppolar(6,:))
polarplot(angles,Lppolar(1,:))

ax = gca;
thetaticks([0:20:360])
rticks([-27:3:0])
ax.RTickLabel={'','-24','','-18','','-12','','-6','','0'};

ax.ThetaTickLabel={'0','20','40','60','80','100','120','140','160','180','-160','-140','-120','-100','-80','-60','-40','-20'};
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
%ax.ThetaLim=[-90 90];
rlim([botlim 0])
legend('f =  60 Hz','f = 100 Hz','f = 150 Hz','f = 200 Hz','f = 250 Hz','f = 300 Hz')
ax.RAxis.Label.String = 'normed SPL [dB]';
