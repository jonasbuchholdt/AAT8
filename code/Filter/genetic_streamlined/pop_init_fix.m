%   Genetic Algorithm
%   Low-Mid-Beamforming
%
%   Function to initialize population
%   %%% IN  %%%
%   n               -       population size                           [int]
%   Lx              -       Speaker Triangle Width                  [float]
%   Ly              -       Speaker Triangle Height                 [float]
%
%   %%% OUT %%%
%   population      -       initial population                     [struct]
%
%   2018-03-09
%   CK
%%%-----------------------------------------------------------------------
function [population]=pop_init_fix(n,phase_in,M)
population=struct;
[ir_estimate,gain,phase,filter_gain] = ir_est(phase_in,M);

for k=1:n
    ind=struct;
    ind.ir_estimate = ir_estimate;
    ind.gain = gain;
    ind.phase = phase;
    ind.filter_gain = filter_gain;
    ind.ir_orig = ind.ir_estimate;
    ind.M = 30;
    ind.age=0;
    ind.mut=rand();
    ind.sur=rand();
    population.(strcat('gene',int2str(k)))=ind;
    clear ind
end
end