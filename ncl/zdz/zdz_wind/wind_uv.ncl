begin
filepath = "/home/liyuan3970/3DVAR_retrive_radar_wind_from_typhoon1909/ncl/zdz/zdz_wind/"
; data=asciiread(filepath+"wind_0809_23.csv", (/2932,7/), "float")


lines  = asciiread (filepath+"wind_0809_23.csv", -1, "string")
strs   = str_split_csv (lines, ",", 0) 
strs@_FillValue = -9999.0   
;nums   = tofloat (strs) 


lat=tofloat (strs(:,1)  )         ;读入纬度
lon=tofloat (strs(:,2)   )        ;读入经度
wspd=tofloat (strs(:,5) )  /10.0     ;
wdir=tofloat (strs(:,6) )  ;
wspd@_FillValue = -9999.0 
wdir@_FillValue = -9999.0 


uv = wind_component(wspd, wdir, 0)

u = uv(0,:)
v = uv(1,:)

u@_FillValue = -9999.0 
v@_FillValue = -9999.0 




olon=fspan(118,123,132);设置插值范围及格点数，即空间分辨率
olat=fspan(27.1,31.2,80)
olon!0         = "lon"
olon@long_name  = "lon"
olon@units     = "degrees-east"
olon&lon       = olon
olat!0         = "lat"
olat@long_name  = "lat"
olat@units     = "degrees_north"
olat&lat       = olat

rscan = (/2,1,0.15/)  ;连续的有效半径大小，最大为10，依次递减

u_shape = obj_anal_ic_deprecated(lon,lat,u,olon,olat,rscan, False)

v_shape = obj_anal_ic_deprecated(lon,lat,v,olon,olat,rscan, False)



dv=uv2dv_cfd (u_shape,v_shape,olat,olon, 3)
copy_VarCoords(u_shape,dv)



fo = addfile("zdz_dv.nc","c")
fo->dv = dv
printVarSummary(dv)














end