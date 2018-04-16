

clear all
warning off

 load('G03.mat')


f=[60:10:300];
pgain=polyfit(f,10.^(master.reg.S_40_40.filterdata.ogpres./20),2);
pphase=polyfit(f,master.reg.S_40_40.filterdata.ogphase,1);

figure
yyaxis left
plot(f,master.reg.S_40_40.filterdata.ogpres,'o')
%ylabel('Gain [dB]')
%xlabel('Frequency [Hz]')
hold on
%plot(f,20*log10(polyval(pgain,f)))
yyaxis right
plot(f,rad2deg(master.reg.S_40_40.filterdata.ogphase),'o')
%plot(f,rad2deg(polyval(pphase,f)))
%ylabel('Phase Shift [Deg]')


phase_offset = -0.00;  % minus move the phase up.
population = 1000;
generation = 15000;
weight = 0;
rotate = -0;
add_gain = +0.00;
tap = 200;
phase = 38;

[solutions,population,the_cost] = fixed_gen(population,generation,phase_offset,weight,tap,phase);
ir = generate_ir(solutions,rotate,add_gain,tap,phase);

%ir = ir-ir(end);

[freqResp ,w] = freqz(ir,1,22050,44100);

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
  xlim([0 5000])
  figure
  plot(ir)
  
save('filter_parameter.mat','solutions')
