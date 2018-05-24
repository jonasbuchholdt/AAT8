clear variables
close all
%%
% Generate Initial Sweep
fs=44100;       % Sample Frequency
ts=10;          % Sweep length [s]
gainLin=1;      % Gain of Sweep

flower=20;      % Sweep lowest Frequency
fupper=22000;   % Sweep highest Frequency

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
% OG: Original Sweep, base of all filtering / scaling
OG = [zeros(startSilence,1); x'; zeros(endSilence,1);zeros(506,1)];

OG = audioread('chililoop.wav');

%%
% Cost Filtering, Band Stop with Gain
Ts=1/fs;                % Sample time
bw=2*pi*(293);          % Band Width
o0=2*pi*234;            % Center Frequency of Bandstop
G=10^((12.5)/20);       % Filter Intern Gain
Q=o0/bw;                % Güte
filtergain=10^(10.4/20);% Overall Amplification

% Filter Parameters
b(1)=4*Q+o0*(G)*Ts*2+(o0^2)*(Ts^2)*Q;
b(2)=-8*Q+2*(o0^2)*(Ts^2)*Q;
b(3)=4*Q-2*o0*Ts*(G)+(o0^2)*(Ts^2)*Q;
a(1)=4*Q+2*o0*Ts+(o0^2)*(Ts^2)*Q;
a(2)=-8*Q+2*(o0^2)*(Ts^2)*Q;
a(3)=4*Q-2*o0*Ts+(o0^2)*(Ts^2)*Q;

% Applying cost filter to OG, a and b swapped to make bandpass a bandstop
costfiltered=filter(a,b,OG*filtergain);

%%
% Beamforming Filter for rear speaker (Signal A) (FIR, LP)

load('filter_parameter.mat')   % loading optimization result

phase_offset = -0.00;  % minus moves the phase up.
population = 1000;
generation = 7000;
weight = 0;
rotate = -0;
add_gain = +0.00;
tap = 200;
phase = 38;

% generating filter IR out of optimization result
ir = generate_ir(solutions,rotate,add_gain,tap,phase);

beamfiltered = filter(ir,1,solutions.f1.filter_gain*costfiltered);

%%
% Speaker Saving Filter (BP)
clear b
clear a
load('band_par.mat')                % loading filter parameters
[b,a]=sos2tf(SOS,G);                % converting parameters to a,b
frontout=filter(b,a,costfiltered);  % signal for front speakers
rearout=filter(b,a,beamfiltered);   % signal for rear speaker

frontoutn=frontout./max(abs(rearout));
rearoutn=rearout./max(abs(rearout));
reference=OG./max(abs(rearout));

audiowrite('front_music.wav',frontoutn,fs)
audiowrite('rear_music.wav',rearoutn,fs)
audiowrite('ref_music.wav',reference,fs)

%%
% Plotting Section
fraxis=(0:1:length(OG)-1)*fs/length(OG);
taxis=[0:(1/fs):length(OG)/fs-(1/fs)];
l=length(OG);

% figure(1)
% plot(taxis,envelope(OG))
% hold on
% plot(taxis,envelope(costfiltered))
% plot(taxis,envelope(beamfiltered))
% plot(taxis,envelope(frontout))
% plot(taxis,envelope(rearout))
% plot(taxis,envelope(frontoutn))
% plot(taxis,envelope(rearoutn))
% plot(taxis,envelope(reference))
% legend('Original sweep','Cost filter','Cost + beam filter','Cost filter + BP','Cost + beam + BP','Front output','Rear output','Reference')
% xlabel('Time [s]')
% ylabel('Amplitude [1]')
% grid minor

figure(1)
plot(taxis,envelope(frontoutn))
hold on
plot(taxis,envelope(rearoutn))
plot(taxis,envelope(reference))
xlim([0 length(frontoutn)/fs])
ylim([0 1])
legend('Front output','Rear output','Reference sweep')
xlabel('Time [s]')
ylabel('Sweep Envelope [1]')
grid minor


figure(2)
semilogx(fraxis,20*log10(abs(fft(OG)/l)))
hold on
semilogx(fraxis,20*log10(abs(fft(costfiltered)/l)))
semilogx(fraxis,20*log10(abs(fft(beamfiltered)/l)))
semilogx(fraxis,20*log10(abs(fft(frontout)/l)))
semilogx(fraxis,20*log10(abs(fft(rearout)/l)))
semilogx(fraxis,20*log10(abs(fft(frontoutn)/l)))
semilogx(fraxis,20*log10(abs(fft(rearoutn)/l)))
semilogx(fraxis,20*log10(abs(fft(rearoutn)/l)))
xlim([20 2000])
grid minor
legend('Original sweep','Cost filter','Cost + beam filter','Cost filter + BP','Cost + beam + BP','Front output','Rear output','Reference')
xlabel('Frequency [Hz]')
ylabel('Level [dB]')

figure(3)
yyaxis left
plot(fraxis,20*log10(abs(fft(rearoutn)./fft(frontoutn))))
ylim([4.2 5.8])
xlabel('Frequency [Hz]')
ylabel('Gain [dB]')
yyaxis right
plot(fraxis,rad2deg(angle(fft(rearoutn)./fft(frontoutn))))
xlim([60 300])
ylabel('Phase [Deg]')

