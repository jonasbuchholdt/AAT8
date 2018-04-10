% analytical beamforming
% generation step
% CK 18-03-20
%
% %%% IN  %%%
% population: current population                                   [struct]
% n: number of individuals in population                              [int]
% fit: fitness of current population                               [vector]
% surquote: survivor quote for fittest individuals                  [float]
% replacement: overall quote of individuals that are replaced       [float]
% t_level: tournament level for parent selection                      [int]
% pmut: probability of mutation occuring                            [float]
%
% %%% OUT %%%
% population: updated population                                   [struct]      
% ------------------------------------------------------------------------
function [population]= gen_step(population,n,fit,surquote,replacement,tlevel,pmut)

m=ceil(n*replacement/2);                %number of parent pairs

pop_new=population;

for g=1:n
    pop_new.(strcat('gene',int2str(g))).age= pop_new.(strcat('gene',int2str(g))).age+1;
    pop_new.(strcat('gene',int2str(g))).sur=rand();
end


parents=par_choose(population,n,fit,m,tlevel);

[~,fitsort]=sort(fit);



for k=1:(ceil(n*surquote))
    population.(strcat('gene',int2str(fitsort(k)))).sur= 1000-fit(fitsort(k));
end

sur=[];
for h=1:n
    sur(h)=population.(strcat('gene',int2str(h))).sur;
end

[~,sursort]=sort(sur);

for l=1:m
    [childa,childb]=offspring(population,n,parents(m,1),parents(m,2));
    pop_new.(strcat('gene',int2str(sursort(2*l-1))))=childa;
    pop_new.(strcat('gene',int2str(sursort(2*l))))=childb;
end
%population=pop_new;
population=mutator(pop_new,n,pmut);
end