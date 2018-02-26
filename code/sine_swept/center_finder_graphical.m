clear variables
close all
load ('center_finder_01.mat')
figure
plot(irtime,data3600.ir)
hold on
plot(irtime,data1800.ir)

shiftdistance=0.05;         %shift distance in meter
shiftlag=shiftdistance/343;
timeres=max(irtime)/length(irtime);
number_shift=ceil(shiftlag/timeres);
irshifted=[zeros(1,number_shift) data1800.ir(1:end-number_shift)'];
plot(irtime,irshifted)