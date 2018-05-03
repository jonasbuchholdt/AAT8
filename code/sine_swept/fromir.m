clear variables
close all
load('beamforming_03.mat')

f=[60 100 150 200 250 300];

fs=44100;

astart=5;
ares=5;
astop=340;

angles=[astart:ares:astop];

for h=1:(astop/ares)
    IRs=eval(strcat('data',int2str((astart+(h-1)*ares)*10),'.ir(1:end/2)'));
    [tf(:,h),w]=freqz(IRs,1,5000,fs);
end
[discard index]=min(abs(w-f));

p1=zeros(length(angles),1);
plotdata=p1;
figure(1)

for h=1:length(f)
    for k=1:length(angles)
        p1(k)=(abs(tf(index(h),k)));
    end
    plotdata=20*log10(p1./max(p1))';
    polarplot(deg2rad(angles),plotdata)
    hold on
end

% figure
% polarplot(angles,valuesnorm1)
% hold on
% polarplot(angles,valuesnorm2)
% polarplot(angles,valuesnorm3)
% polarplot(angles,valuesnorm4)
% polarplot(angles,valuesnorm5)
% polarplot(angles,valuesnorm6)
ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
%ax.ThetaLim=[-90 90];
rlim([-27 0])
rticks([-27:3:0])
thetaticks([0:20:360])
ax.RTickLabel={'','-24','','-18','','-12','','-6','','0'};
ax.ThetaTickLabel={'0','20','40','60','80','100','120','140','160','180','-160','-140','-120','-100','-80','-60','-40','-20'};
ax.RAxis.Label.String = 'normed SPL [dB]';
legend('f =  60 Hz','f = 100 Hz','f = 150 Hz','f = 200 Hz','f = 250 Hz','f = 300 Hz')