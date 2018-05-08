#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May  8 08:50:08 2018

@author: jonas
"""

def my_function(a, b):
    """
    >>> my_function(2, 3)
    6
    >>> my_function('a', 3)
    'aaa'
    """
    return a * b
    
if __name__ == '__main__':
    import doctest
    doctest.testmod()
    