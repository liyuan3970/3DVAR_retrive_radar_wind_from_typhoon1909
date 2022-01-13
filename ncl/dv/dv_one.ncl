begin
;filepath = "/home/liyuan3970/Data/data/meto_data/radar_typhoon_liqima/wenzhou_rada/15-19/"
filepath = "/home/liyuan3970/Data/data/meto_data/radar_typhoon_liqima/wenzhou_rada/dv/"
files= systemfunc (" ls -1 " + filepath + "*.nc")
print(files)
f = addfiles(files, "r")
ListSetType(f, "join")
dv =f[:]->dv
printVarSummary(dv)
f0 = addfile("dv_all.nc","c")
f0->dv = dv
outpath = "/home/liyuan3970/Data/data/meto_data/radar_typhoon_liqima/wenzhou_rada/dv/"
end