clear variables
close all
load('turn_01.mat')
figure
plot(irtime,-data3600.ir)
hold on
plot(irtime,-data1800.ir)

shiftdistance=-0.055;         %shift distance in meter
yshift=-0.022;
shiftlag=shiftdistance/343;
timeres=max(irtime)/length(irtime);
number_shift=ceil(abs(shiftlag/timeres));
if shiftdistance>0
    irshifted=[zeros(1,number_shift) data1800.ir(1:end-number_shift)'];
else
    irshifted=[data1800.ir(number_shift:end)' zeros(1,number_shift-1)];
end
plot(irtime,-irshifted+yshift)