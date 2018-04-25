#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 23 13:06:52 2018

@author: jonas
"""
import ctypes
#rom multiprocessing.sharedctypes import Array
import multiprocessing as mp
import numpy as np
import os



R = 10

Vx = mp.Array(ctypes.c_double, (R*R*R*R));
arr_get1 = np.frombuffer(Vx.get_obj()).reshape((R,R,R,R))
#A = np.zeros((R, R ,R)).astype(np.float64)
Amp = mp.sharedctypes.RawArray(ctypes.c_double , (R*R*R*R))
arr_get2 = np.frombuffer(Amp, dtype=np.float64).reshape((R,R,R,R))
#arr_get.base.base


def _f(d):
    if d == 0:
        b=1
        arr_get2[:,:,:,:] = arr_get2[:,:,:,:]+1
  
        
M = os.cpu_count()


#if __name__ == '__main__':


pool = mp.Pool(processes=M);
pool.map(_f, (0, 1)); 
pool.close()



#print(arr_get)