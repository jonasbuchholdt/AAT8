%load('pressureone.mat')

%%
%load('pressureout_02.mat')
FDTD_SIMULATION(60,pressureout_02)
FDTD_ANALYTIC(60,pressureout_02,solutions)
