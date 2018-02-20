clear variables
f=300;
r=10;


Lx=1.0;
Ly=0.75;
u1=0.025;
phi1=0;
phi2=pi*(4/7);
phi3=phi2;
u2=0.05;
u3=u2;

T=1800;
numsol=100;
numrun=100;
k=1;

costold=circularcost3(f,Lx,Ly,u1,phi1,u2,phi2,u3,phi3,r);
costrun=[costold];

while k<numrun
    for l=1:numsol
        randadd=rand();
        if (Lx+0.05*(-0.5+randadd)<1.5) && (Lx+0.05*(-0.5+randadd)>0.3)
            Lxn=Lx+0.05*(-0.5+randadd);
        end
        randadd=rand();
        if (Ly+0.05*(-0.5+randadd)<1) && (Ly+0.05*(-0.5+randadd)>0.3)
            Lyn=Ly+0.05*(-0.5+randadd);
        end
        phi2n=phi2+0.2*(-0.5+rand());
        phi3n=phi2n;
        randadd=rand();
        if (u1+0.003*(-0.5+randadd)<u2) && (u1+0.003*(-0.5+randadd)>0.0001)
            u1n=u1+0.003*(-0.5+randadd);
        end
        %u3n=u2n;
        costnew=circularcost3(f,Lxn,Lyn,u1n,phi1,u2,phi2n,u3,phi3n,r);
        if costold>costnew
            Lx=Lxn;
            Ly=Lyn;
            phi2=phi2n;
            phi3=phi3n;
            u1=u1n;
            costold=costnew;
        elseif exp((costold-costnew)/T)>rand()
            Lx=Lxn;
            Ly=Lyn;
            phi2=phi2n;
            phi3=phi3n;
            u1=u1n;
            
            costold=costnew;
        end
        costrun=[costrun costold];
    end
    T=T*0.9;
    k=k+1
end
plot(costrun)