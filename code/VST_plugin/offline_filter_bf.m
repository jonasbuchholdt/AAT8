clear variables
load('filter_parameter.mat')

phase_offset = -0.00;  % minus move the phase up.
population = 1000;
generation = 7000;
weight = 0;
rotate = -0;
add_gain = +0.00;
tap = 200;
phase = 38;

ir = generate_ir(solutions,rotate,add_gain,tap,phase);

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
filtered = filter(ir,1,solutions.f1.filter_gain*OG);
% crcorred = xcorr(solutions.f1.filter_gain*OG,ir);
tf=fft(filtered)./fft(OG);
fraxis=(0:1:length(OG)-1)*fs/length(OG);
%[freqResp ,w] = freqz(ir,1,22050,44100);
figure(1)
plot(OG)
hold on
plot(filtered)
% plot(crcorred)

figure(2)
yyaxis left
semilogx(fraxis(1:length(fraxis/2)),20*log10(abs(tf(1:length(fraxis/2)))))
hold on

ylabel('Gain [dB]')
xlabel('Frequency [Hz]')

yyaxis right
semilogx(fraxis(1:length(fraxis/2)),rad2deg(angle(tf(1:length(fraxis/2)))))

ylabel('Phase Shift [Deg]')

scaling=1/max(abs(filtered));
og_scaled=scaling.*OG;
filtered_scaled=scaling.*filtered;
audiowrite('front_bf.wav',og_scaled,fs)
audiowrite('rear_bf.wav',filtered_scaled,fs)

% figure(3)
% yyaxis left
% semilogx(w,20*log10(abs(solutions.f1.filter_gain*freqResp(1:length(w)))))
% yyaxis right
% semilogx(w,rad2deg(angle(freqResp(1:length(w)))))