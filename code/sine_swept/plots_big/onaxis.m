%clear all

angle=360;
fs=44100;

    load('ir_01.mat',(strcat('data',int2str((angle)*10))));
    IR1s=eval(strcat('data',int2str((angle)*10),'.ir(1:end/2)'));
    [tf1f(:),w]=freqz(IR1s,1,22000,fs);
    
    
    load('calibration_beamforming.mat');
    tf1 = tf1f./calibration.preamp_transfer_function';
    
   

    load('beamforming_25.mat',(strcat('data',int2str((angle)*10))));
    IR2s=eval(strcat('data',int2str((angle)*10),'.ir(1:end/2)'));
    [tf2f(:),w]=freqz(IR2s,1,22000,fs);
    
    tf2 = tf2f./calibration.preamp_transfer_function';
 tt = tf2(61:1:301);
 wt = w(61:1:301);
    
    figure(1)
plot(w,20*log10(abs(tf1)/(20*10^(-6))))
hold on
plot(wt,20*log10(abs(tt)/(20*10^(-6)))-flip((Lppolar(:,1)')-77))
xlim([60 300])
%figure(2)
%semilogx(w,20*log(abs(tf2./tf1)))
%xlim([60 300])

hold on
grid on

%axis([20 20000 20 100])
xlabel('Frequency [Hz]')
ylabel('SPL [dB]')
legend('Active','Disable')

%pbaspect([2 1 1])
set(gca,'FontSize', 12);
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
fig.PaperPositionMode   = 'auto';



