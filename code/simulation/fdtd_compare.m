load('pressuretra.mat')

%%
FDTD_SIMULATION(100,pressuretra)
FDTD_ANALYTIC(100,pressuretra)
