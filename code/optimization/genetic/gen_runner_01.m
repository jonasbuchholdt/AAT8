clear variables
f=60;
n=500;                                  %population size
surquote=0.05;                          %elite survivor quote
replacement=0.6;                       %replacement by children
pmut=0.1;
tlevel=4;

N=10;

population=pop_init(n);

best=[];
worst=[];

for k=1:N
    fit=fitness(population,n,f);
    best(k)=min(fit);
    worst(k)=max(fit);
    average(k)=mean(fit);
    population=gen_step(population,n,fit,surquote,replacement,tlevel,pmut);
    display(strcat(int2str(k),' generation(s) computed'))
end

close all
figure
plot(best)
hold on
plot(worst)
plot(average)

save('result3.mat','population')