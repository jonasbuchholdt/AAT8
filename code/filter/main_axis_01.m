clear variables

speakerangle=0;
load('regressed_04.mat')

load('cor_table_ones.mat')
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
a=0.13*2.54/2;
rho0=1.21;
t=0;
Lpref=[];



for h=1:length(f)
    
omega=2*pi*f(h);
k=omega/c;
thetaa=tan(k*a);
velo(h)=(0.00002*10^(67.56/20))/(rho0.*c.*(a./10.*cos(thetaa).*exp(i.*(omega.*t-k.*(10-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phib))));%.*refcorrections1;
end

for h=1:length(f)

[s1x,s1y,s2x,s2y,s3x,s3y]=tricenter(solutions.(strcat('f',int2str(f(h)))).Lx,solutions.(strcat('f',int2str(f(h)))).Ly);



refs1x=s1x;
refs1y=s2y;
refs2x=s2x;
refs2y=s2y;
refs3x=s3x;
refs3y=s3y;

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
phis2=2*pi-mod(angle(xshift2+i.*yshift2)-deg2rad(90)-speakerangle,2*pi)';
corrections2=interp2(phi_cor,f_cor,p_cor,phis1,f(h),'spline');

yshift3=coory-s3y;
xshift3=coorx-s3x;
phis3=2*pi-mod(angle(xshift3+i.*yshift3)-deg2rad(90)+speakerangle,2*pi)';
corrections3=interp2(phi_cor,f_cor,p_cor,phis1,f(h),'spline');

refyshift1=coory-refs1y;
refxshift1=coorx-refs1x;

refphis1=2*pi-mod(angle(refxshift1+i.*refyshift1)+deg2rad(270),2*pi)';
refcorrections1=interp2(phi_cor,f_cor,p_cor,refphis1,f(h),'spline');

refyshift2=coory-refs2y;
refxshift2=coorx-refs2x;
refphis2=2*pi-mod(angle(refxshift2+i.*refyshift2)-deg2rad(90),2*pi)';
refcorrections2=interp2(phi_cor,f_cor,p_cor,refphis2,f(h),'spline');

refyshift3=coory-refs3y;
refxshift3=coorx-refs3x;
refphis3=2*pi-mod(angle(refxshift3+i.*refyshift3)-deg2rad(90),2*pi)';
refcorrections3=interp2(phi_cor,f_cor,p_cor,refphis3,f(h),'spline');

p1=rho0.*c.*velo(h).*((solutions.(strcat('f',int2str(f(h)))).Va)/(solutions.(strcat('f',int2str(f(h)))).Vb).*(a./sqrt((xshift1.^2)+(yshift1.^2)))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift1.^2)+(yshift1.^2))-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phia)).*corrections1;
p2=rho0.*c.*velo(h).*(a./sqrt((xshift2.^2)+(yshift2.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift2.^2)+(yshift2.^2))-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phib)).*corrections2;
p3=rho0.*c.*velo(h).*(a./sqrt((xshift3.^2)+(yshift3.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift3.^2)+(yshift3.^2))-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phib)).*corrections3;

psum=p1+p2+p3;
Lpbeam=20*log10(abs(psum(1)));


refp1=rho0.*c.*(velo(h)).*(a./sqrt((refxshift1.^2)+(refyshift1.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((refxshift1.^2)+(refyshift1.^2))-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phib));%.*refcorrections1;
refp2=rho0.*c.*(velo(h)).*(a./sqrt((refxshift2.^2)+(refyshift2.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((refxshift2.^2)+(refyshift2.^2))-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phib));%.*refcorrections2;
refp3=rho0.*c.*(velo(h)).*(a./sqrt((refxshift3.^2)+(refyshift3.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((refxshift3.^2)+(refyshift3.^2))-a)+thetaa+solutions.(strcat('f',int2str(f(h)))).Phib));%.*refcorrections3;

refpsum=refp1+refp2+refp3;
Lpref(h,:)=20*log10(abs(refpsum));


ppnorm=psum./max(psum);
Lppolar(h,:)=20.*log10(abs(psum));
deltaLp(h)=-(Lppolar(h,1)-Lpref(h,1));
 for z=1:size(Lppolar,2)
     if Lppolar(h,z)<botlim
         Lppolar(h,z)=Lppolar(h,z-1);
     end
 end
end

close all


load('flipsol_08.mat')


for h=1:length(f)
    amplitude1(h)=20*log10((solutions.(strcat('f',int2str(f(h)))).Va)/(solutions.(strcat('f',int2str(f(h)))).Vb));
    phase1(h)=-(solutions.(strcat('f',int2str(f(h)))).Phib);
    if phase1(h)<0
        phase1(h)=phase1(h)+2*pi;
    end
end




% flip
f=flip(f);
amplitude1 = flip(amplitude1);
phase1 = flip(phase1);
deltaLp = flip(deltaLp);



% different
filter_gain_back =  deltaLp + amplitude1;



% the other
p_filter_gain_back = polyfit(f,10.^(filter_gain_back./20),4);
p_over_all_eq      = polyfit(f,10.^(deltaLp./20),20);
p_gain             = polyfit(f,10.^(amplitude1./20),2);
p_phase            = polyfit(f,phase1,2);
%---------------------------------------



 figure
 yyaxis left
 plot(f,amplitude1,'o')
 hold on
 ylabel('Gain [dB]')
 xlabel('Frequency [Hz]')
 plot(f,20*log10(polyval(p_filter_gain_back,f)))
 plot(f,filter_gain_back,'o')
 plot(f,20*log10(polyval(p_over_all_eq,f)))
 plot(f,deltaLp,'o')
 plot(f,20*log10(polyval(p_gain,f)))
 % plot(f,amplitude2)
 % plot(f,amplitude3)
 yyaxis right
 plot(f,rad2deg(phase1),'o')
 plot(f,rad2deg(polyval(p_phase,f)))
 ylabel('Phase Shift [Deg]')
 % plot(f,rad2deg(phase2))
 % plot(f,rad2deg(phase3))

 
 
 figure
 title('back speaker')
 yyaxis left
 ylabel('Gain [dB]')
 xlabel('Frequency [Hz]')
 plot(f,20*log10(polyval(p_filter_gain_back,f)))
  hold on
 % plot(f,amplitude2)
 % plot(f,amplitude3)
 yyaxis right
 plot(f,rad2deg(polyval(p_phase,f)))
 ylabel('Phase Shift [Deg]')
 % plot(f,rad2deg(phase2))
 % plot(f,rad2deg(phase3))

 
  figure
 title('front speaker')
 yyaxis left
 ylabel('Gain [dB]')
 xlabel('Frequency [Hz]')
  plot(f,20*log10(polyval(p_over_all_eq,f)))
  hold on
 % plot(f,amplitude2)
 % plot(f,amplitude3)
 yyaxis right
 plot(f,zeros(1,25))
 ylabel('Phase Shift [Deg]')
 % plot(f,rad2deg(phase2))
 % plot(f,rad2deg(phase3))

%%
% figure
% 

% 
% plot(deltaLp)
% hold on
% plot(20*log10(polyval(gaineqfit,f)))


pgain = flip(pgain);
%gaineqfit = flip(gaineqfit);

deltaLp = flip(deltaLp)
pgain = flip(pgain)
f = flip(f)


gaineqfit=polyfit(f,10.^(deltaLp./20),5);

figure
plot(f,polyval(gaineqfit,f))
hold on
%%
fr = ([60:10:300]);
gain = 20*log10((polyval(pgain,fr)));
phase = flip(polyval(pphase,fr));
gaineq = 20*log10(polyval(gaineqfit,fr));

diff = gain-gaineq;


fr = flip(fr);
plot(fr,gain)
hold on
plot(fr,gaineq)
%%

figure
gain_back = diff;%10.^(diff/20)
plot(fr,gain_back)
hold on
title('back speaker gain')
ylabel('[dB]')



figure
gain_front = gaineq;%10.^(gaineq/20)
plot(fr,gain_front)
hold on
title('front speaker gain')
ylabel('[dB]')




