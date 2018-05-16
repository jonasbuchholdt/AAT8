clear all
%close all

f=[60 100 150 200 250 300];

fs=44100;

astart=2;
ares=2;
astop=360;

angles=[astart:ares:astop];

for h=1:(astop/ares)
    load('beamforming_24.mat',(strcat('data',int2str((astart+(h-1)*ares)*10))));
    IR1s=eval(strcat('data',int2str((astart+(h-1)*ares)*10),'.ir(1:end/2)'));
    [tf1(:,h),w]=freqz(IR1s,1,10000,fs);
    clearlist={strcat('data',int2str((astart+(h-1)*ares)*10))};
    clear(clearlist{:})
end
[discard index]=min(abs(w-f));
for h=1:(astop/ares)
    load('beamforming_29.mat',(strcat('data',int2str((astart+(h-1)*ares)*10))));
    IR2s=eval(strcat('data',int2str((astart+(h-1)*ares)*10),'.ir(1:end/2)'));
    [tf2(:,h),w]=freqz(IR2s,1,10000,fs);
    clearlist={strcat('data',int2str((astart+(h-1)*ares)*10))};
    clear(clearlist{:})
end
%%
tf1(:,2)=tf2(:,2);
tf1(:,16)=tf2(:,16);
tf1(:,28)=tf2(:,28);
tf1(:,45)=tf2(:,45);
tf1(:,85)=tf2(:,85);
tf1(:,92)=tf2(:,92);
tf1(:,105)=tf2(:,105);
tf1(:,126)=tf2(:,126);
tf1(:,157)=tf2(:,157);
tf1(:,176)=tf2(:,176);


%%
p1=zeros(length(angles),1);
plotdata=p1;
figure(1)

for h=1:length(f)
    for k=1:length(angles)
        p1(k)=(abs(tf1(index(h),k)));
    end
%     p1(2)=p1(end-2);
%     p1(3)=p1(end-3);
%     p1(4)=p1(end-4);
    
    plotdata=20*log10(p1./max(p1))';
    for k=1:length(angles)
        if plotdata(k)<-27
            plotdata(k)=plotdata(k-1);
        end
    end
    polarplot(deg2rad([angles angles(1)]),[plotdata plotdata(1)])
    hold on
end
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
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
%%
figure(2)
for h=1:length(f)
    for k=1:length(angles)
        p2(k)=rad2deg(angle(tf1(index(h),k)));
%         if k>1
%             if abs(p2(k-1)-p2(k))>140
%                 p2(k)=p2(k)+360;
%             elseif abs(p2(k-1)+p2(k))<-140
%                 p2(k)=p2(k)-360;
%             end
%         end
    end
    p2(3)=(p2(2)+p2(4))/2;
    polarplot(deg2rad([angles angles(1)]),[p2 p2(1)])
    hold on
end

ax = gca;
ax.ThetaZeroLocation = 'top';
ax.ThetaDir='clockwise';
%ax.ThetaLim=[-90 90];
rlim([-210 210])
rticks([-210:30:210])
thetaticks([0:20:360])
ax.RTickLabel={'','-180','','-120','','-60','','0','','60','','120','','-180',''};
ax.ThetaTickLabel={'0','20','40','60','80','100','120','140','160','180','-160','-140','-120','-100','-80','-60','-40','-20'};
ax.RAxis.Label.String = 'Phase [Deg]';
legend('f =  60 Hz','f = 100 Hz','f = 150 Hz','f = 200 Hz','f = 250 Hz','f = 300 Hz')
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
