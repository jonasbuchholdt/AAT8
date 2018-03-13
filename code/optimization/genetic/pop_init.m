%   Genetic Algorithm
%   Low-Mid-Beamforming
%
%   Function to initialize population
%   %%% IN  %%%
%   n               -       population size                           [int]
%   %%% OUT %%%
%   population      -       initial population                     [struct]
%
%   2018-03-09
%   CK
%%%-----------------------------------------------------------------------
function [population]=pop_init(n)
population=struct;
for k=1:n
    ind.Lx=0.7+0.1*(randn());
    ind.Ly=0.7+0.1*(randn());
    ind.Va=0.05+0.1*(randn());
    ind.Vb=0.025+0.01*(randn());
    ind.Vc=0.025+0.01*(randn());
    ind.Phia=mod(2*pi*(randn()),2*pi);
    ind.Phib=mod(2*pi*(randn()),2*pi);
    ind.Phic=mod(2*pi*(randn()),2*pi);
    ind.age=0;
    ind.mut=rand();
    population.(strcat('gene',int2str(k)))=ind;
end
end