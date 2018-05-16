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


fr=[0:1:620];
fo=[60:1:280];

 figure
 title('over viwe')
 yyaxis left
 plot(f,amplitude1,'o')
 hold on
 ylabel('Gain [dB]')
 xlabel('Frequency [Hz]')
 plot(fr,20*log10(polyval(p_filter_gain_back,fr)))
 plot(f,filter_gain_back,'o')
 over_all_eq_edit = [ones(1,(60))*polyval(p_over_all_eq,60) polyval(p_over_all_eq,fo) ones(1,((620-300))+20)*polyval(p_over_all_eq,280)];
 plot(fr,20*log10(over_all_eq_edit)-20*log10(over_all_eq_edit(1)))
 plot(f,deltaLp,'o')
 plot(fr,20*log10(polyval(p_gain,fr)))
 yyaxis right
 plot(f,rad2deg(phase1),'o')
 plot(fr,rad2deg(polyval(p_phase,fr)))
 ylabel('Phase Shift [Deg]')
 
 
 figure
 title('back speaker')
 yyaxis left
 ylabel('Gain [dB]')
 xlabel('Frequency [Hz]')
 semilogx(fr,20*log10(polyval(p_gain,fr))-20*log10(polyval(p_gain,0)))
  hold on
 yyaxis right
 plot(fr,rad2deg(polyval(p_phase,fr)))
 ylabel('Phase Shift [Deg]')


 
 figure
 title('over all')
 yyaxis left
 ylabel('Gain [dB]')
 xlabel('Frequency [Hz]')
 %over_all_eq_edit =[ones(1,(60))*polyval(p_over_all_eq,60) polyval(p_over_all_eq,f) ones(1,((620-300))+0)*polyval(p_over_all_eq,300)];
 semilogx(fr,20*log10(over_all_eq_edit)-20*log10(over_all_eq_edit(1)))
  hold on
 yyaxis right
 plot(fr,zeros(1,length(fr)))
 ylabel('Phase Shift [Deg]')

 first_filter = 20*log10(over_all_eq_edit)-20*log10(over_all_eq_edit(1));
 figure
 semilogx(fr,first_filter)
 %% The first filter
 first_filter = 20*log10(over_all_eq_edit)-20*log10(over_all_eq_edit(1));
 figure
 semilogx(fr,first_filter)
 i=find(first_filter<-3)
 Fc     = fr(i(1))
 f_up   = 125;
 f_down = 100;
 slope  = ((first_filter(f_up)-first_filter(f_down))/(log10(f_up)-log10(f_down)))
 order  = (-round(slope/10,0)*10)/20
 fs = 44100;
fcutlow  = 50;
fcuthigh = 60;
[b,a]    = butter(order,fcuthigh/(fs/2));
%[b,a]    = butter(order,[fcutlow,fcuthigh]/(fs/2), 'bandpass');
 
[h,w] = freqz(b,a);
semilogx(w/pi,20*log10(abs(h)))
 %% Filer for back speaker 
 
 
 back_filter_gain  = 20*log10(polyval(p_gain,fr))-20*log10(polyval(p_gain,0));
 back_filter_phase = rad2deg(polyval(p_phase,fr));
 
 figure
 semilogx(fr,back_filter_gain)
 hold on
 semilogx(fr,back_filter_phase)

 
 
%%
 over_all_filter_first=20*log10(over_all_eq_edit);%-20*log10(over_all_eq_edit(1));
 
 p_over_all_filter = polyfit(fr,10.^(over_all_filter_first./20),10);
 figure
semilogx(fr,20*log10(polyval(p_over_all_filter,fr)))
hold on
semilogx(fr,over_all_filter_first)
%semilogx(fr,20*log10(over_all_eq_edit)-20*log10(over_all_eq_edit(1)),'o') 
 
 