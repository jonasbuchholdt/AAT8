% analytical beamforming fitnes function
% based on point sources
% cost are weighted based on the desired emission characteristic
% CK 18-03-09
%
% %%% IN  %%%
% population: population that should be evaluated                  [struct]
% n: number of individuals in population                              [int]
% f: frequency that should be optimized                               [int]
% 
% %%% OUT %%%
% cost: fitness of each individual, lower values are  better!      [vector]      
% ------------------------------------------------------------------------
function [cost]=fitness(population,n,f,polylf,polyhf)

r=10;                   % radius for pressure calculation

c=343;                  % speed of sound
rho0=1.21;              % density of air
t=0;                    % time for pressure calculation, does not influence result

omega=2*pi*f;
k=omega/c;

a=0.1651;                         % radius of the point source / m
thetaa=tan(k*a);

angles=[0:pi/90:2.*pi];         % measurement points along the radius
coorx=sin(angles).*r;
coory=cos(angles).*r;



% positions of the speakers are determined by tricenter function


for h=1:n
% positions of the speakers are determined by tricenter function
[s1x,s1y,s2x,s2y,s3x,s3y]=tricenter(population.(strcat('gene',int2str(h))).Lx,population.(strcat('gene',int2str(h))).Ly);
% shifting values according to the position of the individual sources
% this leads to calculating the pressure at the same points in the room
% for each of the three point sources, so that they can be added together.

yshift1=coory-s1y;
xshift1=coorx-s1x;

yshift2=coory-s2y;
xshift2=coorx-s2x;

yshift3=coory-s3y;
xshift3=coorx-s3x;


% calculating the pressure, caused by each source, at every point of the grid
p1=rho0.*c.*population.(strcat('gene',int2str(h))).Va.*(a./sqrt((xshift1.^2)+(yshift1.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift1.^2)+(yshift1.^2))-a)+thetaa+population.(strcat('gene',int2str(h))).Phia));
p2=rho0.*c.*population.(strcat('gene',int2str(h))).Vb.*(a./sqrt((xshift2.^2)+(yshift2.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift2.^2)+(yshift2.^2))-a)+thetaa+population.(strcat('gene',int2str(h))).Phib));
p3=rho0.*c.*population.(strcat('gene',int2str(h))).Vc.*(a./sqrt((xshift3.^2)+(yshift3.^2))).*cos(thetaa).*exp(i.*(omega.*t-k.*(sqrt((xshift3.^2)+(yshift3.^2))-a)+thetaa+population.(strcat('gene',int2str(h))).Phic));

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



%weight=(0.5-(cos(angles)/2));
%weight=1-flattopwin(length(ppnorm))';
weight=1-abs(cos((angles./2)).^polyval(coeff,f));
%weightedp=abs(ppnorm).*weight;
%weight=((0.5-(cos(angles)/2)).^2);
weightedp=ppnorm.*weight;

%%% PENALTY-SECTION
% constraints implemented here
penalty=0;

Lxconstraintupper=2;
Lxconstraintlower=0.6;

Lyconstraintupper=2;
Lyconstraintlower=0.2;

Vconstraintupper=1;
Vconstraintlower=0.0001;

if population.(strcat('gene',int2str(k))).Lx > Lxconstraintupper
    penalty=penalty+(1+population.(strcat('gene',int2str(k))).Lx)^6;
elseif population.(strcat('gene',int2str(k))).Lx < Lxconstraintlower
    penalty=penalty+abs(10*log(population.(strcat('gene',int2str(k))).Lx))^2;
end
if population.(strcat('gene',int2str(k))).Ly > Lyconstraintupper
    penalty=penalty+(1+population.(strcat('gene',int2str(k))).Lx)^6;
elseif population.(strcat('gene',int2str(k))).Ly < Lyconstraintlower
    penalty=penalty+abs(10*log(population.(strcat('gene',int2str(k))).Ly))^2;
end
% if population.(strcat('gene',int2str(k))).Va > Vconstraintupper || population.(strcat('gene',int2str(k))).Vb > Vconstraintupper || population.(strcat('gene',int2str(k))).Vc > Vconstraintupper
%     penalty=penalty+((population.(strcat('gene',int2str(k))).Va)^10)+((population.(strcat('gene',int2str(k))).Vb))^10+((population.(strcat('gene',int2str(k))).Vc)^10);
% elseif population.(strcat('gene',int2str(k))).Va < Vconstraintlower || population.(strcat('gene',int2str(k))).Vb < Vconstraintlower || population.(strcat('gene',int2str(k))).Vc < Vconstraintlower
%     penalty=penalty+(abs(10*log(population.(strcat('gene',int2str(k))).Va))^2)+(abs(10*log(population.(strcat('gene',int2str(k))).Vb))^2)+(abs(10*log(population.(strcat('gene',int2str(k))).Vc))^2);
% end
penalty = penalty+population.(strcat('gene',int2str(k))).age^1.5;
cost(h)=sum(weightedp)+penalty;
end
end