begin


filepath = "/home/liyuan3970/Data/demo4_run2/"

ncfile = addfile(filepath +"wrfout_d02_2019-08-09_060000.nc","r")

time = 60


;ua  = wrf_user_getvar(f,"ua",time) 


theta =  wrf_user_getvar(ncfile, "eth",time)
QVAPOR = wrf_user_getvar(ncfile, "QVAPOR",time)
tk =  wrf_user_getvar(ncfile, "tk",time)
height = wrf_user_getvar(ncfile, "height",time)
pressure = wrf_user_getvar(ncfile, "pressure",time)
u = wrf_user_getvar(ncfile, "ua",time)
v = wrf_user_getvar(ncfile, "va",time)



thse=theta*exp(2.5e6*QVAPOR/1004/tk)
rou=pressure*1.e2/(9.8*height*1.e3)




copy_VarCoords(u, thse)  
copy_VarCoords(u, rou)  




ro=(rou(2,:,:)+rou(3,:,:))/2
dth=thse(2,:,:)-thse(3,:,:)
the=(thse(2,:,:)+thse(3,:,:))/2
du=u(2,:,:)-u(3,:,:)
dv=v(2,:,:)-v(3,:,:)
Ri=-dth*3.5e5/(the*(du*du+dv*dv)*ro)
printVarSummary(Ri)
end 