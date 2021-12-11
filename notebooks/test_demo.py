import numpy as np
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeature
from cartopy.mpl.ticker import LongitudeFormatter, LatitudeFormatter
import netCDF4 

from ncmaps import Cmaps

from matplotlib import cm
from ncmaps import Cmaps
from cartopy.feature import ShapelyFeature
from cartopy.io.shapereader import Reader 
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec


def make_ticklabels_invisible(fig):
    for i, ax in enumerate(fig.axes):
        ax.text(0.5, 0.5, "ax%d" % (i+1), va="center", ha="center")
        ax.tick_params(labelbottom=False, labelleft=False)


fig = plt.figure(figsize=(30,25))

gs = GridSpec(2, 2)

ax1 = plt.subplot(gs[0, 0])
rgb_file = 'radar'
#以下是核心api,实质为调用Cmaps基类的listmap()方法
cmaps = Cmaps('radar').listmap()



f = netCDF4.Dataset('/home/liyuan3970/Data/data/meto_data/radar_typhoon_liqima/wenzhou_rada/out/Z_RADR_I_Z9577_20190809150400_O_DOR_SA_CAP.bin.bz2.nc')
name ="Z_RADR_I_Z9577_20190809150400_O_DOR_SA_CAP.bin.bz2.nc"
u =f.variables['u'][0,0,:,:]
v = f.variables['v'][0,0,:,:]
ref =  f.variables['ref'][0,2,:,:]
lat = f.variables['lat']
lon = f.variables['lon']

print(type(ref))
ref_all =  f.variables['ref']
ref_max = ref.max(axis=1)
print("max",ref_max.shape)
box = [119, 122.5, 27.0, 29.5]
scale = '10m'
xstep, ystep = 0.5, 0.5


from mpl_toolkits.basemap import Basemap
m = Basemap(llcrnrlon=119,llcrnrlat=27.0,urcrnrlon=122.5,urcrnrlat=29.5)


fname = '/home/liyuan3970/Data/data/meto_data/geogphy_file/zhejiang'
#fname = '/home/liyuan3970/Typhoon_LMQ/data/ncl/shp_demo/taizhou'


# zero_direction_label用来设置经度的0度加不加E和W
lon_formatter = LongitudeFormatter(zero_direction_label=False)
lat_formatter = LatitudeFormatter()
#ax.quiver(lon[::3],lat[::3],u[::3,::3], v[::3,::3], transform=ccrs.PlateCarree())

#levels = [100,150,200,250,300,350,400,450,500,550,600,650,700,750,800]
levels =  [50,150,250,350,450,550,650,750,850,950,1050,1150]
lons, lats = np.meshgrid(lon[::5],lat[::5])





shade=m.contourf(lons,lats,ref[::5,::5],cmap=cmaps)
m.barbs(lons,lats,u[::5,::5]*2.5,v[::5,::5]*2.5)
m.readshapefile(fname,'zhejiang',color='blue',linewidth=1.2)

m.colorbar(shade)
#m.colorbar?

x_val_list=[119,119.5,120,120.5,121,121.5,122,122.5]

plt.xticks(x_val_list, fontsize=25)
y_val_list=[27.0,27.5,28,28.5,29,29.5]

plt.yticks(y_val_list, fontsize=25)
# 添加网格线
#ax.grid()
plt.title("08_09 23:04",fontsize=35,fontweight='bold') 

#plt.show()
plt.text(x=119.1,y=29.2,s="a",fontsize=70)


















# identical to ax1 = plt.subplot(gs.new_subplotspec((0, 0), colspan=3))
ax2 = plt.subplot(gs[0, 1])
rgb_file = 'radar'
#以下是核心api,实质为调用Cmaps基类的listmap()方法
cmaps = Cmaps('radar').listmap()



f = netCDF4.Dataset('/home/liyuan3970/Data/data/meto_data/radar_typhoon_liqima/wenzhou_rada/out/Z_RADR_I_Z9577_20190809160100_O_DOR_SA_CAP.bin.bz2.nc')
name ="Z_RADR_I_Z9577_20190809150400_O_DOR_SA_CAP.bin.bz2.nc"
u =f.variables['u'][0,0,:,:]
v = f.variables['v'][0,0,:,:]
ref =  f.variables['ref'][0,2,:,:]
lat = f.variables['lat']
lon = f.variables['lon']

print(type(ref))
ref_all =  f.variables['ref']
ref_max = ref.max(axis=1)
print("max",ref_max.shape)
box = [119, 122.5, 27.0, 29.5]
scale = '10m'
xstep, ystep = 0.5, 0.5


from mpl_toolkits.basemap import Basemap
m = Basemap(llcrnrlon=119,llcrnrlat=27.0,urcrnrlon=122.5,urcrnrlat=29.5)


fname = '/home/liyuan3970/Data/data/meto_data/geogphy_file/zhejiang'
#fname = '/home/liyuan3970/Typhoon_LMQ/data/ncl/shp_demo/taizhou'


# zero_direction_label用来设置经度的0度加不加E和W
lon_formatter = LongitudeFormatter(zero_direction_label=False)
lat_formatter = LatitudeFormatter()
#ax.quiver(lon[::3],lat[::3],u[::3,::3], v[::3,::3], transform=ccrs.PlateCarree())

#levels = [100,150,200,250,300,350,400,450,500,550,600,650,700,750,800]
levels =  [50,150,250,350,450,550,650,750,850,950,1050,1150]
lons, lats = np.meshgrid(lon[::5], lat[::5])





shade = m.contourf(lons,lats,ref[::5,::5],cmap=cmaps)
m.barbs(lons,lats,u[::5,::5]*2.5, v[::5,::5]*2.5)
m.readshapefile(fname,'zhejiang',color='blue',linewidth=1.2)

m.colorbar(shade)

x_val_list=[119,119.5,120,120.5,121,121.5,122,122.5]

plt.xticks(x_val_list, fontsize=25)
y_val_list=[27.0,27.5,28,28.5,29,29.5]

plt.yticks(y_val_list, fontsize=25)
# 添加网格线
#ax.grid()
plt.title("08_10 00:01",fontsize=35,fontweight='bold') 

plt.text(x=119.1,y=29.2,s="b",fontsize=70)



















ax3 = plt.subplot(gs[1:,0])
rgb_file = 'radar'
#以下是核心api,实质为调用Cmaps基类的listmap()方法
cmaps = Cmaps('radar').listmap()



f = netCDF4.Dataset('/home/liyuan3970/Data/data/meto_data/radar_typhoon_liqima/wenzhou_rada/out/Z_RADR_I_Z9577_20190809170300_O_DOR_SA_CAP.bin.bz2.nc')
name ="Z_RADR_I_Z9577_20190809150400_O_DOR_SA_CAP.bin.bz2.nc"
u =f.variables['u'][0,0,:,:]
v = f.variables['v'][0,0,:,:]
ref =  f.variables['ref'][0,2,:,:]
lat = f.variables['lat']
lon = f.variables['lon']

print(type(ref))
ref_all =  f.variables['ref']
ref_max = ref.max(axis=1)
print("max",ref_max.shape)
box = [119, 122.5, 27.0, 29.5]
scale = '10m'
xstep, ystep = 0.5, 0.5


from mpl_toolkits.basemap import Basemap
m = Basemap(llcrnrlon=119,llcrnrlat=27.0,urcrnrlon=122.5,urcrnrlat=29.5)


fname = '/home/liyuan3970/Data/data/meto_data/geogphy_file/zhejiang'
#fname = '/home/liyuan3970/Typhoon_LMQ/data/ncl/shp_demo/taizhou'


# zero_direction_label用来设置经度的0度加不加E和W
lon_formatter = LongitudeFormatter(zero_direction_label=False)
lat_formatter = LatitudeFormatter()
#ax.quiver(lon[::3],lat[::3],u[::3,::3], v[::3,::3], transform=ccrs.PlateCarree())

#levels = [100,150,200,250,300,350,400,450,500,550,600,650,700,750,800]
levels =  [50,150,250,350,450,550,650,750,850,950,1050,1150]
lons, lats = np.meshgrid(lon[::5], lat[::5])





shade = m.contourf(lons,lats,ref[::5,::5],cmap=cmaps)
m.barbs(lons,lats,u[::5,::5]*2.5, v[::5,::5]*2.5)
m.readshapefile(fname,'zhejiang',color='blue',linewidth=1.2)

m.colorbar(shade)

x_val_list=[119,119.5,120,120.5,121,121.5,122,122.5]

plt.xticks(x_val_list, fontsize=25)
y_val_list=[27.0,27.5,28,28.5,29,29.5]

plt.yticks(y_val_list, fontsize=25)
# 添加网格线
#ax.grid()
plt.title("08_10 01:03",fontsize=35,fontweight='bold') 

plt.text(x=119.1,y=29.2,s="c",fontsize=70)








ax4 = plt.subplot(gs[1, 1])
rgb_file = 'radar'
#以下是核心api,实质为调用Cmaps基类的listmap()方法
cmaps = Cmaps('radar').listmap()



f = netCDF4.Dataset('/home/liyuan3970/Data/data/meto_data/radar_typhoon_liqima/wenzhou_rada/out/Z_RADR_I_Z9577_20190809180500_O_DOR_SA_CAP.bin.bz2.nc')
name ="Z_RADR_I_Z9577_20190809150400_O_DOR_SA_CAP.bin.bz2.nc"
u =f.variables['u'][0,0,:,:]
v = f.variables['v'][0,0,:,:]
ref =  f.variables['ref'][0,2,:,:]
lat = f.variables['lat']
lon = f.variables['lon']

print(type(ref))
ref_all =  f.variables['ref']
ref_max = ref.max(axis=1)
print("max",ref_max.shape)
box = [119, 122.5, 27.0, 29.5]
scale = '10m'
xstep, ystep = 0.5, 0.5


from mpl_toolkits.basemap import Basemap
m = Basemap(llcrnrlon=119,llcrnrlat=27.0,urcrnrlon=122.5,urcrnrlat=29.5)


fname = '/home/liyuan3970/Data/data/meto_data/geogphy_file/zhejiang'
#fname = '/home/liyuan3970/Typhoon_LMQ/data/ncl/shp_demo/taizhou'


# zero_direction_label用来设置经度的0度加不加E和W
lon_formatter = LongitudeFormatter(zero_direction_label=False)
lat_formatter = LatitudeFormatter()
#ax.quiver(lon[::3],lat[::3],u[::3,::3], v[::3,::3], transform=ccrs.PlateCarree())

#levels = [100,150,200,250,300,350,400,450,500,550,600,650,700,750,800]
levels =  [50,150,250,350,450,550,650,750,850,950,1050,1150]
lons, lats = np.meshgrid(lon[::5], lat[::5])
shade=m.contourf(lons,lats,ref[::5,::5],cmap=cmaps)
m.barbs(lons,lats,u[::5,::5]*2.5, v[::5,::5]*2.5)
m.readshapefile(fname,'zhejiang',color='blue',linewidth=1.2)

m.colorbar(shade)

x_val_list=[119,119.5,120,120.5,121,121.5,122,122.5]

plt.xticks(x_val_list, fontsize=25)
y_val_list=[27.0,27.5,28,28.5,29,29.5]

plt.yticks(y_val_list, fontsize=25)
# 添加网格线
#ax.grid()
plt.title("08_10 02:05",fontsize=35,fontweight='bold') 

plt.text(x=119.1,y=29.2,s="d",fontsize=70)



fig.suptitle("GridSpec")
#make_ticklabels_invisible(fig)

#plt.show()

