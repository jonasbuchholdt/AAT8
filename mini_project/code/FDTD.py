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
    front[t] = np.sin(2*np.pi*100*((t-1)/fs));



# start point
stop_time = simulation_step;
for t in range(stop_time):
      


# calculate transparant source correction
    impulse=0;
    for m in range(t):
        impulse = impulse+it[t-m+1]*front[m];   
    
    k = 0;    
    
# calculate transparant source correction        
    pressure[int(spc[1]),int(spc[2]),k,0]=pressure[int(spc[1]),int(spc[2]),k,1]+front[t+1]-impulse;    


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
    pressure[:,:,k,1]=pressure[:,:,k,0]-((rho*(c^2)*delta_t)/grid_size)*((Vx[1:,:,k,1]-Vx[:-1,:,k,1])+(Vy[:,1:,k,1]-Vy[:,:-1,k,1]));


# swapping matrix 
    pressure[:,:,k,0]=pressure[:,:,k,1];
    Vx[:,:,k,0]=Vx[:,:,k,1];
    Vy[:,:,k,0]=Vy[:,:,k,1];
    #Vz(:,:,:,1)=Vz(:,:,:,2);






