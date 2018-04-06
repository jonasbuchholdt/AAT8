%   Genetic Algorithm
%   Low-Mid-Beamforming
%   2018-03-09
%   CK
%%%-----------------------------------------------------------------------
clear variables

n=10;                                               % population size
population=struct;
for k=1:n
    population.(strcat('Lx',int2str(k)))=0.4;%0.7+0.1*(randn());
    population.(strcat('Ly',int2str(k)))=0.4;%0.7+0.1*(randn());
    population.(strcat('Va',int2str(k)))=0.025+0.02*(randn());
    population.(strcat('Vb',int2str(k)))=0.025+0.02*(randn());
    population.(strcat('Vc',int2str(k)))=0.025+0.02*(randn());
    population.(strcat('Phia',int2str(k)))=mod(2*pi*(randn()),2*pi);
    population.(strcat('Phib',int2str(k)))=mod(2*pi*(randn()),2*pi);
    population.(strcat('Phic',int2str(k)))=mod(2*pi*(randn()),2*pi);
end