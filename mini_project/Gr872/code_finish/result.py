#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 30 11:31:48 2018

@author: user
"""




import math as m
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm
import scipy.interpolate
import h5py
import initializer_01_32 as data



def _result():
    """
    >>> _result() < 1
    True
    """
    # load data
    hf = h5py.File('p_rms_db_30m_32.h5', 'r')
    p_rms_db = np.array(hf.get('dataset'))
    hf.close()
    
    # cut data
    stop_time = data.simulation_step    
    limit = int(stop_time/7)
    p_rms_db_cut = p_rms_db[limit:-limit,limit:-limit]
    
    # Test point
    center = np.ceil(np.shape(data.p_rms)[1]/2)
    test_point_one = center+((data.measure/2)/data.grid_size)
    test_point_two = center+(data.measure/data.grid_size)
    
    # Simulation pressure drop with #d area
    simu_pres_drop = p_rms_db[int(center),int(test_point_two)] - p_rms_db[int(center),int(test_point_one)]
    analy_pres_drop = 20*np.log10(data.measure/2/data.measure)

    # The error between the analytical model and the simulation, 
    error = np.abs(simu_pres_drop - analy_pres_drop)  

    return error#, p_rms_db_cut
    
    




if __name__ == "__main__":
    import doctest
    doctest.testmod()
    
   
    #error, p_rms_db_cut = _result()
#   
#    # Plot the RMS pressure
#    length = (np.shape(p_rms_db_cut)[1]*data.grid_size)/2
#    fig = plt.figure()
#    plt.imshow(p_rms_db_cut, vmin=p_rms_db_cut.min(), vmax=p_rms_db_cut.max()-30 ,cmap=cm.jet, extent=[-length,length,-length,length])
#    plt.xlabel("Distance " + r"[m]")
#    plt.ylabel("Distance " + r"[m]")
#    plt.colorbar()
#    plt.show()



