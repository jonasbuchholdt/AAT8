#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 18 10:40:04 2018

@author: jonas
"""

exec(open("./initializer_01.py").read())

import multiprocessing as mp
import os
import time


def _p():
    """Claculate the pressure at time 0"""
    press = pressure[i,j,k,0] - ((rho*c**2*delta_t)/grid_size)*((Vx[i+1,j,k,0]-Vx[i,j,k,0])+(Vy[i,j+1,k,0]-Vy[i,j,k,0])+(Vz[i,j,k+1,0]-Vz[i,j,k,0])); 
    return press

def _f(d):
    if d == 0:
        """Claculate the particle valocity x at time 0"""
        vel_x = Vx[1:-1,:,k,0]-(delta_t/(rho*grid_size))*(pressure[1:,:,k,0]-pressure[:-1,:,k,0]);
        pid = os.getpid()
        print(" Particle velocity x process id {:7d}".format( pid))
        return vel_x
    if d == 1:
        """Claculate the particle valocity y at time 0"""
        vel_y = Vy[:,1:-1,k,0]-(delta_t/(rho*grid_size))*(pressure[:,1:,k,0]-pressure[:,:-1,k,0]);
        pid = os.getpid()
        print(" Particle velocity y process id {:7d}".format( pid))
        return vel_y    
    if d == 2:
        """Claculate the particle valocity at left boundary x, at time 0"""
        vel_xlb = alpha*Vx[0,:,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[0,:,k,0];
        pid = os.getpid()
        print(" Boundary x left process id {:7d}".format( pid))
        return vel_xlb
    if d == 3:
        """Claculate the particle valocity at right boundary x, at time 0"""
        vel_xrb = alpha*Vx[-1,:,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[-1,:,k,0];
        pid = os.getpid()
        print(" Boundary x right process id {:7d}".format( pid))
        return vel_xrb 
    if d == 4:
        """Claculate the particle valocity at top boundary y, at time 0"""
        vel_ytb = alpha*Vy[:,0,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[:,0,k,0];
        pid = os.getpid()
        print(" Boundary y top process id {:7d}".format( pid))
        return vel_ytb
    if d == 5:
        """Claculate the particle valocity at bottom boundary y, at time 0"""
        vel_ybb = alpha*Vy[:,-1,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[:,-1,k,0];
        pid = os.getpid()
        print(" Boundary y bottom process id {:7d}".format( pid))
        return vel_ybb
        
        


# calculate hard source
stop_time = simulation_step+1;
front = np.empty((stop_time));
for t in range(stop_time):
    front[t] = 1*np.sin(2*np.pi*100*((t-1)/fs));
    
k = 0;
M = os.cpu_count()
 
# start point
stop_time = simulation_step;
for t in range(stop_time):
      
    # calculate transparant source correction
    impulse = 0;
    for m in range(t):
        impulse = impulse + it[t-m+1]*front[m];   
    
    # calculate transparant source        
    pressure[int(spc[0]),int(spc[1]),k,0] = pressure[int(spc[0]),int(spc[1]),k,1] + front[t+1] - impulse;    
   
    # Calculate the particle velocity in parallel   
    pool = mp.Pool(processes=M);
    result = pool.map(_f, (0, 1, 2, 3, 4, 5));    
    Vx[1:-1,:,k,1] = result[0];
    Vy[:,1:-1,k,1] = result[1];
    Vx[0,:,k,1] = result[2];
    Vx[-1,:,k,1] = result[3];
    Vy[:,0,k,1] = result[4];
    Vy[:,-1,k,1] = result[5];
    pool.close(); 

    # Calculate the pressure
    pressure[:,:,k,1] = _p();

    # Calculate the pressure squared + the earlier pressure squared
    p_rms[:,:,k] = p_rms[:,:,k] + (pressure[:,:,k,1])**2;

    # Store the new time in old time by swapping matrix 
    pressure[:,:,k,0] = pressure[:,:,k,1];
    Vx[:,:,k,0] = Vx[:,:,k,1];
    Vy[:,:,k,0] = Vy[:,:,k,1];
    print(t)

# Calculate the RMS pressure
p_rms_time = np.sqrt(p_rms[:,:,k]/t);
p_rms_db = 20*np.log10(p_rms_time[:,:]/(20*10**(-6)));


#exec(open("./plotout.py").read())

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
from matplotlib import cm


sizes=np.shape(pressure)
xaxis=np.linspace((-room_x/2),(room_x/2),sizes[0]);
yaxis=np.linspace((-room_y/2),(room_y/2),sizes[1]);


#grid=np.mgrid[(-room_x/2):grid_size:(room_x/2),(-room_y/2):grid_size:(room_y/2)];
grid=np.meshgrid(xaxis,yaxis)

fig = plt.figure()
ax = fig.gca(projection='3d')
surf = ax.plot_surface(grid[0],grid[1],p_rms_db[:,:],cmap=cm.coolwarm,linewidth=0)


