function [ir,irtime,tf,faxis]=IRmeas(ts,tw,flower,fupper,gainlevel,player)
            % out:  ir          - impulse response      [vector, lin]
            %       irtime      - time axis for IR        [vector, s]
            %       tf          - transfer function      [vector, dB]
            %       faxis       - frequency axis for tf  [vector, Hz]
            %
            % in:   ts          - sweep duration                  [s]
            %       tw          - waiting time                    [s]
            %       gainlevel   - output level (0,...,-inf)      [dB]
            %       flower      - lower frequency border         [Hz]
            %       fupper      - upper frequency border         [Hz]
            %       player      - record/play object from main program
            %
            % Function for capturing an impulse response using sine sweep methodology
            % References:
            % 1. "Comparison of Different Impulse Response Measurement Techniques" -
            % Stan Guy-Bart, Embrechts Jean-Jacques, Achambeau Dominique
            % http://www.montefiore.ulg.ac.be/~stan/ArticleJAES.pdf
            % 2. "Advancement in Impulse Response Measurements By Sine Sweeps" -
            % Angelo Farina. AES Paper.
            % 3. "A Method of Measuring Low-Noise
            % Acoustical Impulse Responses at0
            % High Sampling Rates"
            % https://www.princeton.edu/3D3A/Publications/Tylka_AES137_IRMeasurements-slides.pdf
            
            % properties
            gainLin = db2mag(gainlevel);
            %IRDuration = this.MinIRDuration;
            %this.ActualIRDuration = IRDuration;
            fs = player.SampleRate;
            
            
            % Set up swept sine using chirp function
            t = 0:1/fs:ts - (1/fs);

            x = chirp(t,flower,ts,fupper,'logarithmic');
            
            % apply gain scaling to form test signal x
            x = gainLin * x;
            
            % Add exponential/sin attenuation to the beginning and end of the excitation
            % signal in order to minimize the influence of transients.
            
            fadeInTime = 0.08;
            fadeInSamps = ceil(fadeInTime * fs); % number of samples over which to fade in/out
            
            % Calculate fadeIn/fadeOut vectors
            t1 = 0:1/fadeInSamps:1-(1/fadeInSamps);
            fadeIn = sin(1/2*pi*t1);
            
            fadeOutTime = 0.01;
            fadeOutSamps = ceil(fadeOutTime * fs); % number of samples over which to fade in/out
            t2 = (1-(1/fadeOutSamps):-(1/fadeOutSamps):0);
            fadeOut = sin(1/2*pi*t2);
            
            % Apply fade vectors
            x(1:fadeInSamps) = x(1:fadeInSamps) .* fadeIn;
            x(end-fadeOutSamps+1:end) = x(end-fadeOutSamps+1:end) .* fadeOut;
            
            % In practice, it is necessary to add silence to the end of the chirp to
            % ensure we don't lose the tail of the impulse response
            % We'll also add some to the start to account for latency
            startSilence = ceil(fs/10);
            endSilence = 2*fs;
            dataOut = [zeros(startSilence,1); x'; zeros(endSilence,1)];
            
            % Perform capture
            
            y(:,1) = playRecord(player, dataOut);
            

                % All captures should have zeros/noise at the start and end. So we
                % can circshift to align with the dataOut signal
                d = finddelay(dataOut,y(:,1));
                
                % Shift to align
                y(:,1) = circshift(y(:,1),-d);

            
            
            % Now convolve y with filtering impulse response f:
            % h(t) = y(t) * f(t)
            % f(t) is the time-reversal of the test signal x(t).
            f = flip(dataOut);
            
            % In addition, since x(t) spectrum is pink (-3dB per octave) we
            % must apply +3dB amplitude modulation to f(t) to compensate.
            
            % Create a decay vector. We want -6dB per octave and our chirp sweeps from
            % 10hz to 22000hz: log2(22000/10) = 11.1033 octaves.
            
            decay = 2.^((t/ts).*-1.0*(log2(fupper/flower)));
            f = f(endSilence+1:end-startSilence) .* decay';
            
            % Convolve to form h
            h = conv(y,f);
            
            % Apply time window to obtain just the "real" part of the IR.
            % The user specifies the length of the IR via a time duration
            % parameter
            startPt = max(1, startSilence + ts*fs - d);
            irEstimate = h(startPt : startPt + tw*fs);
            
            % Normalize IR such that peak value is 1.0
%            irMax = max(abs(irEstimate));
%            if irMax
%                this.ImpulseResponseVector = irEstimate ./ irMax;
%            else
%                this.ImpulseResponseVector = irEstimate;
%            end

        
            
            % Create a time axis vector
            t = 1/fs;
            x = (0:t:(length(irEstimate)/fs)-t)';
            ir = irEstimate;
            irtime = x;
            
            % Calculate response for entire frequency range
            [freqResp,w] = freqz(irEstimate,1,16384,fs);
            
            % Convert complex filt response to magnitude dB.
            tf = 20*log10(abs(freqResp));
            faxis = w;
            
    end