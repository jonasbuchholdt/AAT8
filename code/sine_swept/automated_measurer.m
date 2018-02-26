% Automated Loudspeaker Directivity Measurement
% Using log. sine sweeps and a UDP-controled turntable
% based on MATLAB-Example ImpulseResponseMeasurer
%
% 2018-02-21
%
% -------------------------------------------------------------------------

clear variables


circres= 5;                             % angle resolution on circumference [degree]

flower= 20;                             % lower frequency border for sweep      [Hz]
fupper=22000;                           % upper frequency border for sweep      [Hz]
ts= 1;                                  % length of sweep                        [s]
tw= 1;                                  % est. length of IR                      [s]
playgain=-18;                            % gain for sweep playback               [dB]

filename='turn_01.mat';                  % file name for storage

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
     pause(1)
     actualangle=ET250_3D('get');
     
     while currentangle~=actualangle
         pause(1)
         actualangle=ET250_3D('get')
     end
    pause(1)
        [fs,out.ir,irtime,out.tf,faxis]=IRmeas_fft(ts,tw,flower,fupper,playgain,player);
        assignin('base',storename,out);
        if k==1
            save(filename,'irtime','faxis','incal','outcal');
        end
        save(filename,storename,'-append');
        clear (storename)
end

ET250_3D('udp_stop')
%%

clear all
load('turn_01.mat')
figure(1)
plot(data3600.ir)
hold on
plot(data2700.ir)
plot(data900.ir)
plot(data1800.ir)
plot(data2500.ir)
plot(data1100.ir)
plot(data2300.ir)
plot(data1300.ir)
plot(data2100.ir)
plot(data1500.ir)
plot(data1900.ir)
plot(data1700.ir)
plot(data700.ir)
plot(data2900.ir)
plot(data500.ir)
plot(data3100.ir)
plot(data300.ir)
plot(data3300.ir)

%%
figure(3)
plot(faxis,data3600.tf)
hold on
plot(faxis,data1800.tf)
plot(faxis,data900.tf)
plot(faxis,data2700.tf)
plot(faxis,data500.tf)
plot(faxis,data3100.tf)