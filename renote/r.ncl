begin
;>---------------------------------------<
;            data　input
;>---------------------------------------<


time = "2019081006"
;; time3 图片没有
wks = gsn_open_wks("png",time)
f = addfile("/home/liyuan3970/Data/demo4_run2/ecmwf.nc", "r")
hgt = f->z(49,{500}, :, :) 



u = f->u(49:,{850},:,:) * 2.5

v = f->v(49:,{850},:,:) * 2.5

q = f->q(49:,{850},:,:) 

rh = f->r(49:,{850},:,:) 
; t = f->TMP_P0_L100_GLL0({85000}, :, :)
; u1 = f->UGRD_P0_L100_GLL0({85000}, :, :) ;*2.5
; v1 = f->VGRD_P0_L100_GLL0({85000}, :, :) ;*2.5
; p =850

; ;计算水汽通亮
; q1 = mixhum_ptrh(conform(rh,p,0),t,rh,-2)
; copy_VarCoords(rh, q1)

; ;计算水汽通量
qu1 = q * u
qv1 = q * v
; copy_VarCoords(rh, qu1)
; copy_VarCoords(rh, qv1)
qabs = wind_speed(qu1, qv1)
copy_VarCoords(rh,qabs)

; ;计算水汽通量散度
qduv = uv2dvF_Wrap(qu1,qv1)
;qduv =abs(qduv *10000)
copy_VarCoords(rh, qduv)



a = rh({time|:},{latitude|15:30},{longitude|110:130})
printVarSummary(a)
x =  f->time(49:)

y = dim_avg_n(a,(/1,2/))
; y = dim_avg_n(qabs,(/1,2/))

wks = gsn_open_wks("png","curve") ;创建工作台

plot = gsn_xy(wks,x,y,False)

end

