%%
clear all
gain = -10;
cmd = 'ir'

[f_axis,f_result,t_axis,t_result] = Lacoustics(cmd,gain);
figure
plot(t_result)

%% sound card calibration
clear all
load('calibration_beamforming.mat')
    calibration.date = 02052018;  
save('calibration_beamforming.mat','calibration','-append'); 
gain = -10;
cmd = 'cali_rme'
Lacoustics(cmd,gain);
%%
load('calibration_beamforming.mat')
result = 20*log10(abs(calibration.preamp_transfer_function));
semilogx(result)
hold on
grid on
axis([20 20000 0 20])
xlabel('Frequency [Hz]')
ylabel('[dB]')

%% microphone calibration
clear all
cmd = 'cali_mic'
gain = -10;
[x_axis,result] = Lacoustics(cmd,gain);
load('calibration_beamforming.mat')

%% IR multi
gain = -12;
cmd = 'transfer'

[f_axis,f_result,t_axis,t_result] = Lacoustics(cmd,gain);
figure
plot(t_result)

%%
for i=1:20
clear all
cmd = 'transfer'
gain = -10;
[f_axis,f_result,t_axis,t_result] = Lacoustics(cmd,gain);
end
% figure(1)
% 
% t_result = t_result(1:end/2);
% t_axis = t_axis(1:end/2);
% plot(t_axis,t_result)
% [result,w] = freqz(t_result,1,22000,44100);
% 
% result = abs(result);
% result=20*log10(result/(20*10^-6));
% 
% figure(2)
% semilogx(w,result)
% hold on
% grid on
% 
% axis([50 500 50 100])
% xlabel('Frequency [Hz]')
% ylabel('Pressure [Pa]')

%%

% Automated Loudspeaker Directivity Measurement
% Using log. sine sweeps and a UDP-controled turntable
% based on MATLAB-Example ImpulseResponseMeasurer
%
% 2018-02-21
%
% -------------------------------------------------------------------------

clear variables


circres= 10;                             % angle resolution on circumference [degree]

flower= 20;                             % lower frequency border for sweep      [Hz]
fupper=22000;                           % upper frequency border for sweep      [Hz]
ts= 10;                                  % length of sweep                        [s]
tw= 1;                                  % est. length of IR                      [s]
playgain=-10;                            % gain for sweep playback               [dB]

filename='music_02.mat';                  % file name for storage

incal=0.1;                              % Input Calibration: What digital
                                        % RMS value corresponds to 1 Pa at
                                        % the microphone membrane?
                                        % 
outcal=0.1;                             % Output Calibration: What digital
                                        % RMS value corresponds to a
                                        % voltage of 1 Volt over the
                                        % speaker?
                                       

player=SynchronizedPlaybackAcquirer;    % initializing I-O via soundcard

ET250_3D('udp_start')

for k = 1:(360/circres)
    clear out
    out=struct;
    currentangle=k*circres;
    storename=strcat('data',int2str(currentangle*10));
    if currentangle == 360
        currentangle = 0;
    end    
     ET250_3D('set',currentangle);
     pause(0.1)
     actualangle=ET250_3D('get');
     
     while currentangle~=actualangle
         pause(0.1)
         actualangle=ET250_3D('get')
     end
    pause(2)
        %[fs,out.ir,irtime,out.tf,faxis]=IRmeas_fft(ts,tw,flower,fupper,playgain,player);
        cmd = 'transfer'
        gain = playgain;
        [faxis,out.tf,irtime,out.ir] = Lacoustics(cmd,gain);
        
        assignin('base',storename,out);
        if k==1
            save(filename,'irtime','faxis','incal','outcal');
        end
        save(filename,storename,'-append');
        clear (storename)
end

ET250_3D('udp_stop')
%%


%%

figure(1)

t_result = data100.ir(1:end/2);
irtimeh = irtime(1:end/2);
plot(irtimeh,t_result)
[result,w] = freqz(t_result,1,22000,44100);

result = abs(result);
result=20*log10(result/(20*10^-6));

figure(2)
semilogx(w,result)
hold on
grid on

axis([20 20000 20 100])
xlabel('Frequency [Hz]')
ylabel('Pressure [Pa]')


%%
clear all
load('Pioneer_A-616_16.mat')
%%
figure(1)
volt = (4.7*(10^(-18/20))*(10^((44-16)/20)))/sqrt(2);
result = (abs(data3600.tf));
result=20*log10(result/(20*10^-6));

semilogx(faxis,result)

grid on
axis([20 20000 50 100])
xlabel('Frequency [Hz]')
ylabel('Sensitivity @ (2.74 m,10.5 V) [dB SPL]')
