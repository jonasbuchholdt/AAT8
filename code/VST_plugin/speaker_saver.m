clear variables
load('band_par.mat')
[b,a]=sos2tf(SOS,G);
frontin=audioread('front_nohp.wav');
rearin=audioread('rear_nohp.wav');
frontout=filter(b,a,frontin);
rearout=filter(b,a,rearin);
fs=44100;

tf=fft(frontout)./fft(frontin);

if abs(max(rearout))>=abs(max(frontout))
    frontn=frontout;%frontout./abs(max(rearout));
    rearn=rearout;%rearout./abs(max(rearout));

end
fraxis=(0:1:length(frontn)-1)*fs/length(frontn);

audiowrite('front_final_10s.wav',frontn,44100)
audiowrite('back_final_10s.wav',rearn,44100)

tf2=fft(rearn)./fft(frontn);

close all
% figure(1)
% plot(frontin)
% hold on
% plot(frontout)
% plot(frontn)
% 
% figure(2)
% plot(rearin)
% hold on
% plot(rearout)
% plot(rearn)
% 
% figure(3)
% yyaxis left
% semilogx(fraxis(1:length(fraxis/2)),20*log10(abs(tf(1:length(fraxis/2)))))
% hold on
% grid minor
% ylabel('Gain [dB]')
% xlabel('Frequency [Hz]')

figure(4)
yyaxis left
plot(fraxis(1:length(fraxis/2)),20*log10(abs(tf2(1:length(fraxis/2)))))
hold on
xlim([60 300])
ylabel('Gain [dB]')
xlabel('Frequency [Hz]')

yyaxis right
plot(fraxis(1:length(fraxis/2)),rad2deg(angle(tf2(1:length(fraxis/2)))))

ylabel('Phase Shift [Deg]')
