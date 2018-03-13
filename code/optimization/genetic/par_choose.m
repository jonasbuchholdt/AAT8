%   Genetic Algorithm
%   Low-Mid-Beamforming
%
%   Function to select parents to solutions
%   %%% IN  %%%
%   population      -       current population                     [struct]
%   n               -       population size                           [int]
%   fit             -       fitness of the population              [vector]
%   m               -       number of pairs that are to be chosen     [int]
%   tlevel          -       level of tournament matches,              [int]
%                           lower levels increase randomization,
%                           higher levels increase selection pressure
%   %%% OUT %%%
%   parents         -       parent pairs, each row is one pair     [matrix]
%
%   2018-03-13
%   CK
%%%-----------------------------------------------------------------------


function [parents]=par_choose(population,n,fit,m,tlevel)

    pop_index=1:n;

    parents=[];

    for k=1:m
        ppool=randsample(pop_index,2^(tlevel+1));           % picking contenders
    
        for l=1:tlevel
    
            fitpool=fit(ppool);                                 % selecting the fitness of the contenders

            fitpoolshift=[fitpool(2:end) fitpool(1)];           % shifting fitness to the left

            fitcompare=(fitpool-fitpoolshift)<0;                % determining whether the left entry of a pair of contenders has a lower (=better) fitness value the right one

            compareshort=fitcompare(1:2:end);                   % throwing away the results of matches between non-paired contenders

            indexhelp=[2:2:2*length(compareshort)];             % precursor to what indexes out ppool win

            select=indexhelp-compareshort;                      % determining winners' indices

            ppool=ppool(select);                                % setting up contenders for next round
    
        end
    
        parents(k,:)=ppool;

        if any(ppool(1)==parents(:,1)) && any(ppool(2)==parents(:,2))
            k=k-1;
        end
    end

end