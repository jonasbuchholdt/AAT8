%load('pressureone.mat')

%%
load('pressureout_04.mat')
FDTD_SIMULATION(60,result)
%%
FDTD_ANALYTIC(60,result,solutions)
