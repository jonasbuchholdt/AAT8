#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 18 10:50:37 2018

@author: ck
"""
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
surf = ax.plot_surface(grid[0],grid[1],pressure[:,:,0,0],cmap=cm.coolwarm,linewidth=0)