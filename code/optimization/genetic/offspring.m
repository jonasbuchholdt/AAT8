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
%   childb          -       offspring variant b (inverse proprtion)[struct]
%
%   2018-03-09
%   CK
%%%-----------------------------------------------------------------------
function [childa,childb]=offspring(population,n,parent1,parent2)
infl_factor=0.25+0.5*rand();                 % factor that biases influence of one parent
childa=struct;
childb=struct;
childa.Lx=infl_factor*population.(strcat('Lx',int2str(parent1)))+(1-infl_factor)*population.(strcat('Lx',int2str(parent2)));
childa.Ly=infl_factor*population.(strcat('Ly',int2str(parent1)))+(1-infl_factor)*population.(strcat('Ly',int2str(parent2)));
childb.Lx=infl_factor*population.(strcat('Lx',int2str(parent2)))+(1-infl_factor)*population.(strcat('Lx',int2str(parent1)));
childb.Ly=infl_factor*population.(strcat('Ly',int2str(parent2)))+(1-infl_factor)*population.(strcat('Ly',int2str(parent1)));
infl_factor=0.25+0.5*rand();
childa.Va=infl_factor*population.(strcat('Va',int2str(parent1)))+(1-infl_factor)*population.(strcat('Va',int2str(parent2)));
childa.Vb=infl_factor*population.(strcat('Vb',int2str(parent1)))+(1-infl_factor)*population.(strcat('Vb',int2str(parent2)));
childa.Vc=infl_factor*population.(strcat('Vc',int2str(parent1)))+(1-infl_factor)*population.(strcat('Vc',int2str(parent2)));
childb.Va=infl_factor*population.(strcat('Va',int2str(parent2)))+(1-infl_factor)*population.(strcat('Va',int2str(parent1)));
childb.Vb=infl_factor*population.(strcat('Vb',int2str(parent2)))+(1-infl_factor)*population.(strcat('Vb',int2str(parent1)));
childb.Vc=infl_factor*population.(strcat('Vc',int2str(parent2)))+(1-infl_factor)*population.(strcat('Vc',int2str(parent1)));
infl_factor=0.25+0.5*rand();
childa.Phia=infl_factor*population.(strcat('Phia',int2str(parent1)))+(1-infl_factor)*population.(strcat('Phia',int2str(parent2)));
childa.Phib=infl_factor*population.(strcat('Phib',int2str(parent1)))+(1-infl_factor)*population.(strcat('Phib',int2str(parent2)));
childa.Phic=infl_factor*population.(strcat('Phic',int2str(parent1)))+(1-infl_factor)*population.(strcat('Phic',int2str(parent2)));
childb.Phia=infl_factor*population.(strcat('Phia',int2str(parent2)))+(1-infl_factor)*population.(strcat('Phia',int2str(parent1)));
childb.Phib=infl_factor*population.(strcat('Phib',int2str(parent2)))+(1-infl_factor)*population.(strcat('Phib',int2str(parent1)));
childb.Phic=infl_factor*population.(strcat('Phic',int2str(parent2)))+(1-infl_factor)*population.(strcat('Phic',int2str(parent1)));
childa.age=0;
childa.mut=rand();
end