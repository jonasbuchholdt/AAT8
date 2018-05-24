function [plotdata,degree] = FDTD_MEASUREMENT(frequency)
%%

%clear all

load('ir_01.mat')

%frequency = 60;


f = frequency; 
fs=44100;

astart=2;
ares=2;
astop=360;

angles=[astart:ares:astop];

for h=1:(astop/ares)
    IRs=eval(strcat('data',int2str((astart+(h-1)*ares)*10),'.ir(1:end/2)'));
    [tf_beam(:,h),w]=freqz(IRs,1,20000,fs);
end


[discard index]=min(abs(w-f));
p1=zeros(length(angles),1);
%plotdata=p1;


for h=1:length(f)
    for k=1:length(angles)
        p1(k)=(abs(tf_beam(index(h),k)));
    end
end

angles_need=[astart:1:astop];

vq = interp1(angles,p1,angles_need);

astart=5;
ares=5;
angles=[astart:ares:astop];

load('beamforming_25.mat')
for h=1:(astop/ares)
    IRs=eval(strcat('data',int2str((astart+(h-1)*ares)*10),'.ir(1:end/2)'));
    [tf_omni(:,h),w]=freqz(IRs,1,20000,fs);
end


[discard index]=min(abs(w-f));
p2=zeros(length(angles),1);
%plotdata=p2;


for h=1:length(f)
    for k=1:length(angles)
        p2(k)=(abs(tf_omni(index(h),k)));
    end
end





%for i=1:360/5
%p1t(i,1) = p1(round(((i*2.5)-2)/2)*2+2);
%end

%vq(length(vq)+1) = vq(1);

y = downsample(vq,5)

y = y';

%data = y;

%_____
data = p1;

astart=2;
ares=2;
astop=360;
angles=[astart:ares:astop];
%_______

%data = y./p2;
%data = tf_beam;
%data = tf_omni;
%data = tf_beam_first;


%drawing the missing line.
data(length(data)+1) = data(1);
angles(length(angles)+1)=angles(1);

 plotdata=(20*log10(data))';
 degree = deg2rad(angles);

