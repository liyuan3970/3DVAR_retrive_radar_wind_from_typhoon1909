begin

;filepath = "/workspace/liyuan3970/Data/data/meto_data/radar_typhoon_liqima/wenzhou_rada/out/"

;file = "Z_RADR_I_Z9577_20190809163500_O_DOR_SA_CAP.bin.bz2.nc"

;f = addfile("/workspace/liyuan3970/Data/data/meto_data/radar_typhoon_liqima/wenzhou_rada/out/Z_RADR_I_Z9577_20190809163500_O_DOR_SA_CAP.bin.bz2.nc", "r")
f = addfile("/workspace/liyuan3970/Data/data/meto_data/radar_typhoon_liqima/wenzhou_rada/out/Z_RADR_I_Z9577_20190809174200_O_DOR_SA_CAP.bin.bz2.nc", "r")

;print(f)
u =f->u
v =f->v
lat =f->lat
lon =f->lon
dv=uv2dv_cfd (u,v,lat,lon, 3)

printVarSummary(dv)

f1 = addfile("dv_1.nc","c")
dv_c = dv(0,:,:,:)
copy_VarCoords(u(0,:,:,:), dv_c)
printVarSummary(dv_c)
f1->dv = dv_c
end