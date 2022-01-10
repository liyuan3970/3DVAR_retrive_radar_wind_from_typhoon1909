begin



filepath = "/workspace/liyuan3970/Data/data/meto_data/radar_typhoon_liqima/wenzhou_rada/15-19/"
files= systemfunc (" ls -1 " + filepath + "*.nc")


;f = addfile(files(0), "r")
;f = addfiles(files, "r")


;print(f)


outpath = "/workspace/liyuan3970/Data/data/meto_data/radar_typhoon_liqima/wenzhou_rada/dv/"

n = dimsizes(files)
do i = 0, n ,1
f = addfile(files(i), "r")
name = files(i)
name_all = stringtochar(files(i))
name = name_all(97:110)
u =f->u
v =f->v
printVarSummary(u)
lat =f->lat
lon =f->lon
dv=uv2dv_cfd (u,v,lat,lon, 3)
copy_VarCoords(u, dv)
printVarSummary(dv)

f1 = addfile(outpath+name+".nc","c")
dv_c = dv(0,:,:,:)
copy_VarCoords(u(0,:,:,:), dv_c)
printVarSummary(dv_c)
f1->dv = dv_c

end do
end