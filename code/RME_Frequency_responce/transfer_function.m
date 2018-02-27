% Automated Loudspeaker Directivity Measurement
% Using log. sine sweeps and a UDP-controled turntable
% based on MATLAB-Example ImpulseResponseMeasurer
%
% 2018-02-21
%
% -------------------------------------------------------------------------

clear variables

flower= 20;                             % lower frequency border for sweep      [Hz]
fupper=22000;                           % upper frequency border for sweep      [Hz]
ts= 1;                                  % length of sweep                        [s]
tw= 1;                                  % est. length of IR                      [s]
playgain=-57;                            % gain for sweep playback               [dB]

filename='Pioneer_A616_0dB_load.mat';                  % file name for storage

incal=0.1;                              % Input Calibration: What digital
                                        % RMS value corresponds to 1 Pa at
                                        % the microphone membrane?
                                        % 
outcal=0.1;                             % Output Calibration: What digital
                                        % RMS value corresponds to a
                                        % voltage of 1 Volt over the
                                        % speaker?
                                       

player=SynchronizedPlaybackAcquirer;    % initializing I-O via soundcard



    clear out
    out=struct;
    storename=strcat('Pioneer_A616_0dB_load');
   

        [fs,out.ir,irtime,out.tf,faxis]=IRmeas_fft(ts,tw,flower,fupper,playgain,player);
        assignin('base',storename,out);
        save(filename,'irtime','faxis','incal','outcal');
        save(filename,storename,'-append');
        clear (storename)

%%


clear all

load('RME_calibration')
figure(1)

load('Pioneer_A616_n40dB_load.mat')
transfer = Pioneer_A616_n40dB_load.tf-RME_calibeation;
semilogx(faxis,transfer,'r')


hold on
grid on

load('Pioneer_A616_n40dB_noload.mat')
transfer = Pioneer_A616_n40dB_noload.tf-RME_calibeation;
semilogx(faxis,transfer,'b')

load('Pioneer_A616_n16dB_load.mat')
transfer = Pioneer_A616_n16dB_load.tf-RME_calibeation;
semilogx(faxis,transfer,'r')

load('Pioneer_A616_n16dB_noload.mat')
transfer = Pioneer_A616_n16dB_noload.tf-RME_calibeation;
semilogx(faxis,transfer,'b')

load('Pioneer_A616_0dB_load.mat')
transfer = Pioneer_A616_0dB_load.tf-RME_calibeation;
semilogx(faxis,transfer,'r')

load('Pioneer_A616_0dB_noload.mat')
transfer = Pioneer_A616_0dB_noload.tf-RME_calibeation;
semilogx(faxis,transfer,'b')



axis([20 20000 -0 50])
ylabel('Amplification [dB]')
xlabel('Frequency [Hz]')

