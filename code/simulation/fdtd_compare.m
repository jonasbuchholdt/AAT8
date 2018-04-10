%load('pressureone.mat')

%%
%load('pressureout_03.mat')
FDTD_SIMULATION(60,pressureout_03)
FDTD_ANALYTIC(60,pressureout_03,solutions)
