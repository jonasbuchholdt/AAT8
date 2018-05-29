%load('pressureone.mat')

%%
clear all
frequency = 60;
load('G03')
load('pressureout_05.mat')
load('simulated_pressure_02_60_300.mat')

[plotdata,degree] = FDTD_MEASUREMENT(frequency)
%
%FDTD_SIMULATION(frequency,result)
[x,pp,psum] = FDTD_ANALYTIC(frequency,result,master.og.S_40_40)
%[x,pp,psum] = FDTD_ANALYTIC(frequency,result,solutions);

p_a=20*log10(abs(psum)/(20*10^(-6)));
p_s=20*log10(abs(pp)/(20*10^(-6)));


 for z=1:size(p_a,2)
     if p_a(z)<10
         p_a(z)=p_a(z-1);
     end
 end

figure
g = polarplot(p_a)
hold on
h = polarplot(x,p_s)

axt = gca;
RTickLabelMode = 'manual'
thetaticks([0:20:360])
rticks([12:3:48])
axt.RTickLabel={'','','18 -24','','24   -18','','30     -12','','36         -6','','42              0','','48'};
axt.RAxisLocation = 89;

ax = gca;
%ax.RTickLabel={'','','18 -24','','24  -18','','30   -12','','36    -6','','42     0','','48'};
ax.ThetaTickLabel={'0','20','40','60','80','100','120','140','160','180','-160','-140','-120','-100','-80','-60','-40','-20'};
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
%ax.ThetaLim=[-90 90];
botlim=10;
rlim([botlim 42])
anal = strcat('f = ',int2str(frequency),' Hz (Analytical)');
simu = strcat('f = ',int2str(frequency),' Hz (FDTD)');
legend(anal,simu,'Location','northoutside')
ax.RAxis.Label.String = 'Absolute SPL [dB]';


set(gca,'FontSize', 14);
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
fig.PaperPositionMode   = 'auto';


