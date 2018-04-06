% analytical beamforming fitnes function
% based on point sources
% cost are weighted based on the desired emission characteristic
% CK 18-03-20
%
% %%% IN  %%%
% population: population that should be evaluated                  [struct]
% n: number of individuals in population                              [int]
% f: frequency that should be optimized                               [int]
% polylf: cost shaping parameter for low frequencies                  [int]
% polyhf: cost shaping parameter for high frequencies                 [int]
% sourcepar: parameter set for increased performance               [struct]
% 
% %%% OUT %%%
% cost: fitness of each individual, lower values are  better!      [vector]      
% ------------------------------------------------------------------------
function [cost]=quickfit(population,n,f,polylf,polyhf,sourcepar)

[discard index]=min(abs(sourcepar.f-f));

r=10;                   % radius for pressure calculation

c=343;                  % speed of sound
rho0=1.21;              % density of air
t=0;                    % time for pressure calculation, does not influence result

omega=2*pi*f;
k=omega/c;

a=0.1651;                         % radius of the point source / m
thetaa=tan(k*a);

angles=[0:pi/90:2.*pi];         % measurement points along the radius

% positions of the speakers are determined by tricenter function
p1=zeros(1,length(angles));
p2=p1;
p3=p1;
cost=zeros(1,n);

for h=1:n
% calculating the pressure, caused by each source, at every point of the grid
p1=(rho0.*c.*population.(strcat('gene',int2str(h))).Va .*(a./sqrt((sourcepar.xshift1.^2)+(sourcepar.yshift1.^2))) .*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((sourcepar.xshift1.^2) +(sourcepar.yshift1.^2))-a)+thetaa+population.(strcat('gene',int2str(h))).Phia))) .*sourcepar.corrections1(index,:);
p2=(rho0.*c.*population.(strcat('gene',int2str(h))).Vb .*(a./sqrt((sourcepar.xshift2.^2)+(sourcepar.yshift2.^2))) .*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((sourcepar.xshift2.^2) +(sourcepar.yshift2.^2))-a)+thetaa+population.(strcat('gene',int2str(h))).Phib))) .*sourcepar.corrections2(index,:);
p3=(rho0.*c.*population.(strcat('gene',int2str(h))).Vc .*(a./sqrt((sourcepar.xshift3.^2)+(sourcepar.yshift3.^2))) .*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((sourcepar.xshift3.^2) +(sourcepar.yshift3.^2))-a)+thetaa+population.(strcat('gene',int2str(h))).Phic))) .*sourcepar.corrections3(index,:);

% adding the pressures together
psum=abs(p1+p2+p3);

ppnorm=psum./max(psum);         % normalizing the pressure
%Lp=20*log10(ppnorm);

% IMPORTANT: Weighting section
% weight function is based on heuristics,
% low cost near zero degrees, high cost near +-180,
% this should lead to results with good emission towards the front and
% low emissions towards the back
g=[60 300];
e=[polylf polyhf];

coeff=polyfit(g,e,1);

weight=1-abs(cos((angles./2)).^polyval(coeff,f));
%weight=1-(-abs(cos((angles./2)).^polyval(coeff,360-f))+1);


weightedp=ppnorm.*weight;

%%% PENALTY-SECTION
% constraints implemented here
penalty=0;

Lxconstraintupper=2;
Lxconstraintlower=0.5;

Lyconstraintupper=2;
Lyconstraintlower=0.2;

Vconstraintupper=1;
Vconstraintlower=0.0001;

if (abs(population.(strcat('gene',int2str(k))).Lx)) > Lxconstraintupper
    penalty=penalty+(1+population.(strcat('gene',int2str(k))).Lx)^6;
elseif abs(population.(strcat('gene',int2str(k))).Lx) < Lxconstraintlower
    penalty=penalty+abs(10*log(population.(strcat('gene',int2str(k))).Lx))^2;
end
if (abs(population.(strcat('gene',int2str(k))).Ly)) > Lyconstraintupper
    penalty=penalty+(1+population.(strcat('gene',int2str(k))).Lx)^6;
elseif abs(population.(strcat('gene',int2str(k))).Ly) < Lyconstraintlower
    penalty=penalty+abs(10*log(population.(strcat('gene',int2str(k))).Ly))^2;
end

penalty = penalty+population.(strcat('gene',int2str(k))).age^1.5;
cost(h)=sum(weightedp)+penalty;
end
end