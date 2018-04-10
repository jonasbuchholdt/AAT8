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
function [cost]=fit_quick(population,n,f,polylf,polyhf,sourcepar)

[discard index]=min(abs(sourcepar.f-f));

omega=2*pi*f;

corrections=struct;
corrections.pcor1=sourcepar.corrections.pcor1(index,:);
corrections.pcor2=sourcepar.corrections.pcor2(index,:);
corrections.pcor3=sourcepar.corrections.pcor3(index,:);
corrections.phasecor1=sourcepar.corrections.phasecor1(index,:);
corrections.phasecor2=sourcepar.corrections.phasecor2(index,:);
corrections.phasecor3=sourcepar.corrections.phasecor3(index,:);

angles=[0:pi/90:2.*pi];         % measurement points along the radius

wgt=weight(angles,f,polylf,polyhf);
cost=zeros(1,n);

for h=1:n
% calculating the pressure, caused by each source, at every point of the grid

ppnorm=pcal(population,sourcepar.coordinates,corrections,omega,h);
%Lp=20*log10(ppnorm);

weightedp=ppnorm.*wgt;
penalty=0;
%penalty=constrainer(h)

cost(h)=sum(weightedp)+penalty;
end
end