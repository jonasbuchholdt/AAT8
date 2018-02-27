clear variables
close all
load('turn_01.mat')
f=220;

[tf90,faxis]=freqz(data900.ir,1,16384,44100);
tf360=freqz(data3600.ir,1,16384,44100);
tf270=freqz(data2700.ir,1,16384,44100);
tf180=freqz(data1800.ir,1,16384,44100);

[discard index]=min(abs(faxis-f));
n=5;
phi1=mod(mean(rad2deg(atan(imag(tf90(index-n:index+n)))./real(tf90(index-n:index+n)))),360)
phi2=mod(mean(rad2deg(atan(imag(tf360(index-n:index+n)))./real(tf360(index-n:index+n)))),360)
phi3=mod(mean(rad2deg(atan(imag(tf270(index-n:index+n)))./real(tf270(index-n:index+n)))),360)
phi4=mod(mean(rad2deg(atan(imag(tf180(index-n:index+n)))./real(tf180(index-n:index+n)))),360)

lambda=343/f;



%shift=lambda*(deltaphi/720)