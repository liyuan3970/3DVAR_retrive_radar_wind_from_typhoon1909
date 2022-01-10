begin
file_path="/home/liyuan3970/Typhoon_LMQ/notebooks/RR_region.csv"
data=asciiread(file_path, (/3051,4/), "float")
station=data(:,0)       ;读入站点号
lat=data(:,1)           ;读入纬度
lon=data(:,2)           ;读入经度
RR=data(:,3)
RR@_FillValue=-9999   ;在数据说明里说了气温的缺测值是32766


RR_max=max(RR)
RR_min=min(RR)


olon=fspan(118,123,132);设置插值范围及格点数，即空间分辨率
olat=fspan(27.1,31.2,80)




RR_2d = new((/3051,3051/), "float")
do i =0,3050
    ;print(i)
    RR_2d(i,:) = RR
end do
RR_reshape = linint2_Wrap(lon,lat,RR_2d,False,olon,olat,0) 


olon!0         = "lon"
olon@long_name  = "lon"
olon@units     = "degrees-east"
olon&lon       = olon
olat!0         = "lat"
olat@long_name  = "lat"
olat@units     = "degrees_north"
olat&lat       = olat

RR_reshape!0 = "lat"
RR_reshape@long_name  = "lat"

RR_reshape&lat        = olat

RR_reshape!1 = "lon"
RR_reshape@long_name  = "lon"

RR_reshape&lon        = olon

print(RR_2d)



fo = addfile("data/linintl.nc","c")
fo ->rr = RR_reshape



;;;;;;;;;;;;;测试数据s

;print(RR_max)
;print(RR_min)
; print(typeof(RR))
; print(RR)
; print(olon)
printVarSummary(RR_2d)

end