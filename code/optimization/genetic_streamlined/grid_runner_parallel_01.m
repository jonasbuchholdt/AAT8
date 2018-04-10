clear variables
Lx=0.2:0.05:1;
Ly=Lx;

times=[100 100];

master=struct;
parpool
spmd
for k=1:length(Ly)
    for h=1:length(Lx)
        tic;
        master.og.(strcat('S_',int2str(Lx(h)*100),'_',int2str(Ly(k)*100)))=fixed_gen(Lx(h),Ly(k),50,2);
        times=[times(end-1:end) toc]
        estimated_finish=mean(times)*(length(Ly)*length(Lx)-(h+(k*h-1)));
        display(strcat('Performing Optimizations, time left: ',int2str(floor(estimated_finish/3600)),':',int2str(floor(mod(estimated_finish,3600)/60)),':',int2str(floor(mod(estimated_finish,60)))))
    end
    save('grid.m','master')
end
end


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