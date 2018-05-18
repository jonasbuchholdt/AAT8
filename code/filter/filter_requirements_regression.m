clear variables
close all
load('flipsol_08.mat')


f=flip([fbot:fres:ftop]);

for h=1:length(f)
    amplitude1(h)=20*log10((solutions.(strcat('f',int2str(f(h)))).Va)/(solutions.(strcat('f',int2str(f(h)))).Vb));
    phase1(h)=-(solutions.(strcat('f',int2str(f(h)))).Phib);
    if phase1(h)<0
        phase1(h)=phase1(h)+2*pi;
    end
end

pgain=polyfit(f,10.^(amplitude1./20),2);
pphase=polyfit(f,phase1,2);

figure
yyaxis left
plot(f,amplitude1,'o')
ylabel('Gain [dB]')
xlabel('Frequency [Hz]')
hold on
plot(f,20*log10(polyval(pgain,f)))
% plot(f,amplitude2)
% plot(f,amplitude3)
yyaxis right
plot(f,rad2deg(phase1),'o')
plot(f,rad2deg(polyval(pphase,f)))
ylabel('Phase Shift [Deg]')
% plot(f,rad2deg(phase2))
% plot(f,rad2deg(phase3))

for h=1:length(f)
    solutions.(strcat('f',int2str(f(h)))).Vb =0.01;
    solutions.(strcat('f',int2str(f(h)))).Vc =0.01;
    solutions.(strcat('f',int2str(f(h)))).Va =0.01*polyval(pgain,f(h));
    solutions.(strcat('f',int2str(f(h)))).Phib =0;
    solutions.(strcat('f',int2str(f(h)))).Phic =0;
    solutions.(strcat('f',int2str(f(h)))).Phia=polyval(pphase,f(h));
end

figure

fr = ([300:-1:60]);
gain = flip(polyval(pgain,fr));
phase = flip(polyval(pphase,fr));
fr = flip(fr);
plot(fr,gain)
hold on
plot(fr,phase)

%%
%gain = flip(polyval(pgain,f));
%phase = flip(polyval(pphase,f));
input = ones(1,length(fr));
output = gain;
Ts = 44100;                                            % Sampling Interval (1/Sampling Frequency)
data = iddata(output, input, Ts);
Poles = 2;                                           % Use Appropriate Numbers For Your System
Zeros = 0;                                           % Use Appropriate Numbers For Your System
sys = tfest(data, Poles, Zeros);


save('regressed_04.mat','solutions','fbot','fres','ftop','speakerangle')