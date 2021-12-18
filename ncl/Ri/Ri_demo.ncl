begin

filepath = "/home/liyuan3970/Data/demo4_run2/"

;file  = "wrfout_d02_2019-08-09_06:00:00.nc"

f = addfile(filepath +"wrfout_d02_2019-08-09_060000.nc","r")
lat_real = 28.80000
lon_real = 120.90000
time = 85

z = wrf_user_getvar(f,"z",time)
eth  = wrf_user_getvar(f,"eth",time)
printVarSummary(z)
ua  = wrf_user_getvar(f,"ua",time)   ; u on mass points
va  = wrf_user_getvar(f,"va",time)   ; v on mass points
twb = wrf_user_getvar(f,"twb",time)

tc = wrf_user_getvar(f,"tc",time)
heg = wrf_user_getvar(f,"z",time)

printVarSummary(eth)

;print(tc&bottom_top)

lat0 = 27.127438
lon0 = 118.3978
lat1 = 31.39713
lon1 = 123.52594
lato = (lat1-lat0)/159.0
lono = (lon1-lon0)/159.0




num_lat = 62;floattoint((lat_real-lat0)/lato)
num_lon = 85;floattoint((lon_real-lon0)/lono)


low = 4;1849
high = 12;4201

g = 9.8
z_point = z(:,num_lat,num_lon)
eth_point = eth(:,num_lat,num_lon)
dethz = center_finite_diff_n(eth_point, z_point,False,0,0)
u_point = ua(:,num_lat,num_lon)
v_point = ua(:,num_lat,num_lon)
print(z_point(12))

ave_eth =  (eth_point(high)+eth_point(low))/2
speed = (u_point(high)-u_point(low))*(u_point(high)-u_point(low)) + (v_point(high)-v_point(low))*(v_point(high)-v_point(low))
dif_eth =(eth_point(high)-eth_point(low))
dif_z =(z_point(high)-z_point(low))/1000



Ri = (g/ave_eth)*(dif_eth*dif_z/speed)
print(ave_eth)
print(dif_eth)
print(dif_z)
print(speed)


print(Ri)


asciiwrite("data.txt",eth_point)
end