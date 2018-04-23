#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr 19 09:00:38 2018

@author: jonas
"""
exec(open("./initializer_01.py").read())

def _p(i,j,k):
    """Claculate the pressure at time 0"""
    press = pressure[i,j,k,0] - ((rho*c**2*delta_t)/grid_size)*((Vx[i+1,j,k,0] - Vx[i,j,k,0]) + (Vy[i,j+1,k,0] - Vy[i,j,k,0]) + (Vz[i,j,k+1,0] - Vz[i,j,k,0])); 
    return press

def _vx(i,j,k):
    """Claculate the particle valocity x at time 0"""
    vel_x = Vx[i+1,j,k,0] - (delta_t/(rho*grid_size))*(pressure[i+1,j,k,1] - pressure[i,j,k,1]);
    #vel_x = Vx[1:-1,:,k,0]-(delta_t/(rho*grid_size))*(pressure[1:,:,k,0]-pressure[:-1,:,k,0]);
    return vel_x

def _vy(i,j,k):
    """Claculate the particle valocity y at time 0"""
    vel_y = Vy[i,j+1,k,0] - (delta_t/(rho*grid_size))*(pressure[i,j+1,k,1] - pressure[i,j,k,1]);
    #vel_y = Vy[:,1:-1,k,0]-(delta_t/(rho*grid_size))*(pressure[:,1:,k,0]-pressure[:,:-1,k,0]);
    return vel_y

def _vxlb(i,j,k):
    """Claculate the particle valocity at left boundary x, at time 0"""
    vel_xlb = alpha*Vx[i,j,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[i,j,k,1];
    #vel_xlb = alpha*Vx[0,:,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[0,:,k,0];
    return vel_xlb

def _vxrb(i,j,k):
    """Claculate the particle valocity at right boundary x, at time 0"""
    vel_xrb = alpha*Vx[i,j,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[i-1,j,k,1];
    #vel_xrb = alpha*Vx[-1,:,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[-1,:,k,0];
    return vel_xrb

def _vytb(i,j,k):
    """Claculate the particle valocity at top boundary y, at time 0"""
    vel_ytb = alpha*Vy[i,j,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[i,j,k,1];
    #vel_ytb = alpha*Vy[:,0,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[:,0,k,0];
    return vel_ytb  

def _vybb(i,j,k):
    """Claculate the particle valocity at bottom boundary y, at time 0"""
    vel_ybb = alpha*Vy[i,j,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[i,j-1,k,1];
    #vel_ybb = alpha*Vy[:,-1,k,0] - beta*(2*delta_t)/(rho*grid_size)*pressure[:,-1,k,0];
    return vel_ybb
    


# calculate hard source
stop_time = simulation_step+1;
front = np.empty((stop_time));
for t in range(stop_time):
    front[t] = np.sin(2*np.pi*100*((t-1)/fs));

k = 0;

# start point
stop_time = simulation_step;
for t in range(stop_time):
      


# calculate transparant source correction
    impulse = 0;
    for m in range(t):
        impulse = impulse + it[t-m+1]*front[m];   
           

    pressure[int(spc[0]),int(spc[1]),k,0] = pressure[int(spc[0]),int(spc[1]),k,1] + front[t+1] - impulse;  


    for i in range(ro):
        for j in range(co):
            pressure[i,j,k,1] = _p(i,j,k);


    for i in range(ro-1):
        for j in range(co):
            Vx[i+1,j,k,1] = _vx(i,j,k);


    for i in range(ro):
        for j in range(co-1):
            Vy[i,j+1,k,1] = _vy(i,j,k);


    for i in range(ro):
        j=i;    
        Vx[i,j,k,1] = _vxlb(0,j,k);
        Vx[i,j,k,1] = _vxrb(ro,j,k);    
        Vy[i,j,k,1] = _vytb(i,0,k);
        Vy[i,j,k,1] = _vybb(i,ro,k);

    for i in range(ro):
        for j in range(co):
            p_rms[i,j,k] = p_rms[i,j,k] + (pressure[i,j,k,0])**2;


#swapping matrix 
    tmp = pressure[:,:,:,0];
    pressure[:,:,:,0] = pressure[:,:,:,1]; 
    pressure[:,:,:,1] = tmp;
    tmp = Vx[:,:,:,1];
    Vx[:,:,:,0] = Vx[:,:,:,1];
    Vx[:,:,:,1] = tmp;
    tmp = Vy[:,:,:,0];
    Vy[:,:,:,0] = Vy[:,:,:,1];
    Vy[:,:,:,1] = tmp;
    print(t)

p_rms_time = (p_rms[:,:,k]/t)**(1/2);
p_rms_db = 20*np.log10(p_rms_time[:,:]/(20*10**(-6)));


import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm


sizes=np.shape(pressure)
xaxis=np.linspace((-room_x/2),(room_x/2),sizes[0]);
yaxis=np.linspace((-room_y/2),(room_y/2),sizes[1]);


#grid=np.mgrid[(-room_x/2):grid_size:(room_x/2),(-room_y/2):grid_size:(room_y/2)];
grid=np.meshgrid(xaxis,yaxis)

fig = plt.figure()
ax = fig.gca(projection='3d')
surf = ax.plot_surface(grid[0],grid[1],p_rms_db[:,:],cmap=cm.coolwarm,linewidth=0)




