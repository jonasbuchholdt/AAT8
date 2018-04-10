function [solutions]=fixed_gen(Lx,Ly,n,N)
ftop=300;                               % upper frequency border for which parameters should be found
fres=10;                                % frequency resolution of the solution
fbot=60;                                % lower frequency border
f=flip([fbot:fres:ftop]);

load('pressure_table_01.mat')           % path for correction tables
load('phase_table_neutral.mat')

speakerangle=deg2rad(50);

polylf=5;                               % cost adjustment parameter for low frequencies
polyhf=1.5;                             % cost adjustment parameter for high frequencies

surquote=0.05;                          % elite survivor quote
replacement=0.6;                        % replacement by children
pmut=0.1;                               % probability of mutation
tlevel=4;                               % tournament level for parent selection

solutions=struct;                       % initializing solution struct


%population=pop_init(n);                 % generating initial population
population=pop_init_fix(n,Lx,Ly);

%
% calculating position dependent parameters to increase performance of
% fitness evaluation for later generations
sourcepar=fit_pargen(population,n,f,phi_mat,f_mat,p_mat,phase_mat,speakerangle);

% calculating solutions for the rest of the frequency range with an initial
% popul0ation that always is the final population of the preceeding
% frequency
for h=1:length(f)
%    tic
    for l=1:N
        fit=fit_quick(population,n,f(h),polylf,polyhf,sourcepar);
        population=gen_step(population,n,fit,surquote,replacement,tlevel,pmut);
    end
    [~,fitsort]=sort(fit);
    solutions.(strcat('f',int2str(f(h))))= population.(strcat('gene',int2str(fitsort(1))));
    %display(strcat('f=',int2str(f(h)),'Hz, computed in ',int2str(toc),' s'))
end
solutions.ftop=ftop;
solutions.fres=fres;
solutions.fbot=fbot;
solutions.Lx=Lx;
solutions.Ly=Ly;
solutions.polyhf=polyhf;
solutions.polylf=polylf;
end