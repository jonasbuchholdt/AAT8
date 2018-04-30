
clear all
load('G03.mat')


amplitude1 = master.reg.S_40_40.deltaLpc;
f=[60:10:300];


p_gain             = polyfit(f,amplitude1',2);


fr=[60:1:410];
full_filter_gain  = (polyval(p_gain,fr));

filter = -full_filter_gain+full_filter_gain(175-60)-1;
org = -amplitude1+full_filter_gain(175-60)-1;

filter_gain = [ ones(1,59)*org(1) filter ones(1,50)*org(1)];

f_full = [1:1:length(filter_gain)];

p_gain             = polyfit(f_full,filter_gain,15);




frz = [1:1:460];

%plot(frz,filter_gain)
figure
semilogx(-((polyval(p_gain,f_full))+8.5),'b--')
hold on
semilogx(f,-(-amplitude1+full_filter_gain(175-60)-1+8.5),'o','color','b')

 ylabel('Gain [dB]')
 xlabel('Frequency [Hz]')
%yyaxis right

slope = (full_filter_gain(11)-full_filter_gain(1))/(log10(fr(11))-log10(fr(1)))

% Polynomia for estimate the gaine and phase of the filter.

% bandwidth = 341 Hz - 128 hz

%for k=1:1:10000
%h_boost(k) = (1+(((omega_0/Q*s(k))/(s(k)^2+omega_0/Q*s(k)+omega_0^2))*2.3));
%end

%bandwidth = (341-128*1.1878)*1.3175;
%omega_0 = 234-0;

bandwidth = 2*pi*213
omega_0 = 2*pi*234
gain = 10^(8.5/20)

%bandwidth = 2*pi*(213+40)
%omega_0 = 2*pi*234
%gain = 10^(7.2/20)

Q = omega_0/bandwidth;

omega = [1:1:100000];
s = i.*omega;



for k=1:1:100000
h_cut(k) = ((((s(k)^2+omega_0/Q*s(k)+omega_0^2)/(s(k)^2+omega_0/Q*s(k)*(gain)+omega_0^2))));
end

abs_h = abs(h_cut);
%semilogx(abs_h)


db_abs_h = 20*log10(abs_h);

x = [1:1:100000]/(2*pi);

semilogx(x,db_abs_h,'color','b')


xlim([20 20000])
