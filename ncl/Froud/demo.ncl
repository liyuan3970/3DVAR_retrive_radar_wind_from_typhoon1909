begin

filepath = "/home/liyuan3970/Data/demo4_run2/"

;file  = "wrfout_d02_2019-08-09_06:00:00.nc"

f = addfile(filepath +"wrfout_d02_2019-08-09_060000.nc","r")
lat_real = 28.80000
lon_real = 120.90000
time = 85


ua  = wrf_user_getvar(f,"ua",time)   ; u on mass points
va  = wrf_user_getvar(f,"va",time)   ; v on mass points
twb = wrf_user_getvar(f,"twb",time)

tc = wrf_user_getvar(f,"tc",time)
heg = wrf_user_getvar(f,"z",time)

printVarSummary(tc)

;print(tc&bottom_top)

lat0 = 27.127438
lon0 = 118.3978
lat1 = 31.39713
lon1 = 123.52594
lato = (lat1-lat0)/159.0
lono = (lon1-lon0)/159.0



;num_lat = floattoint((lat_real-lat0)/lato)
;num_lon = floattoint((lon_real-lon0)/lono)
num_lat = 62;floattoint((lat_real-lat0)/lato)
num_lon = 85;floattoint((lon_real-lon0)/lono)
print(num_lat)
print(num_lon)
;comput lat lon's number
;print(num_lat)

;print(num_lon)

z = (/0. ,195.58441,391.16882 ,  586.75323  , 782.33765  , 977.92206,\
  1173.5065  , 1369.091 ,   1564.6753  , 1760.2598  , 1955.8441 ,  2151.4285,\
  2347.013 ,   2542.5974  , 2738.182   , 2933.766  ,  3129.3506  , 3324.935,\
  3520.5195 ,  3716.1038   ,3911.6882  , 4107.2725  , 4302.857   , 4498.4414,\
  4694.026 ,   4889.6104  , 5085.195   , 5280.7793  , 5476.364   , 5671.948,\
  5867.532 ,   6063.1167  , 6258.701   , 6454.2856  , 6649.87   ,  6845.4546,\
  7041.039  ,  7236.6235  , 7432.2075  , 7627.792  ,  7823.3765  , 8018.961/)
print(z)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dz = z(10)-z(3)

twb_c = twb(3:10,num_lat,num_lon)   ;391  - 1955 = 1564

tc_c = tc(3:10,num_lat,num_lon)+272.15

t_avg = dim_avg(tc_c)-272.15;17.72451

;Ts = escorc(twb_c,z(3:10));twb_c/1564.0
;T = escorc(tc_c,z(3:10));tc_c/1564.0
Ts =(twb_c(0)-twb_c(6))/dz ;0.005854885
T =(tc_c(0)-tc_c(6))/dz ;0.006729783

u_avg = dim_avg(ua(3:10,num_lat,num_lon))

N = -(9.8/t_avg)*(Ts-T)
print(N)

Fr = 28.16/(1200*sqrt(N))
print(T)
print(Ts)
print(u_avg)
print(t_avg)
print(N)
print(Fr)
;print(twb_c)
;print(heg(0,num_lat,num_lon))
;print(twb!south_north)

;f1= addfile("test.nc","c")
;f1->ua = ua
;f1->va = va
;f1->tc = tc
;f1->twb = twb







end