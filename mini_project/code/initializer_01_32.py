#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 18 10:50:37 2018

@author: ck
"""

#%%

import ctypes
import multiprocessing as mp
import scipy.io as sio
import math as m
import numpy as np


it = sio.loadmat("./impulse_response_5cm_grid_80m_room.mat");        # loading impulse response for transparent source
it = it['it'];
it = np.float32(it.T)

frequency = 300;                     # setting frequency for simulation    [Hz]
room_x = 10;                        # room size in x-dimension             [m]
room_y = 10;                        # room size in y-dimension             [m]
room_z = 10;                         # room size in y-dimension             [m]                        

grid_size = np.float32(0.05);                   # grid resolution                      [m]

before= 0;                          # variable for progress output         [1]
c = np.float32(343);                            # speed of sound in air           [m*s^-1]
rho = np.float32(1.21);                         # specific density of air        [kg*m^-3]

# calculating minimum stable sample frequency based on grid size
fs_min = np.float32((np.sqrt(3/(grid_size**2))*c)/(np.sqrt(2/3)))

fs = m.ceil(fs_min/10)*10;          # rounding minimum sample frequency   [Hz]
delta_t = np.float32(1/fs);                     # time step                            [s]

a=1;                                # sound absorption coefficient         [1]
Z_FDTD = np.float32((rho*grid_size)/delta_t);   # impedance                     [N*s*m^-3]
# boundary impedance [N*s*m^-3]
Z0 = np.float32(rho*c*((1+np.sqrt(1-a))/(1-np.sqrt(1-a))));
alpha = np.float32((1-Z0/Z_FDTD)/(1+Z0/Z_FDTD));# boundary parameter                   [1]
beta = np.float32(1/(1+Z0/Z_FDTD));             # boundary parameter                   [1]

# position of a sound source centered in the room
speaker_center = np.float32(np.array([room_x/2,room_y/2,0]))
spc = np.float32(speaker_center/grid_size)      # coordinates of the sound source



ro = int(round(room_x/grid_size) - 1);    # number of rows in storage array      [1]
co = int(round(room_y/grid_size) - 1);    # number of columns in storage array   [1]
la = int(round(room_z/grid_size) - 1);    # number of layers in storage array    [1]
ti = 2;                              # number of pages for time in storage  [1] 


# The pressure and particle velocity matrices
pressure_share = mp.sharedctypes.RawArray(ctypes.c_float , (ro*co*la*ti))
pressure = np.frombuffer(pressure_share, dtype=np.float32).reshape((ro,co,la,ti))

Vx_share = mp.sharedctypes.RawArray(ctypes.c_float , ((ro+1)*co*la*ti))
Vx = np.frombuffer(Vx_share, dtype=np.float32).reshape(((ro+1),co,la,ti))

Vy_share = mp.sharedctypes.RawArray(ctypes.c_float , (ro*(co+1)*la*ti))
Vy = np.frombuffer(Vy_share, dtype=np.float32).reshape((ro,(co+1),la,ti))

Vz_share = mp.sharedctypes.RawArray(ctypes.c_float , (ro*co*(la+1)*ti))
Vz = np.frombuffer(Vz_share, dtype=np.float32).reshape((ro,co,(la+1),ti))

p_rmst = np.zeros((ro,co,la), dtype=np.float32)




simulation_step = int((room_x/grid_size/2)*2) # simulation step.
print(simulation_step)
#simulation_step=2;

# Measuring distance
measure = 2;


vb_s = np.float32(beta*(2*delta_t)/(rho*grid_size))
v_s = np.float32((delta_t/(rho*grid_size)))
p_s = np.float32(((rho*(c**2)*delta_t)/grid_size))
