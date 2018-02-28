function [axis,result] = Lacoustics(cmd,gain)


switch cmd
    case 'cali_rme'
     calibrate(gain)  
     
    case 'cali_mic'
        [fs,y]=irmeas_fft_mic();            
        add = rms(y)      
        MICROPHONE_calibration = add;
        save('MICROPHONE_calibration.mat','MICROPHONE_calibration')
        result = y;
     axis = y;
     
     case 'ir'
         flower= 20;                             % lower frequency border for sweep      [Hz]
fupper=22000;                           % upper frequency border for sweep      [Hz]
ts= 1;                                  % length of sweep                        [s]
tw= 1;                                  % est. length of IR                      [s]
playgain=gain;                            % gain for sweep playback               [dB]
incal=0.1;                          
outcal=0.1;                             
player=SynchronizedPlaybackAcquirer;    % initializing I-O via soundcard
[fs,impulse_response,irtime,tf,faxis]=IRmeas_fft_rme(ts,tw,flower,fupper,playgain,player);
       axis = irtime;
       result = impulse_response;
       
    case 'transfer'
        [faxis, transfer_function, irtime, impulse_response] = Tranfer_function(gain);
     axis = faxis;
     result = transfer_function;
end