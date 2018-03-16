n=100;                                  %population size
surquote=0.15;                          %elite survivor quote
replacement=0.6;                        %replacement by children


m=ceil(n*replacement/2);                %number of parent pairs

population=pop_init(n);

pop_new=population;

fit=fitness(population,n,100);

parents=par_choose(population,n,fit,m,4);

[~,fitsort]=sort(fit);

sur=[];
for h=1:n
    sur(n)=population.(strcat('gene',int2str(h))).sur;
end

[~,sursort]=sort(sur);

for k=1:(ceil(n*surquote))
    population.(strcat('gene',int2str(fitsort(k)))).sur=1000-fit(fitsort(k));
end


for l=1:m
    [childa,childb]=offspring(population,n,parents(m,1),parents(m,2));
    pop_new.(strcat('gene',int2str(sursort(2*l-1))))=childa;
    pop_new.(strcat('gene',int2str(sursort(2*l))))=childb;
end

sum(fit)
sum(fitness(pop_new,n,100))