;----------------------------------------------------------------------
; topo_8.ncl
;
; Concepts illustrated:
;   - Drawing a topographic map of Colorado using 2' data
;   - Zooming in on a topographic map
;   - Using shapefile data to draw rivers of Colorado
;   - Using "MeshFill" for faster contouring
;   - Using cnFillPalette to assign a color palette to contours
;----------------------------------------------------------------------
; The shapefile containing rivers of U.S was downloaded from
;   http://www.nws.noaa.gov/geodata/catalog/hydro/html/rivers.htm
;----------------------------------------------------------------------
;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

;----------------------------------------------------------------------
; This function creates a topo map using a 2' topographic file read in
; from a NetCDF file, and map limits read in from a WRF output file.
;----------------------------------------------------------------------
undef("create_topo_map")
function create_topo_map(wks,minlat,maxlat,minlon,maxlon)
local topo_file, a, elev, res, cmap
begin
;---Subsetting the data is not necessary, but it will make plotting go much faster.
  shpfile = "/home/liyuan3970/Data/data/meto_data/geogphy_file/"
  topo_file = shpfile+"ETOPO1_Bed_g_gmt4.grd.nc"
  a         = addfile(topo_file,"r")
  elev      = a->z({minlat:maxlat},{minlon:maxlon})

;---Will use this later for coloring the contours
  cmap = read_colormap_file("OceanLakeLandSnow")

;---Set some resources for contouring and mapping
  res                    = True

  res@gsnMaximize        = True         ; maximize plot in frame

  res@gsnDraw            = False
  res@gsnFrame           = False

  res@cnFillOn           = True         ; turn on contour fill
  res@cnFillMode         = "MeshFill"   ; for faster draw
  res@cnFillPalette      = cmap(2:,:)
 
  res@cnLinesOn          = False        ; turn off contour lines
  res@cnLineLabelsOn     = False        ; turn off line labels
  res@cnInfoLabelOn      = False        ; turn off info label
  res@lbBoxLinesOn       = False        ; turn off labelbar box lines
  res@lbTitleString      = "elevation (meters)"    ; add a labelbar title
  res@lbTitleFontHeightF = 0.015
  res@lbTitlePosition    = "Bottom"
  res@pmLabelBarOrthogonalPosF = 0.15

;---Pick "nice" contour levels
  mnmxint = nice_mnmxintvl( min(elev), max(elev), 18, False)
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = mnmxint(0)
  res@cnMaxLevelValF       = mnmxint(1)
  res@cnLevelSpacingF      = mnmxint(2)/8.   ; Increase the number of levels 
                                             ; by choosing a smaller spacing.
;---Zoom in on map
  res@mpMinLatF            = minlat
  res@mpMaxLatF            = maxlat
  res@mpMinLonF            = minlon
  res@mpMaxLonF            = maxlon
  res@mpCenterLonF         = (res@mpMinLonF + res@mpMaxLonF) / 2.

  res@mpDataBaseVersion    = "MediumRes"

  res@mpFillOn             = False
  res@mpOutlineOn          = False
  res@mpOutlineBoundarySets = "AllBoundaries"
  res@gsnAddCyclic         = False           ; don't add longitude cyclic point

  res@tiMainString          = "Geographic height of Zhejiang"
  res@gsnLeftString         = ""
  res@gsnRightString        = ""
  res@pmTickMarkDisplayMode = "Always"
  res@pmTitleZone           = 4              ; move main title down a little

;---Create map and return it.

  plot = gsn_csm_contour_map(wks,elev,res)
  return(plot)
end







begin 
f = addfile("pre3.nc", "r")
r = f->pre


printVarSummary(r)

    wks=gsn_open_wks("png","RR_plot")
    ;gsn_define_colormap(wks,cmap)      ; 
    res=True
    res@gsnAddCyclic=False             ;如果设置为真，则循环点被加入数据，如果数据不是循环的，就设置为假就可以。
    ;res@mpDataBaseVersion = "Ncarg4_1";网上的那个代码里没有这句，害我折腾了好久才明白
    ;res@mpDataSetName="Earth..4"       ;中国地图包含在这个叫Earth..4的地图库里
   ; res@mpOutlineOn=True
    ;res@mpOutlineSpecifiers=(/"China:states","Taiwan"/)
    ;res@mpGeophysicalLineThicknessF=2.0 ;这两行是为了加粗边界和国界线
    ;res@mpNationalLineThicknessF=2.0
    ;res@mpMinLatF=27.1
    ;res@mpMaxLatF=31.1
    ;res@mpMinLonF=118.4
    ;res@mpMaxLonF=122.9
 
    ;res@mpDataBaseVersion = "Ncarg4_1"
    ;res@mpAreaMaskingOn = True   ;使能填充覆盖
    ;res@mpMaskAreaSpecifiers = (/"China:states","Taiwan"/)
    ;res@mpOceanFillColor=0
    ;res@mpInlandWaterFillColor=0
 
    ;res@cnFillOn=True;画填充图
    res@cnFillOn=False;画填充图
    ;res@cnLinesOn=False;不画等值线
    res@cnLinesOn=True;不画等值线
    res@cnLineThicknessF = 8
    res@cnLineLabelsOn=True;不要等值线上的标签
    ;res@cnFillDrawOrder="PreDraw";先画填充
    ;res@cnLevelSelectionMode = "ManualLevels"\
    res@cnLevelSelectionMode = "ExplicitLevels"
    res@cnLevels = (/100,200,300/)
    ;res@cnLevelSpacingF      = 100
    ;res@cnMinLevelValF       = 100
    ;res@cnMaxLevelValF       = 300
    ;res@cnFillColors = (/128,118,98,88,78,68,58,48,38,28,18/)
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

;---Lat/lon limits for Colorado
  minlat   = 27.1
  maxlat   = 31.3
  minlon   = 118
  maxlon   = 123

;---Create topo map of Colorado
map = create_topo_map(wks,minlat,maxlat,minlon,maxlon)
plot=gsn_csm_contour(wks,r,res)
overlay(map, plot)

dum = gsn_add_shapefile_polylines(wks,map,"/home/liyuan3970/Typhoon_LMQ/data/ncl/shp_demo/zhejiang.shp",lnres)
draw(map)
frame(wks)



end