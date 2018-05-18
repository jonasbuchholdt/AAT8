


[plotdata(1,:),degree] = FDTD_MEASUREMENT(60);
[plotdata(2,:),degree] = FDTD_MEASUREMENT(100);
[plotdata(3,:),degree] = FDTD_MEASUREMENT(150);
[plotdata(4,:),degree] = FDTD_MEASUREMENT(200);
[plotdata(5,:),degree] = FDTD_MEASUREMENT(250);
[plotdata(6,:),degree] = FDTD_MEASUREMENT(300);
%%

figure(5)
polarplot(degree,plotdata)
hold on

% polarplot(degree,plotdata(2,:))
% polarplot(degree,plotdata(3,:))
% polarplot(degree,plotdata(4,:))
% polarplot(degree,plotdata(5,:))
% polarplot(degree,plotdata(6,:))

axt = gca;
RTickLabelMode = 'manual'
thetaticks([0:20:360])
rticks([-36:3:6])
axt.RTickLabel={'','','','-27','','-21','','-15','','-9','','-3','','3',''};
%axt.RAxisLocation = 89;

ax = gca;
%ax.RTickLabel={'','','18 -24','','24  -18','','30   -12','','36    -6','','42     0','','48'};
ax.ThetaTickLabel={'0','20','40','60','80','100','120','140','160','180','-160','-140','-120','-100','-80','-60','-40','-20'};
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
%ax.ThetaLim=[-90 90];
botlim=-36;
rlim([botlim 6])
legend('f =  60 Hz','f = 100 Hz','f = 150 Hz','f = 200 Hz','f = 250 Hz','f = 300 Hz')
%resu = strcat('f = ',int2str(frequency),' Hz (Result)');
%anal = strcat('f = ',int2str(frequency),' Hz (Analytical)');
%simu = strcat('f = ',int2str(frequency),' Hz (FDTD)');
%legend(resu,'Location','eastoutside')
ax.RAxis.Label.String = 'Difference SPL [dB]';
resu,

set(gca,'FontSize', 14);
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
fig.PaperPositionMode   = 'auto';