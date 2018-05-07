#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Apr 30 11:31:48 2018

@author: user
"""


def _result():
    res = p_rms_db_cut[int(center),int(test_point_two)] - p_rms_db_cut[int(center),int(test_point_one)]
    return res 
    """
    Calculating the RMS pressure drop at at double distance.
    >>>_result() > 5
    True
    >>>_result() < 7
    True
    """

import ctypes
import multiprocessing as mp
import multiprocessing.sharedctypes
import scipy.io as sio
import math as m
import numpy as np
import os
import time
import matplotlib.pyplot as plt
from matplotlib import cm
import scipy.interpolate
import h5py
import doctest

exec(open("./initializer_01_32.py").read())




if __name__ == "__main__":
    doctest.testmod()

    hf = h5py.File('p_rms_db_10m_32.h5', 'r')
    hf.keys()
    p_rms_db = np.array(hf.get('dataset'))
    hf.close()

    stop_time = simulation_step
    # Plot the RMS pressure
    limit = int(stop_time/7)
    p_rms_db_cut = p_rms_db[limit:-limit,limit:-limit]
    #p_rms_db_cut = p_rms_db_cut*2
    length = (np.shape(p_rms_db_cut)[1]*grid_size)/2
    fig = plt.figure()
    plt.imshow(p_rms_db_cut, vmin=p_rms_db_cut.min(), vmax=p_rms_db_cut.max()-30 ,cmap=cm.jet, extent=[-length,length,-length,length])
    plt.xlabel("Distance " + r"[m]")
    plt.ylabel("Distance " + r"[m]")
    plt.colorbar()
    plt.show()


    # The test
    # Test point
    center = np.ceil(np.shape(p_rms_db_cut)[1]/2)
    test_point_one = center+((measure/2)/grid_size)
    test_point_two = center+(measure/grid_size)

    # Simulation pressure drop with quadruple area
    simu_pres_drop = _result()

    # analytical pressure drop with quadruple area. The analytical calculation is
    # in 3D and therefore the distance shal only be the dobble.
    analy_pres_drop = 20*np.log10(measure/2/measure)

    # The error between the analytical model and the simulation, 
    error = simu_pres_drop - analy_pres_drop



