
;   Example script to produce cape/cin/lcl/lfc plots

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin
;
; The WRF ARW input file.  
; This needs to have a ".nc" appended, so just do it.
  a = addfile("/home/liyuan3970/Data/demo4_run2/wrfout_d02_2019-08-09_060000.nc","r")
  time =85
  num_lat = 62;floattoint((lat_real-lat0)/lato)
  num_lon = 85;floattoint((lon_real-lon0)/lono)

  cape2d = wrf_user_getvar(a,"cape_2d",time) 
  cape3d = wrf_user_getvar(a,"cape_3d",time) 
  height_agl =  wrf_user_getvar(a,"ter",time) 
  printVarSummary(height_agl)

; extract the data from the multi-dimensional fields
  cape  = cape3d(0,:,num_lat,num_lon)
  cin   = cape3d(1,:,num_lat,num_lon)
  mcape = cape2d(0,num_lat,num_lon)
  mcin  = cape2d(1,num_lat,num_lon)
  lcl   = cape2d(2,num_lat,num_lon)
  lfc   = cape2d(3,num_lat,num_lon)

  h = height_agl(num_lat,num_lon)
print(h)

print(lcl)

print(mcape)

print(cin)
end
