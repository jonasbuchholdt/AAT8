#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 18 10:50:37 2018

@author: ck
"""

#%%
import scipy.io as sio
import math as m
import numpy as np

it = sio.loadmat("./impulse_response_5cm_grid_80m_room.mat");        # loading impulse response for transparent source
it = it['it'];
it = it.T

frequency = 60;                     # setting frequency for simulation    [Hz]
room_x = 10;                        # room size in x-dimension             [m]
room_y = 10;                        # room size in y-dimension             [m]
room_z = 1;                         # room size in y-dimension             [m]                        

grid_size = 0.05;                   # grid resolution                      [m]

before= 0;                          # variable for progress output         [1]
c = 343;                            # speed of sound in air           [m*s^-1]
rho = 1.21;                         # specific density of air        [kg*m^-3]

# calculating minimum stable sample frequency based on grid size
fs_min = 1/((np.square(2/3)*(1/grid_size**2+1/grid_size**2+1/grid_size**2)**(-1/2))/c)

fs = m.ceil(fs_min/10)*10;          # rounding minimum sample frequency   [Hz]
delta_t = 1/fs;                     # time step                            [s]

a=1;                                # sound absorption coefficient         [1]
Z_FDTD = (rho*grid_size)/delta_t;   # impedance                     [N*s*m^-3]
# boundary impedance [N*s*m^-3]
Z0 = rho*c*((1+np.square(1-a))/(1-np.square(1-a)));
alpha = (1-Z0/Z_FDTD)/(1+Z0/Z_FDTD);# boundary parameter                   [1]
beta = 1/(1+Z0/Z_FDTD);             # boundary parameter                   [1]

# position of a sound source centered in the room
speaker_center = np.array([room_x/2,room_y/2,room_z/2]);
spc = speaker_center/grid_size;      # coordinates of the sound source



ro = round(room_x/grid_size)-1;     # number of rows in storage array      [1]
co = round(room_y/grid_size)-1;     # number of columns in storage array   [1]
la = round(room_z/grid_size)-1;     # number of layers in storage array    [1]
ti = 2;                             # number of pages for time in storage  [1] 


pressure = np.tile(0, (ro,co,la,ti));
p_rms = np.tile(0, (ro,co,la));
Vx = np.tile(0, (ro+1,co,la,ti));
Vy = np.tile(0, (ro,co+1,la,ti));
Vz = np.tile(0, (ro,co,la+1,ti));

simulation_step = int((room_x/grid_size/2)) # simulation step.


