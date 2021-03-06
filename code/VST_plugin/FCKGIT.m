clear variables
fs=44100;
ts=10;
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


Ts=1/fs;
bw=2*pi*(213+40);
o0=2*pi*234;
G=10^((8.5+2)/20);
Q=o0/bw;
filtergain=10^(10.5/20);

b(1)=4*Q+o0*(1+G)*Ts*2+(o0^2)*(Ts^2)*Q;
b(2)=-8*Q+2*(o0^2)*(Ts^2)*Q;
b(3)=4*Q-2*o0*Ts*(1+G)+(o0^2)*(Ts^2)*Q;
a(1)=4*Q+2*o0*Ts+(o0^2)*(Ts^2)*Q;
a(2)=-8*Q+2*(o0^2)*(Ts^2)*Q;
a(3)=4*Q-2*o0*Ts+(o0^2)*(Ts^2)*Q;

filtered=filter(a,b,OG*filtergain);

filteredn=filtered./max(abs(filtered));
OGn=OG./max(abs(filtered));

audiowrite('og_sweep_10s.wav',OGn,fs)
audiowrite('cost_sweep_10s.wav',filteredn,fs)

plot(OG)
hold on
plot(filtered)