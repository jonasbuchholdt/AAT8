function FDTD_MEASUREMENT(frequency)

load('ir_01.mat')


f = frequency; 
fs=44100;

astart=2;
ares=2;
astop=360;

angles=[astart:ares:astop];

for h=1:(astop/ares)
    IRs=eval(strcat('data',int2str((astart+(h-1)*ares)*10),'.ir(1:end/2)'));
    [tf_beam_first(:,h),w]=freqz(IRs,1,20000,fs);
end


for i=1:360/5
tf_beam(:,i) = tf_beam_first(:,round(((i*2.5)-2)/2)*2+2);
end




astart=5;
ares=5;
angles=[astart:ares:astop];

load('beamforming_25.mat')
for h=1:(astop/ares)
    IRs=eval(strcat('data',int2str((astart+(h-1)*ares)*10),'.ir(1:end/2)'));
    [tf_omni(:,h),w]=freqz(IRs,1,20000,fs);
end

tf = tf_beam./tf_omni;

[discard index]=min(abs(w-f));
p1=zeros(length(angles),1);
plotdata=p1;


for h=1:length(f)
    for k=1:length(angles)
        p1(k)=(abs(tf(index(h),k)));
    end
end

%drawing the missing line.
p1(length(p1)+1) = p1(1);
angles(length(angles)+1)=angles(1);



figure(5)
plotdata=(20*log10(p1))';
polarplot(deg2rad(angles),plotdata)
hold on

% figure
% polarplot(angles,valuesnorm1)
% hold on
% polarplot(angles,valuesnorm2)
% polarplot(angles,valuesnorm3)
% polarplot(angles,valuesnorm4)
% polarplot(angles,valuesnorm5)
% polarplot(angles,valuesnorm6)
% ax = gca;
% ax.ThetaZeroLocation = 'top';
% ax.ThetaDir='clockwise';
% %ax.ThetaLim=[-90 90];
% rlim([40 90])
% rticks([40:3:90])
% thetaticks([0:20:360])
% ax.RTickLabel={'','-24','','-18','','-12','','-6','','0'};
% ax.ThetaTickLabel={'0','20','40','60','80','100','120','140','160','180','-160','-140','-120','-100','-80','-60','-40','-20'};
% ax.RAxis.Label.String = 'normed SPL [dB]';
% legend('f =  60 Hz','f = 100 Hz','f = 150 Hz','f = 200 Hz','f = 250 Hz','f = 300 Hz')



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
%resu = strcat('f = ',int2str(frequency),' Hz (Result)');
%anal = strcat('f = ',int2str(frequency),' Hz (Analytical)');
%simu = strcat('f = ',int2str(frequency),' Hz (FDTD)');
legend('Location','northoutside')
ax.RAxis.Label.String = 'Difference SPL [dB]';
resu,

set(gca,'FontSize', 14);
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
fig.PaperPositionMode   = 'auto';
