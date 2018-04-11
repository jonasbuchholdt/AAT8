function [cost]=beam_cost(solutions,fupper,flower,fres,phi_cor,f_cor,p_cor,phase_cor,speakerangle)
    


    f=flip([fbot:fres:ftop])
    
    angle=0;
    r=10;
    c=343;
    a=0.13*2.54/2;
    rho0=1.21;
    t=0;
    
    coorx=sin(angles).*r;
    coory=cos(angles).*r;
    
    dummysol=struct;
    dummysol.gene1.Lx=solutions.gene1.Lx;
    
    for h=1:length(f)
       [refcoo,refcor]=prep(solutions.
        
        
    end
end