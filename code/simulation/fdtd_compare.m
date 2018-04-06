load('pressureone.mat')

%%
FDTD_SIMULATION(60,pressureone)
FDTD_ANALYTIC(60,pressureone)
