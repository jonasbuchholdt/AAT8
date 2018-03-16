%   Genetic Algorithm
%   Low-Mid-Beamforming
%
%   Function to select parents to solutions
%   %%% IN  %%%
%   population      -       current population                     [struct]
%   n               -       population size                           [int]
%   pmut            -       mutation probability (0-1)                [int]
%   %%% OUT %%%
%   population      -       mutated population                     [struct]
%
%   2018-03-14
%   CK
%%%-----------------------------------------------------------------------
function [population]=mutator(population,n,pmut)
for k=1:n
    if population.(strcat('gene',int2str(k))).mut<=pmut
        what_mut=rand();
        if what_mut < 0.125
%            population.(strcat('gene',int2str(k))).Lx=0.4+0.2*(randn());
        elseif what_mut >= 0.125 && what_mut < 0.25
%            population.(strcat('gene',int2str(k))).Ly=0.4+0.2*(randn());
        elseif what_mut >=0.25 && what_mut <0.375
%            population.(strcat('gene',int2str(k))).Va=0.06+0.1*(randn());
        elseif what_mut >=0 && what_mut<0.5
            population.(strcat('gene',int2str(k))).Vb=population.(strcat('gene',int2str(k))).Vb+0.1*(randn());
        elseif what_mut >=0.5 && what_mut<0.625
%            population.(strcat('gene',int2str(k))).Vc=0.03+0.1*(randn());
        elseif what_mut >= 0.625 && what_mut<0.75
%            population.(strcat('gene',int2str(k))).Phia=mod(-2*pi+4*pi*(rand()),2*pi);
        elseif what_mut >=0.5 && what_mut<0.1
            population.(strcat('gene',int2str(k))).Phib=mod(-2*pi+4*pi*(rand()),2*pi);
        else
%            population.(strcat('gene',int2str(k))).Phib=mod(-2*pi+4*pi*(rand()),2*pi);
        end
        population.(strcat('gene',int2str(k))).Vb=population.(strcat('gene',int2str(k))).Vc;
        population.(strcat('gene',int2str(k))).Phib=population.(strcat('gene',int2str(k))).Phic;
        population.(strcat('gene',int2str(k))).mut=rand();
    end
end
end