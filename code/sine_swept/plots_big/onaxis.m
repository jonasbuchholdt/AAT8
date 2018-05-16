clear variables

angle=360;
fs=44100;

    load('beamforming_29.mat',(strcat('data',int2str((angle)*10))));
    IR1s=eval(strcat('data',int2str((angle)*10),'.ir(1:end/2)'));
    [tf1(:),w]=freqz(IR1s,1,20000,fs);
    clearlist={strcat('data',int2str((angle)*10))};
    clear(clearlist{:})

    load('beamforming_25.mat',(strcat('data',int2str((angle)*10))));
    IR2s=eval(strcat('data',int2str((angle)*10),'.ir(1:end/2)'));
    [tf2(:),w]=freqz(IR2s,1,20000,fs);
    clearlist={strcat('data',int2str((angle)*10))};
    clear(clearlist{:})
figure()
semilogx(w,20*log(abs(tf1)))
hold on
semilogx(w,20*log(abs(tf2)))
xlim([60 300])
figure()
semilogx(w,20*log(abs(tf2./tf1)))
xlim([60 300])