begin
    
file_path="/home/liyuan3970/Typhoon_LMQ/notebooks/RR_region_taizhou.csv"
data=asciiread(file_path, (/305,4/), "float")
station=data(:,0)       ;读入站点号
lat=data(:,1)           ;读入纬度
lon=data(:,2)           ;读入经度
RR=data(:,3)
RR@_FillValue=-9999   ;在数据说明里说了气温的缺测值是32766
print(lat)
print(max(lat))
print(max(lon))
print(min(lat))
print(min(lon))
filepath = "/home/liyuan3970/Data/data/meto_data/geogphy_file/"
olon=fspan(120,122,132);设置插值范围及格点数，即空间分辨率
olat=fspan(28.0,29.3,80)

olon!0         = "lon"
olon@long_name  = "lon"
olon@units     = "degrees-east"
olon&lon       = olon
olat!0         = "lat"
olat@long_name  = "lat"
olat@units     = "degrees_north"
olat&lat       = olat

rscan = (/10,5,3/)  ;连续的有效半径大小，最大为10，依次递减
RR_reshape = obj_anal_ic_deprecated(lon,lat,RR,olon,olat,rscan, False)  ;Creanm插值
printVarSummary(RR_reshape)


    wks=gsn_open_wks("png","plot_obj")
    ;gsn_define_colormap(wks,cmap)      ; 
    res=True
    res@gsnAddCyclic=False             ;如果设置为真，则循环点被加入数据，如果数据不是循环的，就设置为假就可以。
    res@mpDataBaseVersion = "Ncarg4_1";网上的那个代码里没有这句，害我折腾了好久才明白
    res@mpDataSetName="Earth..4"       ;中国地图包含在这个叫Earth..4的地图库里
    res@mpOutlineOn=True
    res@mpOutlineSpecifiers=(/"China:states","Taiwan"/)
    res@mpGeophysicalLineThicknessF=2.0 ;这两行是为了加粗边界和国界线
    res@mpNationalLineThicknessF=2.0
    res@mpMinLatF=27.1
    res@mpMaxLatF=31.1
    res@mpMinLonF=118.4
    res@mpMaxLonF=122.9
 
    res@mpDataBaseVersion = "Ncarg4_1"
    res@mpAreaMaskingOn = True   ;使能填充覆盖
    res@mpMaskAreaSpecifiers = (/"China:states","Taiwan"/)
    res@mpOceanFillColor=0
    res@mpInlandWaterFillColor=0
 
    res@cnFillOn=True;画填充图
    res@cnLinesOn=False;不画等值线
    res@cnLineLabelsOn=False;不要等值线上的标签
    res@cnFillDrawOrder="PreDraw";先画填充
    ;---Attach rivers from shapefile
  lnres                  = True
  lnres@gsLineColor      = "navyblue"
  lnres@gsFillColor      = "navyblue"
  lnres@gsLineThicknessF = 1.5

;---Setting lat/lon limits helps drawing go faster
  lnres@minlat           = 27.1
  lnres@maxlat           = 31.1
  lnres@minlon           = 118.4
  lnres@maxlon           = 122.9

  
map=gsn_csm_contour_map(wks,RR_reshape,res)
;dum = gsn_add_shapefile_polylines(wks,map,filepath+"taizhou.shp",lnres)
















end