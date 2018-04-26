clear variables
load('filter_parameter.mat')
fs=44100;
ts=2;
gainLin=1;

flower=20;
fupper=22000;

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
OG = [zeros(startSilence,1); x'; zeros(endSilence,1);zeros(506,1)];
filtered = filter(solutions.f1.ir_estimate,1,solutions.f1.filter_gain*OG);
crcorred = crosscorr(solutions.f1.ir_estimate,solutions.f1.filter_gain*OG);
tf=fft(crcorred)./fft(OG);
fraxis=(0:1:length(OG)-1)*fs/length(OG);

figure(1)
plot(OG)
hold on
plot(filtered)
plot(crcorred)

figure(2)
yyaxis left
plot(fraxis,abs(tf))
ylabel('Gain [dB]')
xlabel('Frequency [Hz]')
hold on
% plot(f,amplitude2)
% plot(f,amplitude3)
yyaxis right
plot(fraxis,rad2deg(angle(tf)))
ylabel('Phase Shift [Deg]')