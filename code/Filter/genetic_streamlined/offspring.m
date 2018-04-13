%   Genetic Algorithm
%   Low-Mid-Beamforming
%
%   Function to mate to solutions
%   %%% IN  %%%
%   population      -       current population                     [struct]
%   n               -       population size                           [int]
%   parent1         -       index of solution to be mated             [int]
%   parent2         -       index of solution to be mated             [int]
%   %%% OUT %%%
%   childa          -       offspring variant a                    [struct]
%   childb          -       offspring variant b(inverse proportion)[struct]
%
%   2018-03-09
%   CK
%%%-----------------------------------------------------------------------
function [childa,childb]=offspring(population,n,parent1,parent2,M)               
childa=struct;
childb=struct;
infl_factor=0.1*rand(); % factor that biases influence of one parent
infl_add=0.002*rand();
%childa.ir_estimate = infl_factor*population.(strcat('gene',int2str(parent1))).ir_estimate-infl_add + (1-infl_factor)*population.(strcat('gene',int2str(parent2))).ir_estimate +0.0002*randn();
%childb.ir_estimate = infl_factor*population.(strcat('gene',int2str(parent2))).ir_estimate-infl_add + (1-infl_factor)*population.(strcat('gene',int2str(parent1))).ir_estimate +0.0002*randn();
cross_point = ceil(M/2*rand());
childa.ir_estimate = [ population.(strcat('gene',int2str(parent2))).ir_estimate(1:cross_point) population.(strcat('gene',int2str(parent1))).ir_estimate(cross_point+1:end) ];
cross_point = ceil(M/2*rand());
childb.ir_estimate = [ population.(strcat('gene',int2str(parent1))).ir_estimate(1:cross_point) population.(strcat('gene',int2str(parent2))).ir_estimate(cross_point+1:end) ];
childa.gain = population.(strcat('gene',int2str(parent1))).gain;
childa.phase = population.(strcat('gene',int2str(parent1))).phase;
childb.gain = population.(strcat('gene',int2str(parent1))).gain;
childb.phase = population.(strcat('gene',int2str(parent1))).phase;
childa.ir_orig = population.(strcat('gene',int2str(parent1))).ir_orig;
childb.ir_orig = population.(strcat('gene',int2str(parent1))).ir_orig;
childa.filter_gain = population.(strcat('gene',int2str(parent1))).filter_gain;
childb.filter_gain = population.(strcat('gene',int2str(parent1))).filter_gain;
childa.age=0;
childa.mut=rand();
childa.sur=rand();
childb.age=0;
childb.mut=rand();
childb.sur=rand();
end