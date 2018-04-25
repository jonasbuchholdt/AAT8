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
import matplotlib.pyplot as plt
from matplotlib import cm
import scipy.interpolate
import h5py


def _p():
    """Claculate the pressure at time 0"""
    press = pressure[:,:,k,0] - ((rho*(c**2)*delta_t)/grid_size)*((Vx[1:,:,k,1] - Vx[:-1,:,k,1]) + (Vy[:,1:,k,1] - Vy[:,:-1,k,1])); 
    return press

def _vx():
    """Claculate the particle valocity x at time 0"""
    vel_x = Vx[1:-1,:,k,0] - (delta_t/(rho*grid_size))*(pressure[1:,:,k,0] - pressure[:-1,:,k,0]);
    #pid = os.getpid()
    #print(" Particle velocity x process id {:7d}".format( pid))
    return vel_x

def _vy():
    """Claculate the particle valocity y at time 0"""
    vel_y = Vy[:,1:-1,k,0] - (delta_t/(rho*grid_size))*(pressure[:,1:,k,0] - pressure[:,:-1,k,0]);
    #pid = os.getpid()
    #print(" Particle velocity y process id {:7d}".format( pid))
    return vel_y

def _vxlb():
    """Claculate the particle valocity at left boundary x, at time 0"""
    vel_xlb = alpha*Vx[0,:,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[0,:,k,0];
    #pid = os.getpid()
    #print(" Boundary x left process id {:7d}".format( pid))
    return vel_xlb

def _vxrb():
    """Claculate the particle valocity at right boundary x, at time 0"""
    vel_xrb = alpha*Vx[-1,:,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[-1,:,k,0];
    #pid = os.getpid()
    #print(" Boundary x right process id {:7d}".format( pid))
    return vel_xrb

def _vytb():
    """Claculate the particle valocity at top boundary y, at time 0"""
    vel_ytb = alpha*Vy[:,0,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[:,0,k,0];
    #pid = os.getpid()
    #print(" Boundary y top process id {:7d}".format( pid))
    return vel_ytb  

def _vybb():
    """Claculate the particle valocity at bottom boundary y, at time 0"""
    vel_ybb = alpha*Vy[:,-1,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[:,-1,k,0];
    #pid = os.getpid()
    #print(" Boundary y bottom process id {:7d}".format( pid))
    return vel_ybb


# Calculation start time
start = time.time()

# Calculate hard source
stop_time = simulation_step+1;
front = np.empty((stop_time));
for t in range(stop_time):
    front[t] = 1*np.sin(2*np.pi*100*((t-1)/fs));
    
k = 0;

# start point
stop_time = simulation_step;
for t in range(stop_time):
      
    # Calculate transparant source correction
    impulse = 0;
    for m in range(t):
        impulse = impulse + it[t-m+1]*front[m];   
    
    # Claculate the transparant source        
    pressure[int(spc[0]),int(spc[1]),k,0] = pressure[int(spc[0]),int(spc[1]),k,1] + front[t+1] - impulse;       

    # calculate the particle velocity     
    start_for_velocity = time.time()        # Start timer for meassuring velocity calculation 
    Vx[1:-1,:,k,1] = _vx();
    Vy[:,1:-1,k,1] = _vy();
    Vx[0,:,k,1] = _vxlb();
    Vx[-1,:,k,1] = _vxrb();
    Vy[:,0,k,1] = _vytb();
    Vy[:,-1,k,1] = _vybb();
    stop_for_velocity = time.time()         # Stop timer for meassuring velocity calculation
    time_of_velocity_calculation = (stop_for_velocity-start_for_velocity );
    
    # Calculate the pressure
    pressure[:,:,k,1] = _p();

    # The pressure squared + the earlier pressure squared
    if t >= measure/grid_size:
        p_rms[:,:,k] = p_rms[:,:,k] + (pressure[:,:,k,1])**2;

    # Store the new time in old time by swapping matrix  
    pressure[:,:,k,0] = pressure[:,:,k,1];
    Vx[:,:,k,0] = Vx[:,:,k,1];
    Vy[:,:,k,0] = Vy[:,:,k,1];
    print(t)

# Claculate the RMS pressure
p_rms_time = np.sqrt(p_rms[:,:,k]/(stop_time-measure/grid_size));
p_rms_db = 20*np.log10(p_rms_time[:,:]/(20*10**(-6)));

# Calculation stop time
stop = time.time()

# Calculate the execution time 
time_of_calculation = (stop-start);

#%%

# Plot the RMS pressure
limit = int(stop_time/7);
p_rms_db_cut = p_rms_db[limit:-limit,limit:-limit];
#p_rms_db_cut = p_rms_db_cut*2
length = (np.shape(p_rms_db_cut)[1]*grid_size)/2;
fig = plt.figure()
plt.imshow(p_rms_db_cut, vmin=p_rms_db_cut.min(), vmax=p_rms_db_cut.max()-30 ,cmap=cm.jet, extent=[-length,length,-length,length])
plt.colorbar()
ax = plt.gca()
ax.set_xlabel([m])
plt.show()

# Save simulation
f = h5py.File('p_rms_db_cut.hdf5', "w") 

# The test
# Test point
center = np.ceil(np.shape(p_rms_db_cut)[1]/2);
test_point_one = center+((measure/4)/grid_size);
test_point_two = center+(measure/grid_size);

# Simulation pressure drop with quadruple area
simu_pres_drop = p_rms_db_cut[int(center),int(test_point_two)] - p_rms_db_cut[int(center),int(test_point_one)];

# analytical pressure drop with quadruple area. The analytical calculation is
# in 3D and therefore the distance shal only be the dobble.
analy_pres_drop = 20*np.log10(measure/2/measure);

# The error between the analytical model and the simulation, 
error = simu_pres_drop - analy_pres_drop;

