#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 18 10:50:37 2018

@author: ck
"""

#%%


it = sio.loadmat("./impulse_response_3D_40m.mat");        # loading impulse response for transparent source
it = it['it'];
it = it.T

frequency = 300;                     # setting frequency for simulation    [Hz]
room_x = 20;                        # room size in x-dimension             [m]
room_y = 20;                        # room size in y-dimension             [m]
room_z = 20;                         # room size in y-dimension             [m]                        

grid_size = 0.05;                   # grid resolution                      [m]

before= 0;                          # variable for progress output         [1]
c = 343;                            # speed of sound in air           [m*s^-1]
rho = 1.21;                         # specific density of air        [kg*m^-3]

# calculating minimum stable sample frequency based on grid size
fs_min = (np.sqrt(3/(grid_size**2))*c)/(np.sqrt(2/3))

fs = m.ceil(fs_min/10)*10;          # rounding minimum sample frequency   [Hz]
delta_t = 1/fs;                     # time step                            [s]

a=1;                                # sound absorption coefficient         [1]
Z_FDTD = (rho*grid_size)/delta_t;   # impedance                     [N*s*m^-3]
# boundary impedance [N*s*m^-3]
Z0 = rho*c*((1+np.sqrt(1-a))/(1-np.sqrt(1-a)));
alpha = (1-Z0/Z_FDTD)/(1+Z0/Z_FDTD);# boundary parameter                   [1]
beta = 1/(1+Z0/Z_FDTD);             # boundary parameter                   [1]

# position of a sound source centered in the room
speaker_center = np.array([room_x/2,room_y/2,0]);
spc = speaker_center/grid_size;      # coordinates of the sound source



ro = round(room_x/grid_size) - 1;    # number of rows in storage array      [1]
co = round(room_y/grid_size) - 1;    # number of columns in storage array   [1]
la = round(room_z/grid_size) - 1;    # number of layers in storage array    [1]
ti = 2;                              # number of pages for time in storage  [1] 



pressure_share = mp.sharedctypes.RawArray(ctypes.c_double , (ro*co*la*ti))
pressure = np.frombuffer(pressure_share, dtype=np.float64).reshape((ro,co,la,ti))

Vx_share = mp.sharedctypes.RawArray(ctypes.c_double , ((ro+1)*co*la*ti))
Vx = np.frombuffer(Vx_share, dtype=np.float64).reshape(((ro+1),co,la,ti))

Vy_share = mp.sharedctypes.RawArray(ctypes.c_double , (ro*(co+1)*la*ti))
Vy = np.frombuffer(Vy_share, dtype=np.float64).reshape((ro,(co+1),la,ti))

Vz_share = mp.sharedctypes.RawArray(ctypes.c_double , (ro*co*(la+1)*ti))
Vz = np.frombuffer(Vz_share, dtype=np.float64).reshape((ro,co,(la+1),ti))

p_rms = np.tile(0.0, (ro,co,la));

#pressure = np.tile(0.0, (ro,co,la,ti));
#p_rms = np.tile(0.0, (ro,co,la));
#Vx = np.tile(0.0, (ro+1,co,la,ti));
#Vy = np.tile(0.0, (ro,co+1,la,ti));
#Vz = np.tile(0.0, (ro,co,la+1,ti));


simulation_step = int((room_x/grid_size/2)*2) # simulation step.
print(simulation_step)
#simulation_step=2;

# Measuring distance
measure = 2;


vb_s = beta*(2*delta_t)/(rho*grid_size)
v_s = (delta_t/(rho*grid_size))
p_s = ((rho*(c**2)*delta_t)/grid_size)
