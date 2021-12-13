;**********************************************************
  load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
  load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
  load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;  load "$NCARG_ROOT/lib/ncarg/nclscripts/cnmap/cnmap.ncl"
;**********************************************************




begin
 begTime = get_cpu_time()
 diri_constant= "/home/liyuan3970/Data/demo4_run2/"
 a  = addfile(diri_constant + "wrfout_d02_2019-08-09_06:00:00.nc","r")
 lon2d = a->XLONG(0,:,:)
 lat2d = a->XLAT(0,:,:)
 lat = lat2d(:,0)              ;; Xarray of latitudes
 lon = lon2d(0,:)              ;; Xarray of Longitudes
 times = wrf_user_list_times(a)


 ;minLat = min(lat)
 ;maxLat = max(lat)
 ;minLon = min(lon)
 ;maxLon = max(lon)

 minLat = 28.3
 maxLat = 29.0
 minLon = 120.6
 maxLon = 121.5
 
 ;calculate the total precipitation
 rain1 = wrf_user_getvar(a,"RAINNC",-1)
 rain2 = wrf_user_getvar(a,"RAINC",-1)
 rain3 = wrf_user_getvar(a,"RAINSH",-1)
printVarSummary(rain1)

 dim_sizes=dimsizes(rain1)
 NT = dim_sizes(0)
 NY = dim_sizes(1)
 NX = dim_sizes(2)


 ;deltaRain1 = rain1(NT-1,:,:) - rain1(0,:,:)
 ;deltaRain2 = rain2(NT-1,:,:) - rain2(0,:,:)
 ;deltaRain3 = rain3(NT-1,:,:) - rain3(0,:,:)
 deltaRain1 = rain1(115,:,:) - rain1(65,:,:)
 deltaRain2 = rain2(115,:,:) - rain2(65,:,:)
 deltaRain3 = rain3(115,:,:) - rain3(65,:,:)
 rain_tot   = deltaRain1 + deltaRain2 + deltaRain3


 delete(rain1)
 delete(rain2)
 
 rain_tot!0 = "lat"
 rain_tot!1 = "lon"
 rain_tot&lat = lat
 rain_tot&lon = lon
 rain_tot@description = "Precipitation"
 rain_tot@units = "mm"
 
 ; create a window
 fig_name = "precipitaion_"+times(60)+"-"+times(120)+"UTC.png"
 wks = gsn_open_wks("png",fig_name)


 ;define colormap
 cmap =  (/ (/255, 255, 255/), \
            (/0, 0,0/), \
            (/242, 255, 255/), \
            (/242, 242, 242/), \
            (/154, 192, 205/), \
            (/178, 223, 238/), \
            (/191, 239, 255/), \
            (/  0, 235, 235/), \
            (/  0, 163, 247/), \
            (/  0, 255,   0/), \
            (/  0, 199,   0/), \
            (/  0, 143,   0/), \
            (/  0,  63,   0/), \
            (/255, 255,   0/), \
            (/255, 143,   0/), \
            (/255,   0,   0/), \
            (/215,   0,   0/), \
            (/191,   0,   0/), \
            (/255,   0, 255/), \
            (/155,  87, 203/), \
            (/ 92,  52, 176/) /) /255.0


 gsn_define_colormap(wks,cmap)
 ;gsn_define_colormap(wks,"Rainbow")


 res = True
 res@gsnDraw       = False
 res@gsnFrame      = False
 res@gsnAddCyclic  = False
 res@mpFillOn      = False


 res@mpMaxLatF = maxLat                      ; specify the plot domain
 res@mpMinLatF = minLat                      ;
 res@mpMaxLonF = maxLon                      ;
 res@mpMinLonF = minLon
 res@tiMainString = "Precipitation: "+times(0)+" to "+times(NT-1)+"UTC"
 res@tiMainFontHeightF = 0.013
 res@gsnLeftStringFontHeightF  = 0.012
 res@gsnRightStringFontHeightF = 0.012
 
 res@cnLevelSelectionMode = "ManualLevels"
 res@cnLevelSpacingF      = 10
 res@cnMinLevelValF       = 0
 res@cnMaxLevelValF       = 150


 res@cnFillOn = True
 res@cnLinesOn = False
 res@lbLabelAutoStride = True
 res@cnFillDrawOrder = "PreDraw"
 res@cnInfoLabelOn = False
 
 res@lbLabelBarOn          = True        ; 色标
 res@pmLabelBarHeightF     = 0.15
 res@pmLabelBarWidthF      = 0.6
 res@pmLabelBarOrthogonalPosF = 0.07
 res@lbLabelFontHeightF    = 0.010
 res@cnInfoLabelOn         = False            ; 去掉图底端的标签信息
 
lon_value = fspan(minLon, maxLon, 5)
 lon_label = lon_value + "~S~o~N~E"
 res@tmXBMode = "Explicit"
 res@tmXBValues = lon_value
 res@tmXBLabels = lon_label
 res@tmXBLabelFontHeightF = 0.01
 lat_value = fspan(minLat, maxLat , 5)
 lat_label = lat_value + "~S~o~N~N"
 res@tmYLValues = lat_value
 res@tmYLLabels = lat_label
 ;; plot
 plot  = gsn_csm_contour_map(wks,rain_tot,res)



 ; add China map
 cnres           = True
 cnres@china     = True       ;draw china map or not
 cnres@river     = False       ;draw changjiang&huanghe or not
 cnres@province  = True      ;draw province boundary or not
 cnres@nanhai    = False       ;draw nanhai or not
 cnres@diqu      = True       ; draw diqujie or not
 ;chinamap = add_china_map(wks,plot,cnres)


;---Lat/lon limits for Colorado
;  minlat   = 27.1
;  maxlat   = 31.3
 ; minlon   = 118
 ; maxlon   = 123

;---Create topo map of Colorado
  ;topo_map = create_topo_map(wks,minlat,maxlat,minlon,maxlon)

;---Attach rivers from shapefile
  lnres                  = True
  lnres@gsLineColor      = "navyblue"
  lnres@gsFillColor      = "navyblue"
  lnres@gsLineThicknessF = 1.5

;---Setting lat/lon limits helps drawing go faster
  lnres@minlat           = minLat
  lnres@maxlat           = maxLat
  lnres@minlon           = minLon
  lnres@maxlon           = maxLon
  shpfile = "/home/liyuan3970/Data/data/meto_data/geogphy_file/"
  dum = gsn_add_shapefile_polylines(wks,plot,shpfile+"zhejiang.shp",lnres)


printVarSummary(rain_tot)

 draw(plot)
 frame(wks)
 print("Time Required " + (get_cpu_time() - begTime) + " seconds")
end

