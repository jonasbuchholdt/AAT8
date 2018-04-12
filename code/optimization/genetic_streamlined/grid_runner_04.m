clear variables
Lx=0.3:0.05:0.4;
Ly=-Lx;

n=150;          % population size
N=10;            % number of generations



times=[1000 1000];

master=struct;
for k=1:length(Ly)
    for h=1:length(Lx)
        tic;
        master.og.(strcat('S_',int2str(abs(Lx(h)*100)),'_',int2str(abs(Ly(k)*100))))=fixed_gen(Lx(h),Ly(k),n,N);
        times=[times(end-1:end) toc];
        estimated_finish=mean(times)*((length(Ly)-k+1)*length(Lx)-(length(Lx)-h+1));
        display(strcat('Performing Optimizations, time left: ',int2str(floor(estimated_finish/3600)),':',int2str(floor(mod(estimated_finish,3600)/60)),':',int2str(floor(mod(estimated_finish,60)))))
    end
    save('test.mat','master','Lx','Ly')
end

%%
% Cost calculation and storage

load('test.mat')
load('pressure_table_01.mat')           % path for correction tables
load('phase_table_neutral.mat')   

flower=master.og.(strcat('S_',int2str(abs(Lx(1)*100)),'_',int2str(abs(Ly(1)*100)))).fbot;
fupper=master.og.(strcat('S_',int2str(abs(Lx(1)*100)),'_',int2str(abs(Ly(1)*100)))).ftop;
fres=master.og.(strcat('S_',int2str(abs(Lx(1)*100)),'_',int2str(abs(Ly(1)*100)))).fres;
speakerangle=master.og.(strcat('S_',int2str(abs(Lx(1)*100)),'_',int2str(abs(Ly(1)*100)))).speakerangle;

master.cost=zeros(length(Ly),length(Lx));
for k=1:length(Ly)
    for h=1:length(Lx)
        tic;
        master.cost(k,h)=beam_cost(master.og.(strcat('S_',int2str(abs(Lx(h)*100)),'_',int2str(abs(Ly(k)*100)))),fupper,flower,fres,phi_mat,f_mat,p_mat,phase_mat,speakerangle);
        times=[times(end-1:end) toc];
        estimated_finish=mean(times)*((length(Ly)-k+1)*length(Lx)-(length(Lx)-h));
        display(strcat('Calculating Beamforming Cost, time left: ',int2str(floor(estimated_finish/3600)),':',int2str(floor(mod(estimated_finish,3600)/60)),':',int2str(floor(mod(estimated_finish,60)))))
    end
    save('test.mat','master','Lx','Ly')


end
%%
[~,I]=min(abs(master.cost(:)));
[min_row, min_col] = ind2sub(size(master.cost),I);
display(strcat('Lx: ',num2str(Lx(min_col)),', Ly: ',num2str(Ly(min_row))))
    
[~,deltap]=beam_cost(master.og.(strcat('S_',int2str(abs(Lx(min_col)*100)),'_',int2str(abs(Ly(min_row)*100)))),fupper,flower,fres,phi_mat,f_mat,p_mat,phase_mat,speakerangle);

figure(1)
plot(20*log10(deltap))