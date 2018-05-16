% analytical beamforming fitness function
% based on point sources, with corrected pressure deviation
% cost are weighted based on the desired emission characteristic
% CK 18-03-20
%
% %%% IN  %%%
% population: population that should be evaluated                  [struct]
% n: number of individuals in population                              [int]
% f: frequency that should be optimized                               [int]
% polylf: cost shaping parameter for low frequencies                  [int]
% polyhf: cost shaping parameter for high frequencies                 [int]
% phi_cor: angular matrix of the correction table                  [matrix]
% f_cor: frequency matrix of the correction table                  [matrix]
% p_cor: pressure matrix of the correction table                   [matrix]
% speakerangle: angle for tilting the twin speakers inwards         [float]
%
% %%% OUT %%%
% cost: fitness of each individual, lower values are  better!      [vector]      
% ------------------------------------------------------------------------
function [cost] = fit_long(population,n,f,polylf,polyhf,phi_cor,phase_cor,f_cor,p_cor,speakerangle)

omega=2*pi*f;

angles=[0:pi/90:2.*pi];         % measurement points along the radius
coorx=sin(angles).*r;
coory=cos(angles).*r;

cost=zeros(1,n);

wgt=weight(angles,f,polylf,polyhf);

for h=1:n
% positions of the speakers are determined by tricenter function
[coordinates, corrections]=prep(population,coorx,coory,phi_cor,f_cor,p_cor,phase_cor,speakerangle,f,h)
ppnorm=pcal(population,coordinates,corrections,omega,h);

weightedp=ppnorm.*wgt;

%%% PENALTY-SECTION
% constraints implemented here
penalty=0;
%penalty=constrainer(h);
cost(h)=sum(weightedp)+penalty;

end
end