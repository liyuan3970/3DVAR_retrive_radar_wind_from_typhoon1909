;**************************************************
; skewt_10.ncl
;
; Concepts illustrated:
;   - Read from WRF netCDF and extracting necessary variables
;   - Using 'wrf_user_ll_to_ij' get indices (subscripts) near specified location
;   - Using NCL's 'wind_component' to convert wind speed and direvtion to u,v
;   - Adjusting the fortran 1-based subscripts to NCL 0-based subscripts 
;   - Plotting a hodograph onto a skew-T plot
;**************************************************
; Author: Joesph Grim
;         Project Scientist
;         Aviation Applications Program
;         Research Application Laboratory 
;**************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/skewt_func.ncl"

begin
;---Set parameters

 snd_lat =  28.7     ; latitude of model profile
 snd_lon = 120.9     ; longitude of model profile
 hodo_top_pres = 150. ; top of hodograph in hPa

 in_dir  = "/home/liyuan3970/Data/demo4_run2/"
 in_file = "wrfout_d02_2019-08-09_060000.nc"  ; WRF output file

;---Read in WRF data

 in_path    = in_dir + in_file                   
 ncdf_in    = addfile(in_path+".nc","r")             ; add .nc extension      

 time = 85
 P_tot      = wrf_user_getvar(ncdf_in,"pressure",time)  ; model 3D pressure
 z_tot      = wrf_user_getvar(ncdf_in,"z",time)        ; model 3D height
 uvmet      = wrf_user_getvar(ncdf_in,"uvmet",time)    ; Earth-relative U and V winds on mass points
 printVarSummary(uvmet)
 U          = uvmet(0,:,:,:)                       ; Earth-relative U wind on mass points
 V          = uvmet(1,:,:,:)                       ; Earth-relative V wind on mass points
 TC         = wrf_user_getvar(ncdf_in,"tc",time)       ; model temperature in Celsius
 TD         = wrf_user_getvar(ncdf_in,"td",time)       ; model dewpoint in Celsius

;---Calculate coordinates of hodograph grid circles

 circle_rad   = ispan(20,240,20)                     ; hodograph grid circle radii
 n_circle_rad = dimsizes(circle_rad)
 circle_deg   = ispan(0,360,2)                       ; points 360 deg around hodograph circle
 n_deg        = dimsizes(circle_deg)
 cir_x_pts    = new((/n_circle_rad,n_deg/),"float")  ; x coordinates for hodograph circles
 cir_y_pts    = new((/n_circle_rad,n_deg/),"float")  ; y coordinates for hodograph circles

 do cc=0,n_deg-1                                         ; loop through all degrees in circle
  do dd=0,n_circle_rad-1                                 ; loop through all radii
   uv = wind_component(circle_rad(dd),circle_deg(cc),0)  ; calculate x,y coordinates using wind_component fx
   cir_x_pts(dd,cc) = uv(0,0)                            ; x coordinates are in index 0
   cir_y_pts(dd,cc) = uv(1,0)                            ; y coordinates are in index 1
  end do
 end do

;---Determine the model i,j indices for the given lat/lon

 loc = wrf_user_ll_to_ij(ncdf_in,snd_lon,snd_lat,True)  ; model i,j indices for the given lat/lon
 locX = loc(0) - 1                           ; subtract 1, since WRF is base 1, but NCL is base 0
 locY = loc(1) - 1                           ; subtract 1, since WRF is base 1, but NCL is base 0

;***********************
;---Begin to create plot
;***********************
 PlotType = "png"
;PlotName = "skewT_hodograph"
 PlotName = "skewt"

 PlotType@wkWidth  = 800     ; large  
 PlotType@wkHeight = 800 

 wks = gsn_open_wks(PlotType,PlotName)                   ; open workstation

;---Draw skewT background
 skewtOpts          = True
 skewtOpts@DrawColLine       = True    ; draw background lines in color, (False for all black lines)
 skewtOpts@DrawFahrenheit    = False   ; True for deg F, False for deg C
 skewtOpts@tiMainString      = "Sounding at "+snd_lat+","+snd_lon+": "+in_file
 skewtOpts@tiMainFontHeightF = 0.0155

 skewtOpts@vpHeightF         = 0.85    ; controls height of plot
 skewtOpts@vpWidthF          = 0.85    ; controls width of plot
 skewtOpts@vpXF              = 0.07    ; controls off-set from left
 skewtOpts@vpYF              = 0.92    ; controls off-set from top
 skewt_bkgd                  = skewT_BackGround (wks, skewtOpts)

;---Draw a blank square where the hodograph will go

 poly_res = True
 poly_res@gsFillColor = "white"    ; set fill color to white
 gsn_polygon (wks,skewt_bkgd,(/-19.,-5.5,-5.5,-19.,-19./),(/44.,44.,30.75,30.75,44./),poly_res)

;---Draw hodograph

 hodo_max = 10.*ceil(0.1*(max((/max(abs(U(:,locY,locX))),max(abs(V(:,locY,locX)))/))))+10.  ; determine max wind level for hodograph plot
 hodo_top_ind = max(ind(P_tot(:,locY,locX).ge.hodo_top_pres))  ; index of topmost model pressure level to plot hodograph winds
 hodo_res = True
 hodo_res@gsnDraw          = False          ; don't draw yet
 hodo_res@gsnFrame         = False          ; dont' advance frame
 hodo_res@tiXAxisOn        = False          ; turn off x axis label
 hodo_res@tiYAxisOn        = False          ; turn off y axis label
 hodo_res@tmXBOn           = False          ; turn off tick marks on bottom x axis
 hodo_res@tmXTOn           = False          ; turn off tick marks on top x axis
 hodo_res@tmYLOn           = False          ; turn off tick marks on left y axis
 hodo_res@tmYROn           = False          ; turn off tick marks on right y axis
 hodo_res@trXMaxF          = hodo_max       ; set maximum U value for hodograph
 hodo_res@trXMinF          = -hodo_max      ; set minimum U value for hodograph
 hodo_res@trYMaxF          = hodo_max       ; set maximum V value for hodograph
 hodo_res@trYMinF          = -hodo_max      ; set minimum V value for hodograph
 hodo_res@vpHeightF        = 0.25           ; set the height of the hodograph sub-plot
 hodo_res@vpWidthF         = 0.25           ; set the width of the hodograph sub-plot
 hodo_res@vpXF             = skewtOpts@vpXF ; offset must be same as skewtOpts@vpXF
 hodo_res@vpYF             = skewtOpts@vpYF ; offset must be same as skewtOpts@vpYF
 hodo_res@xyLineThicknessF = 5              ; set hodograph line thickness
  ; plot hodograph only up to 'hodo_top_pres' pressure level
 hodo_plot = gsn_csm_xy(wks,U(0:hodo_top_ind-1,locY,locX),V(0:hodo_top_ind-1,locY,locX),hodo_res)
 draw(hodo_plot)

;---Draw hodograph grid circles
 cir_res = True
 cir_res@gsLineColor = "black"  ; hodograph circle line color
 n_hodo_cir          = dimsizes(ind(circle_rad.le.hodo_max))  ; numbercircles to draw 
                                                              ; depends on max wind speed
 do dd=0,n_hodo_cir-1  ; loop through all circles to draw
  gsn_polyline(wks,hodo_plot,cir_x_pts(dd,:),cir_y_pts(dd,:),cir_res)
 end do

;---Draw hodograph grid circle labels
 lbl_res = True
 lbl_res@txFontColor  = "black"  ; label color
 lbl_res@txFontHeightF = 0.01    ; label font height
 do dd=0,n_hodo_cir-1            ; loop through all hodograph circles
  gsn_text(wks,hodo_plot,sprinti("%0.1i",circle_rad(dd)),cir_x_pts(dd,n_deg*3/8),cir_y_pts(dd,n_deg*3/8),lbl_res)
 end do

;--- Put "+" sign in middle of hodograph
 mrk_res = True
 mrk_res@gsMarkerColor      = "black"  ; make marker black
 mrk_res@gsMarkerIndex      = 2        ; select marker index
 mrk_res@gsMarkerSizeF      = 0.007    ; marker size
 mrk_res@gsMarkerThicknessF = 1.       ; marker line thickness
 gsn_polymarker(wks,hodo_plot,0.,0.,mrk_res)

;---Put an 'x' to mark lowest profile level
 mrk_res@gsMarkerIndex = 5      ; set marker type
 mrk_res@gsMarkerSizeF = 0.007  ; set marker size
 gsn_polymarker(wks,hodo_plot,U(0,locY,locX),V(0,locY,locX),mrk_res)

; Put wind units on lower left-hand size of hodograph
 gsn_text(wks,hodo_plot,U@units,-0.82*hodo_max,-0.9*hodo_max,lbl_res)

; Draw the skewT plot background with all the overlays
 draw (skewt_bkgd)

; Draw the skew-T data on top of everything else
 dataOpts = True
 dataOpts@colTemperature  = "red"  ; temperature line color
 dataOpts@colDewPt        = "blue" ; dewpoint line color
 dataOpts@DrawWindBarbThk = 2.     ; wind barb thickness
 dataOpts@Parcel          = 1      ; subscript corresponding to initial parcel
 dataOpts@WspdWdir        = False  ; True = use wind speed and dir, False = use U & V
 dataOpts@Wthin           = 0      ; 0 = draw wind barbs at all levels, 1 = draw every other, 2 = every 3rd, etc.
 skewT_data = skewT_PlotData(wks, skewt_bkgd, P_tot(:,locY,locX), \
                                               TC(:,locY,locX), \
                                               TD(:,locY,locX), \
                                            z_tot(:,locY,locX), \
                                                  U(:,locY,locX), \
                                                  V(:,locY,locX), \
                                             dataOpts)
 frame(wks)  ; advance frame
 print("Created plot: "+PlotName+"."+PlotType)
end
