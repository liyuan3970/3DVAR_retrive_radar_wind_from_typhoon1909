import pandas as pd
from scipy.interpolate import griddata
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
from math import ceil, floor
#%matplotlib inline


import numpy as np

import xarray as xr

import pandas as pd

import os

filepath = '/home/liyuan3970/3DVAR_retrive_radar_wind_from_typhoon1909/ncl/zdz/zdz_RR/RR_all_right.csv'

df = pd.read_csv(filepath,header=None)
#df

lat = list(df.iloc[:,2])
lon = list(df.iloc[:,1])
r = list(df.iloc[:,3])


#print(r)

Ni = len(r)


a = []
b = []
z = []

for i in range(Ni):
    a.append(round(lon[i],2))
    b.append(round(lat[i],2))
    z.append(round(r[i],2))

lat = b
lon = a
r = z

Zi = r
# x = np.arange(118,124,0.02)
# #print(x)
# y = np.arange(27,32,0.02)
# nx0 =len(x)
# ny0 =len(y)
# X, Y = np.meshgrid(x, y)#100*100
    #print(X.shape)
x, y = np.mgrid[
        118:124:200j,
        27:32:200j]
#P = np.array([X.flatten(), Y.flatten() ]).transpose()
    
Pi =  np.array([lon, lat ]).transpose()
Z_linear = griddata(Pi, Zi,(x, y), method = "cubic")#.reshape([ny0,nx0])    
#Z_linear = griddata(Pi, Zi, P, method = "linear").reshape([ny0,nx0])
print(Pi.shape,len(Zi))
print(Z_linear)
#print(Zi)
# plt.contourf(X, Y, Z_linear, cmap = mpl.cm.jet)
# plt.colorbar()
# #plt.contour(X, Y, Z_linear, colors = "k")
# #plt.triplot(Xi, Yi , tri.simplices.copy(), color = "k")
# #plt.plot(x0, y0, "or", label = "Data")
# #plt.legend()
# plt.grid()