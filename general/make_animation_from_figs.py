# -*- coding: utf-8 -*-
"""
Created on Wed Nov  3 12:07:32 2021

@author: backeber
"""

import imageio
from os import listdir
from os.path import isfile, join

fpath = 'C:\\Users\\backeber\\OneDrive - Stichting Deltares\\Desktop\\Project-D-HYDRO-Phase-4\\figures\\all_timesteps\\'
mpath = 'C:\\Users\\backeber\\OneDrive - Stichting Deltares\\Desktop\\Project-D-HYDRO-Phase-4\\figures\\'

fnames = [f for f in listdir(fpath) if isfile(join(fpath, f))]

with imageio.get_writer(mpath+'movie.gif', mode='I', duration=0.2) as writer:
    for filename in fnames:
        image = imageio.imread(fpath+filename)
        writer.append_data(image)
        print('appended '+filename+' to movie')
