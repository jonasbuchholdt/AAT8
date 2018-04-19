#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 18 10:40:04 2018

@author: jonas
"""

exec(open("./initializer_01.py").read())

# calculate hard source
stop_time = simulation_step+1;
front = np.empty((stop_time));
for t in range(stop_time):
    front[t] = 1*np.sin(2*np.pi*100*((t-1)/fs));



# start point
stop_time = simulation_step;
for t in range(stop_time):
      
    

# calculate transparant source correction
    impulse=0;
    for m in range(t):
        impulse = impulse+it[t-m+1]*front[m];   
    
    k = 0;    
    
# calculate transparant source correction        
    pressure[int(spc[0]),int(spc[1]),k,0]=pressure[int(spc[0]),int(spc[1]),k,1]+front[t+1]-impulse;    
    #pressure[int(spc[0]),int(spc[1]),k,0]=front[t]    


# Particla velocity x 
    Vx[1:-1,:,k,1] = Vx[1:-1,:,k,0]-(delta_t/(rho*grid_size))*(pressure[1:,:,k,0]-pressure[:-1,:,k,0]);

# Particla velocity y
    Vy[:,1:-1,k,1] = Vy[:,1:-1,k,0]-(delta_t/(rho*grid_size))*(pressure[:,1:,k,0]-pressure[:,:-1,k,0]);


# Particla velocity at boundary x0
    Vx[0,:,k,1] = alpha*Vx[0,:,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[0,:,k,0];


# Particla velocity at boundary xend
    Vx[-1,:,k,1] = alpha*Vx[-1,:,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[-1,:,k,0];


# Particla velocity at boundary y0
    Vy[:,0,k,1] = alpha*Vy[:,0,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[:,0,k,0];


# Particla velocity at boundary yend
    Vy[:,-1,k,1] = alpha*Vy[:,-1,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[:,-1,k,0];


# The pressure
    pressure[:,:,k,1]=pressure[:,:,k,0]-((rho*(c**2)*delta_t)/grid_size)*((Vx[1:,:,k,1]-Vx[:-1,:,k,1])+(Vy[:,1:,k,1]-Vy[:,:-1,k,1]));

# The RMS pressure
    p_rms[:,:,k] = p_rms[:,:,k]+(pressure[:,:,k,1])**2;

# swapping matrix 
    pressure[:,:,k,0]=pressure[:,:,k,1];
    Vx[:,:,k,0]=Vx[:,:,k,1];
    Vy[:,:,k,0]=Vy[:,:,k,1];
    #Vz(:,:,:,1)=Vz(:,:,:,2);
    print(t)
    
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


