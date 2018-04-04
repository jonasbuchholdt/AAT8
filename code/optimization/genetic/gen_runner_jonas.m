clear variables
ftop=300;                               % upper frequency border for which parameters should be found
fres=10;                                % frequency resolution of the solution
fbot=60;                                % lower frequency border
f=flip([fbot:fres:ftop]);

load('cor_table_ones.mat')              % path for correction table
polylf=5;                               % cost adjustment parameter for low frequencies
polyhf=1;                               % cost adjustment parameter for high frequencies

n=1250;                                 % population size
surquote=0.05;                          % elite survivor quote
replacement=0.6;                        % replacement by children
pmut=0.1;                               % probability of mutation
tlevel=4;                               % tournament level for parent selection

Nstart=50;                              % number of generations for highest frequency
Nrest=10;                               % number of generations for other frequencies

solutions=struct;                       % initializing solution struct


population=pop_init(n);                 % generating initial population
% FOR FIXED POSITION OUTCOMMENT UPPER ONE
Lx=0.4;
Ly=0.25;
%population=pop_init_fix(n,Lx,Ly);



% running optimization for highest frequency
for k=1:Nstart
    tic;
    fit=fitness_pcor(population,n,ftop,polylf,polyhf,phi_mat,f_mat,p_mat);
    population=gen_step(population,n,fit,surquote,replacement,tlevel,pmut);
    display(strcat('f=',int2str(ftop),'Hz, ',int2str(k), ' gen. comp. in ', int2str(toc),' s'))
end

[~,fitsort]=sort(fit);



% storing fittest solution
solutions.(strcat('f',int2str(ftop)))= population.(strcat('gene',int2str(fitsort(1))));
solutions.f300.Lx=round(solutions.f300.Lx/0.1)*0.1;
solutions.f300.Ly=round(solutions.f300.Ly/0.1)*0.1;
display(strcat('Lx=',num2str(solutions.(strcat('f',int2str(ftop))).Lx,3)))
display(strcat('Ly=',num2str(solutions.(strcat('f',int2str(ftop))).Ly,3)))

%

% fixing position of the sources by injecting it into all individuals
for k=1:n
    population.(strcat('gene',int2str(k))).Lx= solutions.(strcat('f',int2str(300))).Lx;
    population.(strcat('gene',int2str(k))).Ly= solutions.(strcat('f',int2str(300))).Ly;
    
end
%
% calculating position dependent parameters to increase performance of
% fitness evaluation for later generations
sourcepar=fit_pargen(population,n,f,phi_mat,f_mat,p_mat);

% calculating solutions for the rest of the frequency range with an initial
% population that always is the final population of the preceeding
% frequency
for h=1:length(f)
    for l=1:Nrest
        tic;
        fit=quickfit(population,n,f(h),polylf,polyhf,sourcepar);
        population=gen_step(population,n,fit,surquote,replacement,tlevel,pmut);
        display(strcat('f=',int2str(f(h)),'Hz, ',int2str(l), ' gen. comp. in ',int2str(toc),' s'))
    end
    [~,fitsort]=sort(fit);
    solutions.(strcat('f',int2str(f(h))))= population.(strcat('gene',int2str(fitsort(1))));
end

% saving solution to file
save('jonas_sol01.mat','solutions','ftop','fres','fbot')