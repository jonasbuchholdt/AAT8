function [cost,deltaLp]=beam_cost(solutions,ftop,fbot,fres,phi_cor,f_cor,p_cor,phase_cor,speakerangle)

    f=[fbot:fres:ftop];
    
    angles=0;
    r=10;
    
    coorx=sin(angles).*r;
    coory=cos(angles).*r;
    
    [~,~,~,refshift,~,~]=tricenter(solutions.f100.Lx,solutions.f100.Ly);
    refdsol=struct;
    refdsol.gene1.Lx=solutions.f100.Lx;
    refdsol.gene1.Ly=0;
    refdcory=coory-refshift;
    
    beamdsol=struct;
    beamdsol.gene1.Lx=solutions.f100.Lx;
    beamdsol.gene1.Ly=solutions.f100.Ly;
    
    pref=zeros(length(f),1);
    pbeam=pref;
    deltap=pref;
    deltaLp=pref;
    
    for h=1:length(f)
        [refcoo,refcor]=prep(refdsol,coorx,refdcory,phi_cor,f_cor,p_cor,phase_cor,speakerangle,f(h),1);
        [beamcoo,beamcor]=prep(beamdsol,coorx,coory,phi_cor,f_cor,p_cor,phase_cor,speakerangle,f(h),1);
        dummy.gene1=solutions.(strcat('f',int2str(f(h))));
        pref(h)=pcal(dummy,refcoo,refcor,2*pi*f(h),1,205);
        pbeam(h)=pcal(dummy,beamcoo,beamcor,2*pi*f(h),1,9000);
        deltaLp(h)=20*log10(abs(pref(h)))-20*log10(abs(pbeam(h)));
    end
    cost=trapz(f,deltaLp);
end