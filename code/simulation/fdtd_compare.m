%load('pressureone.mat')

%%
load('simulated_pressure_02_60_120.mat')
FDTD_SIMULATION(60,result)
%%
FDTD_ANALYTIC(60,result,solutions)
