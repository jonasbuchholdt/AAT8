clear variables
ftop=300;
fres=20;
fbot=60;
f=flip([fbot:fres:ftop-fres]);

load('cor_table_01.mat')
polylf=5;
polyhf=1;

n=1000;                                 % population size
surquote=0.05;                          % elite survivor quote
replacement=0.6;                        % replacement by children
pmut=0.1;                               % probability of mutation
tlevel=4;

Nstart=50;
Nrest=25;

solutions=struct;

population=pop_init(n);

% best=[];
% worst=[];
% average=[];

for k=1:Nstart
    tic;
    fit=fitness_pcor(population,n,ftop,polylf,polyhf,phi_mat,f_mat,p_mat);
%     best(k)=min(fit);
%     worst(k)=max(fit);
%     average(k)=mean(fit);
    population=gen_step(population,n,fit,surquote,replacement,tlevel,pmut);
    display(strcat('f=',int2str(ftop),'Hz, ',int2str(k),' gen. comp. in ',int2str(toc),' s'))
end

[~,fitsort]=sort(fit);
solutions.(strcat('f',int2str(ftop)))=population.(strcat('gene',int2str(fitsort(1))));

for k=1:n
    population.(strcat('gene',int2str(k))).Lx=population.(strcat('gene',int2str(fitsort(1)))).Lx;
    population.(strcat('gene',int2str(k))).Ly=population.(strcat('gene',int2str(fitsort(1)))).Ly;
end

sourcepar=fit_pargen(population,n,f,phi_mat,f_mat,p_mat);

for h=1:length(f)
    for l=1:Nrest
        tic;
        fit=quickfit(population,n,f(h),polylf,polyhf,sourcepar);
        population=gen_step(population,n,fit,surquote,replacement,tlevel,pmut);
        display(strcat('f=',int2str(f(h)),'Hz, ',int2str(l),' gen. comp. in ',int2str(toc),' s'))
    end
    [~,fitsort]=sort(fit);
    solutions.(strcat('f',int2str(f(h))))=population.(strcat('gene',int2str(fitsort(1))));
end

save('sol13.mat','solutions','ftop','fres','fbot')