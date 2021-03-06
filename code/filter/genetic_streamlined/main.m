

clear all
warning off

 load('G03.mat')


f=[60:10:300];
pgain=polyfit(f,10.^(master.reg.S_40_40.filterdata.ogpres./20),2);
pphase=polyfit(f,master.reg.S_40_40.filterdata.ogphase,1);





phase_offset = -0.00;  % minus move the phase up.
population = 1000;
generation = 7000;
weight = 0;
rotate = -0;
add_gain = +0.00;
tap = 200;
phase = 38;

%[solutions,population,the_cost] = fixed_gen(population,generation,phase_offset,weight,tap,phase);

load('filter_parameter.mat')
ir = generate_ir(solutions,rotate,add_gain,tap,phase);

%ir = ir-ir(end);

[freqResp ,w] = freqz(ir,1,22050,44100);

% the actual transfer function
 actual_phase_respond = angle(freqResp);
 actual_amplitude_respond = (abs(freqResp));




 figure
 yyaxis left
 plot(f,master.reg.S_40_40.filterdata.ogpres,'o')
 hold on
 yyaxis right
 plot(f,rad2deg(master.reg.S_40_40.filterdata.ogphase),'o')
 yyaxis left
 plot(w,20*log10(solutions.f1.gain*solutions.f1.filter_gain),'--')
 %plot(w,20*log10(polyval(pgain,w)),'--')
 hold on
 plot(w,20*log10(actual_amplitude_respond*solutions.f1.filter_gain))
 yyaxis right
 plot(w,rad2deg(solutions.f1.phase),'--')
 plot(w,rad2deg(actual_phase_respond))
 ylabel('Phase Shift [Deg]')
 %xlim([60 300])
 ylim([-600 200]) 
 %ylim([80 170]) 
 yyaxis left
 ylabel('Gain [dB]')
 xlabel('Frequency [Hz]')
 legend('Optimal Gain','Gain, 2nd order regression','Optimized FIR Gain','Optimal phase','Phase, linear regression','Optimized FIR phase')
 %ylabel('Phase Shift [Deg]')
 xlim([20 2500])
   
  set(gca,'FontSize', 12);
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
fig.PaperPositionMode   = 'auto';
%   figure
%   semilogx(w,actual_amplitude_respond)
%   hold on
%   semilogx(w,actual_phase_respond)
%   semilogx(w,solutions.f1.gain,'b--')
%   semilogx(w,solutions.f1.phase,'r--')
%   xlim([20 20000])
%   ylim([-8 8])
x = [1:1:length(ir)]
x = x/44100;
   figure
   plot(x,ir)
   set(gca,'XGrid','on','YGrid','on'); 
 ylabel('Impulse response [1]')
 xlabel('Second [s]')   
   set(gca,'FontSize', 12);
set(gca,'LooseInset', max(get(gca,'TightInset'), 0.02))
fig.PaperPositionMode   = 'auto';
%%save('filter_parameter.mat','solutions')


%% save to kirsch

% for k=60:10:300
% filter.gain((k/10)-6+1)  =  actual_amplitude_respond(k)*solutions.f1.filter_gain
% filter.phase((k/10)-6+1) =  actual_phase_respond(k)
% end

f = [60:10:300]
figure
 yyaxis left
 plot(w,20*log10(solutions.f1.gain*solutions.f1.filter_gain),'--')
 hold on
 ylabel('Gain [dB]')
 xlabel('Frequency [Hz]')
 %plot(f,20*log10(filter.gain/1.002))
 yyaxis right
 plot(w,rad2deg(solutions.f1.phase),'--')
 %plot(f,rad2deg(filter.phase))
 ylabel('Phase Shift [Deg]')
 xlim([60 300])


