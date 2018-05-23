clear variables
Lx=0.4;
Ly=0;

n=125;          % population size
N=10;            % number of generations



times=[1000 1000];

master=struct;
for k=1:length(Ly)
    for h=1:length(Lx)
        tic;
        master.og.(strcat('S_',int2str(abs(Lx(h)*100)),'_',int2str(abs(Ly(k)*100))))=fixed_gen(Lx(h),Ly(k),n,N);
        times=[times(end-1:end) toc];
        estimated_finish=mean(times)*((length(Ly)-k)*length(Lx)+(length(Lx)-h));
        display(strcat('Performing Optimizations, time left: ',int2str(floor(estimated_finish/3600)),':',int2str(floor(mod(estimated_finish,3600)/60)),':',int2str(floor(mod(estimated_finish,60)))))
    end
    save('flatspeaker.mat','master','Lx','Ly')
end

%%
% Cost calculation and storage
times=[1 1];

load('grid03.mat')
load('pressure_table_01.mat')           % path for correction tables
load('phase_table_neutral.mat')   

flower=master.og.(strcat('S_',int2str(abs(Lx(1)*100)),'_',int2str(abs(Ly(1)*100)))).fbot;
fupper=master.og.(strcat('S_',int2str(abs(Lx(1)*100)),'_',int2str(abs(Ly(1)*100)))).ftop;
fres=master.og.(strcat('S_',int2str(abs(Lx(1)*100)),'_',int2str(abs(Ly(1)*100)))).fres;
speakerangle=master.og.(strcat('S_',int2str(abs(Lx(1)*100)),'_',int2str(abs(Ly(1)*100)))).speakerangle;

master.cost_cor=zeros(length(Ly),length(Lx));
for k=1:length(Ly)
    for h=1:length(Lx)
        tic;
        master.cost_cor(k,h)=beam_cost(master.og.(strcat('S_',int2str(abs(Lx(h)*100)),'_',int2str(abs(Ly(k)*100)))),fupper,flower,fres,phi_mat,f_mat,p_mat,phase_mat,speakerangle);
        times=[times(end-1:end) toc];
        estimated_finish=mean(times)*((length(Ly)-k)*length(Lx)+(length(Lx)-h));
        display(strcat('Calculating Beamforming Cost, time left: ',int2str(floor(estimated_finish/3600)),':',int2str(floor(mod(estimated_finish,3600)/60)),':',int2str(floor(mod(estimated_finish,60)))))
    end
end
load('pressure_table_neutral.mat')           % path for correction tables
load('phase_table_neutral.mat')   

master.cost=zeros(length(Ly),length(Lx));
for k=1:length(Ly)
    for h=1:length(Lx)
        tic;
        master.cost(k,h)=beam_cost(master.og.(strcat('S_',int2str(abs(Lx(h)*100)),'_',int2str(abs(Ly(k)*100)))),fupper,flower,fres,phi_mat,f_mat,p_mat,phase_mat,speakerangle);
        times=[times(end-1:end) toc];
        estimated_finish=mean(times)*((length(Ly)-k)*length(Lx)+(length(Lx)-h));
        display(strcat('Calculating Beamforming Cost, time left: ',int2str(floor(estimated_finish/3600)),':',int2str(floor(mod(estimated_finish,3600)/60)),':',int2str(floor(mod(estimated_finish,60)))))
    end
end



%    save('G03.mat','master','Lx','Ly')
%%

clear variables
%load('G03.mat')
load('pressure_table_01.mat')           % path for correction tables
load('phase_table_neutral.mat') 
Lx=0.2:0.05:1;
Ly=-Lx;
flower=master.og.(strcat('S_',int2str(abs(Lx(1)*100)),'_',int2str(abs(Ly(1)*100)))).fbot;
fupper=master.og.(strcat('S_',int2str(abs(Lx(1)*100)),'_',int2str(abs(Ly(1)*100)))).ftop;
fres=master.og.(strcat('S_',int2str(abs(Lx(1)*100)),'_',int2str(abs(Ly(1)*100)))).fres;
speakerangle=master.og.(strcat('S_',int2str(abs(Lx(1)*100)),'_',int2str(abs(Ly(1)*100)))).speakerangle;
f=[flower:fres:fupper];

[~,I]=min(abs(master.cost(:)));
[min_row, min_col] = ind2sub(size(master.cost),I);
Lxopt=Lx(min_col);
Lyopt=Ly(min_row);

% %-----Manual plot target
%Lxopt=0.4;
%Lyopt=-0.4;
% %-----------------------

display(strcat('Lx: ',num2str(Lxopt),', Ly: ',num2str(Lyopt)))


[~,deltaLpc]=beam_cost(master.og.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))),fupper,flower,fres,phi_mat,f_mat,p_mat,phase_mat,speakerangle);

load('pressure_table_neutral.mat')           % path for correction tables
load('phase_table_neutral.mat')   

[~,deltaLpn]=beam_cost(master.og.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))),fupper,flower,fres,phi_mat,f_mat,p_mat,phase_mat,speakerangle);


[corLx,corLy]=meshgrid(Lx,Ly);

[master.reg.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))),filterdata]=regressor(master,Lx(min_row),Ly(min_col),f);

angles=[0:pi/180:2.*pi];         % measurement points along the radius
polardatog=pdata(master.og,Lxopt,Lyopt,'pressure_table_01.mat','phase_table_neutral.mat',angles);
polardatreg=pdata(master.reg,Lxopt,Lyopt,'pressure_table_01.mat','phase_table_neutral.mat',angles);

load('pressureout_05.mat')
master.fltrd.S_40_40=solutions;
for h=1:length(f)
    master.fltrd.S_40_40.(strcat('f',int2str(f(h)))).Va=master.fltrd.S_40_40.(strcat('f',int2str(f(h)))).Pa;
    master.fltrd.S_40_40.(strcat('f',int2str(f(h)))).Vb=master.fltrd.S_40_40.(strcat('f',int2str(f(h)))).Pb;
    master.fltrd.S_40_40.(strcat('f',int2str(f(h)))).Vc=master.fltrd.S_40_40.(strcat('f',int2str(f(h)))).Pc;
end
polardatfil=pdata(master.fltrd,Lxopt,Lyopt,'pressure_table_01.mat','phase_table_neutral.mat',angles);

for h=1:length(f)
    master.reg.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))).(strcat('f',int2str(f(h)))).Pa=1*(10^(deltaLpn(h)/20))*(master.reg.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))).(strcat('f',int2str(f(h)))).Va)/(master.reg.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))).(strcat('f',int2str(f(h)))).Vb);
    master.reg.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))).(strcat('f',int2str(f(h)))).Pb=1*(10^(deltaLpn(h)/20));
    master.reg.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))).(strcat('f',int2str(f(h)))).Pc=1*(10^(deltaLpn(h)/20));
end
master.reg.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))).deltaLpc=deltaLpc;
master.reg.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))).deltaLpn=deltaLpn;
master.reg.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))).filterdata=filterdata;

% 
% figure(3)
% subplot(2,2,1)
% plot(f,deltaLpc)
% hold on
% plot(f,deltaLpn)
% title('Beamforming Cost')
% xlabel('Frequency [Hz]')
% ylabel('Gain [dB]')
% grid minor
% xlim([flower fupper])
% legend('augmented','omnidirectional')
% 
% subplot(2,2,2)
% yyaxis left
% plot(f,filterdata.ogpres,'o')
% title('Filter Requirements: Beamforming')
% ylabel('Gain [dB]')
% xlabel('Frequency [Hz]')
% xlim([flower fupper])
% hold on
% plot(f,filterdata.regpres)
% yyaxis right
% plot(f,rad2deg(filterdata.ogphase),'o')
% plot(f,rad2deg(filterdata.regphase))
% ylabel('Phase Shift [Deg]')
% 
% 
% 
% subplot(2,2,3)
botlim=-27;
% polarplot(angles,polardatog(end,:))
% hold on
% polarplot(angles,polardatog(21,:))
% polarplot(angles,polardatog(16,:))
% polarplot(angles,polardatog(11,:))
% polarplot(angles,polardatog(6,:))
% polarplot(angles,polardatog(1,:))
% title('Optimal Characteristics')
% 
% ax = gca;
% thetaticks([0:20:360])
% rticks([-27:3:0])
% ax.RTickLabel={'','-24','','-18','','-12','','-6','','0'};
% 
% ax.ThetaTickLabel={'0','20','40','60','80','100','120','140','160','180','-160','-140','-120','-100','-80','-60','-40','-20'};
% ax.ThetaZeroLocation = 'top';
% ax.ThetaDir='clockwise';
% %ax.ThetaLim=[-90 90];
% rlim([botlim 0])
% legend('f =  60 Hz','f = 100 Hz','f = 150 Hz','f = 200 Hz','f = 250 Hz','f = 300 Hz')
% ax.RAxis.Label.String = 'normed SPL [dB]';
% 
% subplot(2,2,4)
% polarplot(angles,polardatreg(end,:))
% hold on
% polarplot(angles,polardatreg(21,:))
% polarplot(angles,polardatreg(16,:))
% polarplot(angles,polardatreg(11,:))
% polarplot(angles,polardatreg(6,:))
% polarplot(angles,polardatreg(1,:))
% title('Filtered Characteristics')
% 
% ax = gca;
% thetaticks([0:20:360])
% rticks([-27:3:0])
% ax.RTickLabel={'','-24','','-18','','-12','','-6','','0'};
% 
% ax.ThetaTickLabel={'0','20','40','60','80','100','120','140','160','180','-160','-140','-120','-100','-80','-60','-40','-20'};
% ax.ThetaZeroLocation = 'top';
% ax.ThetaDir='clockwise';
% %ax.ThetaLim=[-90 90];
% rlim([botlim 0])
% legend('f =  60 Hz','f = 100 Hz','f = 150 Hz','f = 200 Hz','f = 250 Hz','f = 300 Hz')
% ax.RAxis.Label.String = 'normed SPL [dB]';
% 
% 
% figure(4)
% surf(corLx,corLy,master.cost_cor)
% colormap('jet')
% %title('Cost Map')
% xlabel('Lx [m]')
% ylabel('Ly [m]')
% zlabel('Cost Value [1]')
% 
% figure(6)
% plot(f,deltaLpc)
% hold on
% plot(f,deltaLpn)
% title('Beamforming Cost')
% xlabel('Frequency [Hz]')
% ylabel('Gain [dB]')
% grid minor
% xlim([flower fupper])
% legend('augmented','omnidirectional')
% 
% figure(7)
% yyaxis left
% plot(f,filterdata.ogpres,'o')
% title('Filter Requirements: Beamforming')
% ylabel('Gain [dB]')
% xlabel('Frequency [Hz]')
% xlim([flower fupper])
% hold on
% plot(f,filterdata.regpres)
% yyaxis right
% plot(f,rad2deg(filterdata.ogphase),'o')
% plot(f,rad2deg(filterdata.regphase))
% ylabel('Phase Shift [Deg]')
% 
% 
% 
figure(8)
polarplot(angles,polardatog(end,:))
hold on
polarplot(angles,polardatog(21,:))
polarplot(angles,polardatog(16,:))
polarplot(angles,polardatog(11,:))
polarplot(angles,polardatog(6,:))
polarplot(angles,polardatog(1,:))
title('Optimal Characteristics')

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
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
fig.PaperPositionMode   = 'auto';

figure(9)
polarplot(angles,polardatreg(end,:))
hold on
polarplot(angles,polardatreg(21,:))
polarplot(angles,polardatreg(16,:))
polarplot(angles,polardatreg(11,:))
polarplot(angles,polardatreg(6,:))
polarplot(angles,polardatreg(1,:))
title('Regressed')

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
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
fig.PaperPositionMode   = 'auto';

figure(10)
polarplot(angles,polardatfil(end,:))
hold on
polarplot(angles,polardatfil(21,:))
polarplot(angles,polardatfil(16,:))
polarplot(angles,polardatfil(11,:))
polarplot(angles,polardatfil(6,:))
polarplot(angles,polardatfil(1,:))
title('Filter')

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

set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
fig.PaperPositionMode   = 'auto';
%save('G03.mat','master','Lx','Ly')
