function  [irEstimate,back_filter_gain,back_filter_phase,gain_for_filter] = ir_est(phase,M)

%%
load('flipsol_08.mat')
f=flip([fbot:fres:ftop]);

for h=1:length(f)
    amplitude1(h)=20*log10((solutions.(strcat('f',int2str(f(h)))).Va)/(solutions.(strcat('f',int2str(f(h)))).Vb));
    phase1(h)=-(solutions.(strcat('f',int2str(f(h)))).Phib);
    if phase1(h)<0
        phase1(h)=phase1(h)+2*pi;
    end
end




% flip such that the frequency starts at 0 Hz. 
f=flip(f);
amplitude1 = flip(amplitude1);
phase1 = flip(phase1);


% Polynomia for estimate the gaine and phase of the filter.
p_gain             = polyfit(f,amplitude1,2);
p_phase            = polyfit(f,phase1,1);
%---------------------------------------

scale = 1;

fr=[1:1:1000*scale];

%fr = fr(1:end-1);

phase = -0.1;
M=160;

back_filter_gain  = (10.^(polyval(p_gain,fr)./20));%-20*log10(polyval(p_gain,0));
back_filter_phase = (polyval(p_phase,fr))+phase;

gain_for_filter=back_filter_gain(1);


% the estimate-------------------
ft = [1:1:20000];
back_filter_gain_tyve = [back_filter_gain zeros(1,19000)];
p_gain_t   = polyfit(ft,back_filter_gain_tyve,50);
back_filter_phase = (polyval(p_phase,ft))+phase;
%semilogx(back_filter_gain)
%semilogx(back_filter_phase)
back_filter_gain = polyval(p_gain_t,ft);
back_filter_gain = back_filter_gain./back_filter_gain(1);
% semilogx(back_filter_gain)
% hold on
% ------------------------


back_filter_gain = back_filter_gain;   %/back_filter_gain(1);
%semilogx(back_filter_gain)


regtangular_form = back_filter_gain.*cos(back_filter_phase)+i.*back_filter_gain.*sin(back_filter_phase);


%     figure
%    semilogx(abs(regtangular_form))
%    hold on
%     semilogx(back_filter_gain)



irEstimate = real(ifft(regtangular_form*1.3));
%irEstimate = impulseest(data)
%hold on
irEstimate = irEstimate(1:M);
irEstimate = circshift(irEstimate ,-16);
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
       vq = [ vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1) vq(1:end-70)];
       irEstimate = downsample(vq,5);            
% figure
%  plot(irEstimate)
%     irEstimate = [irEstimate flip(irEstimate)];
%     irEstimate = circshift(irEstimate ,20);
%     irEstimate = irEstimate(1:end/2);
%     [freqResp ,w] = freqz(irEstimate,1,20000,40000);
%    phasees = angle(freqResp);
%     tf = (abs(freqResp));
%   figure  
%      semilogx(w,tf)
%      hold on
%     semilogx(w,phasees)
%     figure
%     plot((irEstimate))
