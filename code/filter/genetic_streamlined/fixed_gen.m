function [solutions,population,the_cost]=fixed_gen(n,N,phase,weight,M,phase_off)



surquote=0.05;                          % elite survivor quote
replacement=0.6;                        % replacement by children
pmut=0.4;                               % probability of mutation
tlevel=3;                               % tournament level for parent selection

solutions=struct;                       % initializing solution struct


%population=pop_init(n);   % generating initial population
%%
population=pop_init_fix(n,phase,M);
%%


f=1;
% calculating solutions for the rest of the frequency range with an initial
% popul0ation that always is the final population of the preceeding
% frequency

%    tic
for l=1:N
    fit=fit_quick(population,n,weight,M,phase_off);
    the_cost(N) = abs(min(fit));
    fprintf('%d Generation.\n',l);
    fprintf('%d the fit.\n',abs(min(fit)));    
    population=gen_step(population,n,fit,surquote,replacement,tlevel,pmut,M);
end
    [~,fitsort]=sort(fit);
    solutions.(strcat('f',int2str(f(1))))= population.(strcat('gene',int2str(fitsort(1))));
    %display(strcat('f=',int2str(f(h)),'Hz, computed in ',int2str(toc),' s'))

end