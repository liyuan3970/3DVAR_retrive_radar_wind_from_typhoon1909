begin
;filepath = "/home/liyuan3970/Data/data/meto_data/radar_typhoon_liqima/wenzhou_rada/15-19/"
filepath = "/home/liyuan3970/3DVAR_retrive_radar_wind_from_typhoon1909/ncl/zdz/zdz_wind/"
files= systemfunc (" ls -1 " + filepath + "*.nc")
f = addfiles(files, "r")
ListSetType(f, "join")
dv =f[:]->dv



f0 = addfile("dv_all.nc","c")
f0->dv = dv






printVarSummary(dv)
;print(files)

end