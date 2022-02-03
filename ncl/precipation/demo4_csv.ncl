
;----------------------------------------------------------------------
; contour1d_1.ncl
;----------------------------------------------------------------------
;
; Concepts illustrated:
;   - Reading an ASCII file with several columns of data
;   - Contouring one-dimensional X, Y, Z data
;   - Drawing lat/lon locations as filled dots using gsn_coordinates
;   - Comparing smooth contours with raster contours
;----------------------------------------------------------------------
; This example reads in station data represented by 1D arrays,
; 1D arrays, and generates a filled contour plot over a map.
;
; It uses a newer method (NCL V6.4.0 and later) for specifying the
; lat/lon information via special lat1d/lon1d attributes.
;
; See contour1d_old_1.ncl if you have an older version of NCL.
;----------------------------------------------------------------------
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
;
; Data is stored in four columns:  station_name  lat  lon  pwv
; Read in each line as a string, and use "str_get_field" to 
; read in the fields of interest.
;
  fname = "/home/liyuan3970/Typhoon_LMQ/notebooks/RR_region.csv"
  ;fname = "pw.dat"
  lines = asciiread(fname,-1,"string")
;
; Use "str_get_field" to indicate which fields to read in.
; Each field is separated by an arbitrary number of spaces.
;
  pwv       = tofloat(str_get_field(lines(0:),4,","))
  pwv = pwv/10.0
  pwv@lat1d = tofloat(str_get_field(lines(0:),2,","))  ; Attach as lat1d, lon1d
  pwv@lon1d = tofloat(str_get_field(lines(0:),3,","))  ; for plotting later
  pwv@_fillvalue = -999.9
  ;print(pwv)

  wks = gsn_open_wks("png",get_script_prefix_name())

  res                             = True
  res@gsnMaximize                 = True
  res@gsnFrame                    = False   ; Want to draw markers later.
  res@gsnDraw                     = False

  ;res@cnLevelSelectionMode        = "ManualLevels"
  ;res@cnMinLevelValF              = 10         	; 15.25
  ;res@cnMaxLevelValF              = 800		; 49.75
  ;res@cnLevelSpacingF             = 10

  res@cnFillOn                    = True
  res@cnLinesOn                   = False

  res@lbBoxLinesOn                = False

;---Zoom in on map area of interest
  res@mpMinLatF                   = 27.8;min(pwv@lat1d)-.5
  res@mpMinLonF                   = 120.4;min(pwv@lon1d)-.5
  res@mpMaxLatF                   = 29;max(pwv@lat1d)+.5
  res@mpMaxLonF                   = 121.5;max(pwv@lon1d)+.5

  res@mpFillOn                    = False
  ;res@pmTickMarkDisplayMode       = "Always"   ; nicer map tickmarks

;---Create the plot; it won't get drawn because gsnFrame was set to False.
  res@cnFillMode   = "AreaFill"    ; "AreaFill" is the default
  res@tiMainString = "GPS PWV (18Z) (smooth contours)"
  plot = gsn_csm_contour_map(wks,pwv,res)
    lnres                  = True
  lnres@gsLineColor      = "navyblue"
  lnres@gsFillColor      = "navyblue"
  lnres@gsLineThicknessF = 1.5
    lnres@minlat           = min(pwv@lat1d)-.5
  lnres@maxlat           = min(pwv@lon1d)-.5
  lnres@minlon           = max(pwv@lat1d)+.5
  lnres@maxlon           = max(pwv@lon1d)+.5
  shpfile = "/home/liyuan3970/Data/data/meto_data/geogphy_file/"
  dum = gsn_add_shapefile_polylines(wks,plot,shpfile+"zhejiang.shp",lnres)

;---Add some markers to show where the original 1D points are.
  mkres               = True
  mkres@gsMarkerIndex = 16    ; Filled dots
  ;gsn_coordinates(wks,plot,pwv,mkres)

;---Create the plot again using raster contours
  res@cnFillMode   = "RasterFill"
  res@tiMainString = "GPS PWV (18Z) (raster contours)"
  ;plot = gsn_csm_contour_map(wks,pwv,res)
  ;gsn_coordinates(wks,plot,pwv,mkres)
 draw(plot)
 frame(wks)
end 
















