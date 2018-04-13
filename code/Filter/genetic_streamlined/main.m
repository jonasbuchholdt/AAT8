

clear all
warning off

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
%ylabel('Gain [dB]')
%xlabel('Frequency [Hz]')
hold on
%plot(f,20*log10(polyval(pgain,f)))
yyaxis right
plot(f,rad2deg(phase1),'o')
%plot(f,rad2deg(polyval(pphase,f)))
%ylabel('Phase Shift [Deg]')


phase_offset = -0.1;  % minus move the phase 
population = 500;
generation = 1000;
weight = 0;
rotate = -0;
add_gain = +0.00;
tap = 160;

[solutions,population,the_cost] = fixed_gen(population,generation,phase_offset,weight,tap);
%%
ir = generate_ir(solutions,rotate,add_gain,tap);

ir = ir-ir(end);

[freqResp ,w] = freqz(ir,1,20000,40000);

% the actual transfer function
 actual_phase_respond = angle(freqResp);
 actual_amplitude_respond = (abs(freqResp));





 yyaxis left
 plot(w,20*log10(solutions.f1.gain*solutions.f1.filter_gain),'--')
 hold on
 ylabel('Gain [dB]')
 xlabel('Frequency [Hz]')
 plot(w,20*log10(actual_amplitude_respond*solutions.f1.filter_gain))
 yyaxis right
 plot(w,rad2deg(solutions.f1.phase),'--')
 plot(w,rad2deg(actual_phase_respond))
 ylabel('Phase Shift [Deg]')
 xlim([20 400])

 
  figure
  semilogx(w,actual_amplitude_respond)
  hold on
  semilogx(w,actual_phase_respond)
  semilogx(w,solutions.f1.gain,'b--')
  semilogx(w,solutions.f1.phase,'r--')
  xlim([0 2000])
  figure
  plot(ir)
%%
figure
semilogx(w,actual_amplitude_respond*solutions.f1.filter_gain)
hold on
semilogx(w,actual_phase_respond)
semilogx(w,solutions.f1.gain*solutions.f1.filter_gain,'b--')
semilogx(w,solutions.f1.phase,'r--')
xlim([40 400])

%%

 ir_non_flip = solutions.f1.ir_estimate;
 ir_flip = flip(ir_non_flip);
 ir =  [ir_flip  flip(ir_flip)];
 
 
x = [1:1:M]
xq = [1:0.01:M]


vq = interp1(x,ir,xq)
%vq = [ vq(2:end)  vq(end) ];
%vq = [ vq(1) vq(1:end-1) ];
vq = circshift(vq ,-0);
vq = downsample(vq,100)

 
figure
plot(vq)
hold on
plot(ir)


ir_shift = circshift(vq ,-(20/2-2));

ir_shift = ir_shift(1:10)

[freqResp ,w] = freqz(ir_shift,1,1000,2000);

% the actual transfer function
actual_phase_respond = angle(freqResp);
actual_amplitude_respond = (abs(freqResp));
figure
semilogx(w,actual_amplitude_respond)
hold on
semilogx(w,actual_phase_respond)
semilogx(w,solutions.f1.gain,'b--')
semilogx(w,solutions.f1.phase,'r--')


figure
semilogx(w,actual_amplitude_respond)
hold on
semilogx(w,actual_phase_respond)
semilogx(w,solutions.f1.gain,'b--')
semilogx(w,solutions.f1.phase,'r--')
xlim([40 400])


