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
function [population]=pop_init_fix(n,Lx,Ly)
population=struct;
for k=1:n
    ind=struct;
    ind.Lx=Lx;
    ind.Ly=Ly;
    ind.Va=abs(0.1*(randn()));
    ind.Vb=abs(0.05*(randn()));
    ind.Vc=ind.Vb;
    ind.Phia=0;
    ind.Phib=-2*pi+(rand()*4*pi);
    ind.Phic=ind.Phib;
    ind.age=0;
    ind.mut=rand();
    ind.sur=rand();
    population.(strcat('gene',int2str(k)))=ind;
    clear ind
end
end