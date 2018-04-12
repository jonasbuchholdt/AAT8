function [pnorm]=pcal(population,coordinates,corrections,omega,h,normoff)
    r=10;                   % radius for pressure calculation
    c=343;                  % speed of sound
    rho0=1.21;              % density of air
    t=0;                    % time for pressure calculation, does not influence result
    k=omega/c;
    a=0.1651;               % radius of the point source / m
    thetaa=tan(k*a);
    
    
    p1=(rho0.*c.*population.(strcat('gene',int2str(h))).Va .*(a./sqrt((coordinates.xshift1.^2)+(coordinates.yshift1.^2))).*cos(thetaa) .*exp(i.*(omega.*t-k.*(sqrt((coordinates.xshift1.^2)+(coordinates.yshift1.^2))-a) +thetaa+population.(strcat('gene',int2str(h))).Phia+corrections.phasecor1))).*corrections.pcor1;
    p2=(rho0.*c.*population.(strcat('gene',int2str(h))).Vb .*(a./sqrt((coordinates.xshift2.^2)+(coordinates.yshift2.^2))).*cos(thetaa) .*exp(i.*(omega.*t-k.*(sqrt((coordinates.xshift2.^2)+(coordinates.yshift2.^2))-a) +thetaa+population.(strcat('gene',int2str(h))).Phib+corrections.phasecor2))).*corrections.pcor2;
    p3=(rho0.*c.*population.(strcat('gene',int2str(h))).Vc .*(a./sqrt((coordinates.xshift3.^2)+(coordinates.yshift3.^2))).*cos(thetaa) .*exp(i.*(omega.*t-k.*(sqrt((coordinates.xshift3.^2)+(coordinates.yshift3.^2))-a) +thetaa+population.(strcat('gene',int2str(h))).Phic+corrections.phasecor3))).*corrections.pcor3;

    psum=abs(p1+p2+p3);
    if ~exist('normoff','var')
        pnorm=psum./max(psum);
    else
        pnorm=psum;
        if normoff==205
            p1=(rho0.*c.*population.(strcat('gene',int2str(h))).Va .*(a./sqrt((coordinates.xshift1.^2)+(coordinates.yshift1.^2))).*cos(thetaa) .*exp(i.*(omega.*t-k.*(sqrt((coordinates.xshift1.^2)+(coordinates.yshift1.^2))-a) +thetaa+0+corrections.phasecor1))).*corrections.pcor1;
            p2=(rho0.*c.*population.(strcat('gene',int2str(h))).Vb .*(a./sqrt((coordinates.xshift2.^2)+(coordinates.yshift2.^2))).*cos(thetaa) .*exp(i.*(omega.*t-k.*(sqrt((coordinates.xshift2.^2)+(coordinates.yshift2.^2))-a) +thetaa+0+corrections.phasecor2))).*corrections.pcor2;
            p3=(rho0.*c.*population.(strcat('gene',int2str(h))).Vc .*(a./sqrt((coordinates.xshift3.^2)+(coordinates.yshift3.^2))).*cos(thetaa) .*exp(i.*(omega.*t-k.*(sqrt((coordinates.xshift3.^2)+(coordinates.yshift3.^2))-a) +thetaa+0+corrections.phasecor3))).*corrections.pcor3;
            pnorm=abs(p1+p2+p3);    
        end
    end
end