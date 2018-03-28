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
function [childa,childb]=offspring(population,n,parent1,parent2)
infl_factor=0.1+0.8*rand();                 % factor that biases influence of one parent
childa=struct;
childb=struct;
childa.Lx=infl_factor*population.(strcat('gene',int2str(parent1))).Lx +(1-infl_factor)*population.(strcat('gene',int2str(parent2))).Lx;
childa.Ly=infl_factor*population.(strcat('gene',int2str(parent1))).Ly +(1-infl_factor)*population.(strcat('gene',int2str(parent2))).Ly;
childb.Lx=infl_factor*population.(strcat('gene',int2str(parent2))).Lx +(1-infl_factor)*population.(strcat('gene',int2str(parent1))).Lx;
childb.Ly=infl_factor*population.(strcat('gene',int2str(parent2))).Ly +(1-infl_factor)*population.(strcat('gene',int2str(parent1))).Ly;
infl_factor=0.1+0.8*rand();
childa.Va=infl_factor*population.(strcat('gene',int2str(parent1))).Va +(1-infl_factor)*population.(strcat('gene',int2str(parent2))).Va +0.001*randn();
childa.Vb=infl_factor*population.(strcat('gene',int2str(parent1))).Vb +(1-infl_factor)*population.(strcat('gene',int2str(parent2))).Vb +0.001*randn();
childa.Vc=childa.Vb;
childb.Va=infl_factor*population.(strcat('gene',int2str(parent2))).Va +(1-infl_factor)*population.(strcat('gene',int2str(parent1))).Va +0.001*randn();
childb.Vb=infl_factor*population.(strcat('gene',int2str(parent2))).Vb +(1-infl_factor)*population.(strcat('gene',int2str(parent1))).Vb +0.001*randn();
childb.Vc=childb.Vb;
infl_factor=0.1+0.8*rand();
childa.Phia=infl_factor*population.(strcat('gene',int2str(parent1))).Phia +(1-infl_factor)*population.(strcat('gene',int2str(parent2))).Phia;
childa.Phib=infl_factor*population.(strcat('gene',int2str(parent1))).Phib +(1-infl_factor)*population.(strcat('gene',int2str(parent2))).Phib +0.02*randn();
childa.Phic=childa.Phib;
childb.Phia=infl_factor*population.(strcat('gene',int2str(parent2))).Phia +(1-infl_factor)*population.(strcat('gene',int2str(parent1))).Phia;
childb.Phib=infl_factor*population.(strcat('gene',int2str(parent2))).Phib +(1-infl_factor)*population.(strcat('gene',int2str(parent1))).Phib +0.02*randn();
childb.Phic=childb.Phib;
childa.age=0;
childa.mut=rand();
childa.sur=rand();
childb.age=0;
childb.mut=rand();
childb.sur=rand();
end