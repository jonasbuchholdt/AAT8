function calibrate(gain)
flower= 20;                             % lower frequency border for sweep      [Hz]
fupper=22000;                           % upper frequency border for sweep      [Hz]
ts= 1;                                  % length of sweep                        [s]
tw= 1;                                  % est. length of IR                      [s]
playgain=gain;                            % gain for sweep playback               [dB]
incal=0.1;                          
outcal=0.1;                             

player=SynchronizedPlaybackAcquirer;    % initializing I-O via soundcard
[fs,impulse_response,irtime,tf,faxis]=IRmeas_fft_rme(ts,tw,flower,fupper,playgain,player);
%tfm = mean(tf);
%trans = tf-tfm;
PREAMP_calibration=tf;
save('PREAMP_calibration.mat','PREAMP_calibration')

