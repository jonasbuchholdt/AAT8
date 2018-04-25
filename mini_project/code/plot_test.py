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



arr = mp.Array(ctypes.c_double, np.zeros(10,float))



def _f(d):
    if d == 0:
        arr[1:5] = np.frombuffer(arr.get_obj())[1:5]+1
  
        
M = os.cpu_count()


#if __name__ == '__main__':


pool = mp.Pool(processes=M);
pool.map(_f, (0, 1)); 
pool.close()

arr_get = np.frombuffer(arr.get_obj())

print(arr[:])