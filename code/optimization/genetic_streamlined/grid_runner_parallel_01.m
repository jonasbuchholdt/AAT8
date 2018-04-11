clear variables
Lx=0.2:0.05:1;
Ly=Lx;

n=350;
N=17;

times=[100 100];

master=struct;
    delete(gcp('nocreate'));
    workers=parpool(4);


sfields=cell(1,length(Lx));


for k=1:length(Ly)
    parfor h=1:length(Lx)
        sfields{1,h}=fixed_gen(Lx(h),Ly(k),n,N);
        estimated_finish=mean(times)*(length(Ly)*length(Lx)-(h+(k*h-1)));
        display(strcat(int2str(k),'_',int2str(h)))
    end
    for h=1:length(Lx)
        master.og.(strcat('S_',int2str(Lx(h)*100),'_',int2str(Ly(k)*100)))=sfields{1,h};
    end
end

save('grid02.mat','master')

%%
% Cost calculation and storage
% for k=1:length(Ly)
%     for h=1:length(Lx)
%         tic;
%         master.nrgcost.(strcat('S_',int2str(Lx(h)*100),'_',int2str(Ly(k)*100)))=fixed_gen(Lx(h),Ly(k),50,2);
%         times=[times(end-1:end) toc]
%         estimated_finish=mean(times)*(length(Ly)*length(Lx)-(h+(k*h-1)));
%         display(strcat('Performing Optimizations, time left: ',int2str(floor(estimated_finish/3600)),':',int2str(floor(mod(estimated_finish,3600)/60)),':',int2str(floor(mod(estimated_finish,60)))))
%     end
%     save('test.m','master')
% end
