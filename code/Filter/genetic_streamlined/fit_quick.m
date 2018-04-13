% analytical beamforming fitnes function
% based on point sources
% cost are weighted based on the desired emission characteristic
% CK 18-03-20
%
% %%% IN  %%%
% population: population that should be evaluated                  [struct]
% n: number of individuals in population                              [int]
% f: frequency that should be optimized                               [int]
% polylf: cost shaping parameter for low frequencies                  [int]
% polyhf: cost shaping parameter for high frequencies                 [int]
% sourcepar: parameter set for increased performance               [struct]
% 
% %%% OUT %%%
% cost: fitness of each individual, lower values are  better!      [vector]      
% ------------------------------------------------------------------------
function [cost]=fit_quick(population,n,weight_input,M)

% calculating the fitness of the filter 



for k=1:n
%%

wanted_amplitude_respond = population.(strcat('gene',int2str(k))).gain';
wanted_phase_respond = population.(strcat('gene',int2str(k))).phase';
  %% 
  
 irEstimate = population.(strcat('gene',int2str(k))).ir_estimate;
 %ir_flip = flip(ir_non_flip);
 %ir =  [ir_flip  flip(ir_flip)];
 %ir_shift = circshift(ir ,-(M/2-2));
 
 irEstimate = irEstimate-irEstimate(end);
 population.(strcat('gene',int2str(k))).ir_estimate= irEstimate;
   irEstimate = [irEstimate flip(irEstimate)];
   irEstimate = circshift(irEstimate ,30);
   irEstimate = irEstimate(1:end/2);


 [freqResp ,w] = freqz(irEstimate,1,20000,40000);

% the actual transfer function
actual_phase_respond = angle(freqResp);
actual_amplitude_respond = (abs(freqResp));
%%
% the phase cost

%step = [1:1:2000];
%weight = (5*cos(2*pi*step/step(end)+(pi+2.2)/1)+1+weight_input)';
%weight = weight(1:1000);

fitness_phase(k) = abs(sum((actual_phase_respond(1:1000)-wanted_phase_respond(1:1000))));

% the amplitude cost
fitness_gain(k) = abs(sum((actual_amplitude_respond(1:1000)-wanted_amplitude_respond(1:1000))));%.*weight));

% the phase and amplitude cost
cost(k)=fitness_gain(k)+fitness_phase(k); 

%%
end
end