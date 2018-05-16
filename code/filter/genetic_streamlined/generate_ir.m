function  [irEstimate]= generate_ir(solutions,rotate,add_gain,M,phase)
%%
irEstimate = solutions.f1.ir_estimate;
   irEstimate = [irEstimate flip(irEstimate)];
   irEstimate = circshift(irEstimate ,phase);
   irEstimate = irEstimate(1:end/2+20);

% x = [1:1:M];
% xq = [1:0.01:M];
% vq = interp1(x,irEstimate,xq);
% vq = circshift(vq ,rotate);
% irEstimate = downsample(vq,100);



