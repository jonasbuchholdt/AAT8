function [Lppolar]=pdata(instruct,Lxopt,Lyopt,prpath,phpath,angles)

load(prpath)           % path for correction tables
load(phpath)

flower=instruct.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))).fbot;
fupper=instruct.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))).ftop;
fres=instruct.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))).fres;
speakerangle=instruct.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))).speakerangle;
f=flip([flower:fres:fupper]);

phase_cor=phase_mat;
phi_cor=phi_mat;
f_cor=(f_mat);
p_cor=p_mat;
botlim=-27;

solutions=instruct.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100))));

r=10;

Lpolar=[];
thetasort=[];


c=343;
a=13*2.54/2;
rho0=1.21;
t=0;

coorx=sin(angles).*r;
coory=cos(angles).*r;

Lppolar=zeros(length(f),length(angles));

for h=1:length(f)
    population.gene1=instruct.(strcat('S_',int2str(abs(Lxopt*100)),'_',int2str(abs(Lyopt*100)))).(strcat('f',int2str(f(h))));
    [coordinates, corrections]=prep(population,coorx,coory,phi_cor,f_cor,p_cor,phase_cor,speakerangle,f(h),1);
    ppnorm=pcal(population,coordinates,corrections,2*pi*f(h),1);
    Lppolar(h,:)=20.*log10(abs(ppnorm));
    for z=1:size(Lppolar,2)
        if Lppolar(h,z)<botlim
            Lppolar(h,z)=Lppolar(h,z-1);
        end
    end
end

end