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
playgain=-60;                            % gain for sweep playback               [dB]

filename='RME_fireface_02.mat';                  % file name for storage

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
    storename=strcat('data_rme');
   

        [fs,out.ir,irtime,out.tf,faxis]=IRmeas_fft(ts,tw,flower,fupper,playgain,player);
        assignin('base',storename,out);
        save(filename,'irtime','faxis','incal','outcal');
        save(filename,storename,'-append');
        clear (storename)

%%


clear all
%
load('RME_fireface_02.mat')
%%
load('RME_calibration')
%%
transfer = full.tf;%-RME_calibeation;
%figure(1)
%plot(data_rme.ir)
figure(1)
semilogx(faxis,transfer)
grid on

axis([20 20000 30 47])
ylabel('Amplification [dB]')
xlabel('Frequency [Hz]')

