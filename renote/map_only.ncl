;================================================;
;  maponly_1.ncl
;================================================;
;
; Concepts illustrated:
;   - Drawing a default cylindrical equidistant map
;
;================================================;
;
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
; ================================================;
begin

  wks  = gsn_open_wks("png","maponly")    ; send graphics to PNG file
  ;>---------------------------------------<
;            set for the wks and golbal res
;>---------------------------------------<
;wks = gsn_open_wks("eps","2019-08-10-06:00")
res = True
; res@gsnDraw = False
; res@gsnFrame = False
res@gsnLeftString = ""
res@gsnRightString = " "
;res@gsnCenterString = "2019-08-10-06"
;>---------------------------------------<
;            set for the map
;>---------------------------------------<
mpres = res
mpres@mpFillOn                = True
mpres@mpCenterLonF            = 120
mpres@mpMinLatF               = -20.
mpres@mpMaxLatF               = 90.
mpres@mpMinLonF               = -180.
mpres@mpMaxLonF               = 180.
; mpres@mpDataBaseVersion       = "MediumRes"
; mpres@mpDataSetName           = "Earth..4"
; ;mpres@mpOutlineSpecifiers     = (/"China:states"/)
; mpres@pmTickMarkDisplayMode  = "Always"
; mpres@tmXBMajorLengthF = 0.015
; mpres@mpOutlineOn =True
; mpres@mpCountyLineThicknessF = 10
; mpres@mpGeophysicalLineThicknessF = 0.01
; mpres@mpPerimOn  =True
; mpres@mpPerimLineThicknessF   = 0.8
; mpres@mpLandFillColor = "blue"
; mpres@mpLandFillColor = "black"
  plot = gsn_csm_map(wks,mpres)        ; draw global map


  end
