clear variables

angle=360;
fs=44100;

    load('beamforming_29.mat',(strcat('data',int2str((angle)*10))));
    IR1s=eval(strcat('data',int2str((angle)*10),'.ir(1:end/2)'));
    [tf1f(:),w]=freqz(IR1s,1,20000,fs);
    
    
    load('calibration_beamforming.mat');
    tf1 = tf1f./calibration.preamp_transfer_function;
    
    
    
    clearlist={strcat('data',int2str((angle)*10))};
    clear(clearlist{:})

    load('beamforming_25.mat',(strcat('data',int2str((angle)*10))));
    IR2s=eval(strcat('data',int2str((angle)*10),'.ir(1:end/2)'));
    [tf2f(:),w]=freqz(IR2s,1,20000,fs);
    
    load('calibration_beamforming.mat');
    tf2 = tf2f./calibration.preamp_transfer_function;
    
    clearlist={strcat('data',int2str((angle)*10))};
    clear(clearlist{:})

    c
    figure(1)
semilogx(w,20*log(abs(tf1)/(20*10^(-6))))
hold on
semilogx(w,20*log(abs(tf2)/(20*10^(-6))))
xlim([60 300])
figure(2)
semilogx(w,20*log(abs(tf2./tf1)))
xlim([60 300])