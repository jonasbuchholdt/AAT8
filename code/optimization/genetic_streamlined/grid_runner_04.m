clear variables
Lx=0.3:0.05:0.4;
Ly=Lx;

n=100;          % population size
N=5;            % number of generations



times=[1000 1000];

master=struct;
for k=1:length(Ly)
    for h=1:length(Lx)
        tic;
        master.og.(strcat('S_',int2str(Lx(h)*100),'_',int2str(Ly(k)*100)))=fixed_gen(Lx(h),Ly(k),n,N);
        times=[times(end-1:end) toc]
        estimated_finish=mean(times)*(length(Ly)*length(Lx)-(h+(k*h-1)));
        display(strcat('Performing Optimizations, time left: ',int2str(floor(estimated_finish/3600)),':',int2str(floor(mod(estimated_finish,3600)/60)),':',int2str(floor(mod(estimated_finish,60)))))
    end
    save('test.mat','master')
end

%%
% Cost calculation and storage

load('test.mat')
load('pressure_table_01.mat')           % path for correction tables
load('phase_table_neutral.mat')


for k=1:length(Ly)
    for h=1:length(Lx)
        tic;
        master.cost.(strcat('S_',int2str(Lx(h)*100),'_',int2str(Ly(k)*100)))=beam_cost(master.og.(strcat('S_',int2str(Lx(h)*100),'_',int2str(Ly(k)*100))),fupper,flower,fres,phi_cor,f_cor,p_cor,phase_cor,speakerangle);
        times=[times(end-1:end) toc]
        estimated_finish=mean(times)*(length(Ly)*length(Lx)-(h+(k*h-1)));
        display(strcat('Performing Optimizations, time left: ',int2str(floor(estimated_finish/3600)),':',int2str(floor(mod(estimated_finish,3600)/60)),':',int2str(floor(mod(estimated_finish,60)))))
    end
    save('test.m','master')
end