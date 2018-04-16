function  [irEstimate,back_filter_gain,back_filter_phase,gain_for_filter] = ir_est(phase,M)

%%
load('G03.mat')
% f=flip([fbot:fres:ftop]);
% 
% for h=1:length(f)
%     amplitude1(h)=20*log10((solutions.(strcat('f',int2str(f(h)))).Va)/(solutions.(strcat('f',int2str(f(h)))).Vb));
%     phase1(h)=-(solutions.(strcat('f',int2str(f(h)))).Phib);
%     if phase1(h)<0
%         phase1(h)=phase1(h)+2*pi;
%     end
% end




% flip such that the frequency starts at 0 Hz. 

amplitude1 = master.reg.S_40_40.filterdata.ogpres;
phase1 = master.reg.S_40_40.filterdata.ogphase;


f=[60:10:300]

% Polynomia for estimate the gaine and phase of the filter.
p_gain             = polyfit(f,amplitude1,2);
p_phase            = polyfit(f,phase1,1);
%---------------------------------------

scale = 1;

fr=[1:1:1000*scale];

%fr = fr(1:end-1);

phase = 0.0;
M=200;

back_filter_gain  = (10.^(polyval(p_gain,fr)./20));%-20*log10(polyval(p_gain,0));
back_filter_phase = (polyval(p_phase,fr))+phase;

gain_for_filter=back_filter_gain(1);


% the estimate-------------------
ft = [1:1:22050];
back_filter_gain_tyve = [back_filter_gain zeros(1,19000+2050)];
p_gain_t   = polyfit(ft,back_filter_gain_tyve,50);
back_filter_phase = (polyval(p_phase,ft))+phase;
%semilogx(back_filter_gain)
%semilogx(back_filter_phase)
back_filter_gain = polyval(p_gain_t,ft);
back_filter_gain_test = back_filter_gain;
back_filter_gain = back_filter_gain./back_filter_gain(1);
%semilogx(back_filter_gain)
% hold on
% ------------------------


back_filter_gain = back_filter_gain;   %/back_filter_gain(1);
%semilogx(back_filter_gain)


regtangular_form = back_filter_gain.*cos(back_filter_phase)+i.*back_filter_gain.*sin(back_filter_phase);


%     figure
%    semilogx(abs(regtangular_form))
%    hold on
%     semilogx(back_filter_gain)



irEstimate = real(ifft(regtangular_form*0.75));
%irEstimate = impulseest(data)
%hold on
irEstimate = irEstimate(1:M);
irEstimate = circshift(irEstimate ,-19);
irEstimate = irEstimate(1:M/2);
%irEstimate = flip(irEstimate);
% figure
%  plot(irEstimate)
%  hold on
%fvtool(irEstimate,1)
%figure
%   irEstimate = flip(irEstimate);



   
       x = [1:1:M/2];
       xq = [1:0.2:M/2];           
       vq = interp1(x,irEstimate,xq);
       vq = [ vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1)  vq(1:end-75)];
       irEstimate = downsample(vq,5);            

x = [1:length(irEstimate)]
x = x./44100;      

       
       
       figure
 plot(x,irEstimate)
  ylabel('Impulse response [1]')
 xlabel('Second [s]')
 
 
 
    irEstimate = [irEstimate flip(irEstimate)];
    irEstimate = circshift(irEstimate ,38);
    irEstimate = irEstimate(1:end/2+20);
    [freqResp ,w] = freqz(irEstimate,1,22050,44100);
phasees = angle(freqResp);
    tf = (abs(freqResp));

    
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
    
  yyaxis left
 plot(w,20*log10(back_filter_gain*back_filter_gain_test(1)),'b--')
 hold on
 ylabel('Gain [dB]')
 xlabel('Frequency [Hz]')
 plot(w,20*log10(tf*back_filter_gain_test(1)),'b')
 yyaxis right
 plot(w,rad2deg(back_filter_phase),'r--')
 plot(w,rad2deg(phasees),'r')
 ylabel('Phase Shift [Deg]')
 xlim([60 300])   
    
    
%     figure  
%      semilogx(w,tf)
%      hold on
%     semilogx(w,phasees)

x = [1:length(irEstimate)]
x = x./44100;  

     figure
     plot(x,irEstimate)
       ylabel('Impulse response [1]')
 xlabel('Second [s]')
