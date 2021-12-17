
;   Example script to produce cape/cin/lcl/lfc plots

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin
;
; The WRF ARW input file.  
; This needs to have a ".nc" appended, so just do it.
  a = addfile("/home/liyuan3970/Data/demo4_run2/wrfout_d02_2019-08-09_060000.nc","r")

; We generate plots, but what kind do we prefer?
  ;type = "x11"
 type = "pdf"
 ;type = "png"
; type = "ncgm"
  wks = gsn_open_wks(type,"plt_cape")
  gsn_define_colormap(wks,"WhViBlGrYeOrReWh")

; Set some basic resources
  res = True
  res@MainTitle                   = "REAL-TIME WRF"

  pltres = True
  mpres = True
  mpres@mpGeophysicalLineColor = "Black"
  mpres@mpNationalLineColor    = "Black"
  mpres@mpUSStateLineColor     = "Black"
  mpres@mpGridLineColor        = "Black"
  mpres@mpLimbLineColor        = "Black"
  mpres@mpPerimLineColor       = "Black"
  mpres@mpGridSpacingF         = 10


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Which times and how many time steps are in the data set?
  times = wrf_user_getvar(a,"times",-1)  ; get all times in the file
  ntimes = dimsizes(times)         ; number of times in the file
  print(ntimes)


  it = 85;ntimes-1                    ; only interested in last time
  res@TimeLabel = times(it)        ; set Valid time to use on plot

  cape2d = wrf_user_getvar(a,"cape_2d",it) 
  cape3d = wrf_user_getvar(a,"cape_3d",it) 
  ;printVarSummary(cape2d)

; extract the data from the multi-dimensional fields
  cape  = cape3d(0,:,:,:)
  cin   = cape3d(1,:,:,:)

  f = addfile("cape.nc", "c")
  f->cape = cape
  f->cin = cin

  printVarSummary(cin)
  mcape = cape2d(0,:,:)
  mcin  = cape2d(1,:,:)
  lcl   = cape2d(2,:,:)
  lfc   = cape2d(3,:,:)
  f->lcl = lcl
  f->lfc = lfc 

  opts = res                         
  opts@cnFillOn = True  
  opts@cnLineLabelsOn = False
 

  opts@FieldTitle = "mcape"
  opts@ContourParameters = (/ 500., 3000., 250./)
  contour = wrf_contour(a,wks,mcape,opts)
  plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)


  opts@FieldTitle = "mcin"
  opts@ContourParameters = (/ 0., 125., 25./)
  contour = wrf_contour(a,wks,mcin,opts)
  plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)


  opts@FieldTitle = "lfc"
  opts@ContourParameters = (/ 200., 3800., 400./)
  contour = wrf_contour(a,wks,lfc,opts)
  plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)


  opts@FieldTitle = "lcl"
  opts@ContourParameters = (/ 200., 3800., 400./)
  contour = wrf_contour(a,wks,lcl,opts)
  plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)


  opts@FieldTitle = "cape"
  opts@ContourParameters = (/ 250., 3250., 250./)
  do il = 0,9                                   ; only interested in the first 10 levels
    ilev = il + 1
    opts@PlotLevelID = "level " + ilev
    contour = wrf_contour(a,wks,cape(il,:,:),opts)
    plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
  end do


  opts@FieldTitle = "cin"
  opts@ContourParameters = (/ 0., 300., 25./)
  do il = 0,9                                   ; only interested in the first 10 levels
    ilev = il + 1
    opts@PlotLevelID = "level " + ilev
    contour = wrf_contour(a,wks,cin(il,:,:),opts)
    plot = wrf_map_overlays(a,wks,(/contour/),pltres,mpres)
  end do

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

end
