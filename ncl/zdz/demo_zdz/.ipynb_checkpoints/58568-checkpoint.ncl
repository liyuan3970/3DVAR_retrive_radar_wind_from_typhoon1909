begin

zdz_speed = asciiread("zdz/58568_speed.txt", -1,"float")
zdz_dir = asciiread("zdz/58568_dir.txt", -1,"float")


opt = 0
uv_zdz = wind_component(zdz_speed, zdz_dir, opt)


n_zdz = dimsizes(zdz_speed)

dx1 = new(n_zdz, "float")
dy1 = new(n_zdz, "float")
dy1 = -10
do i = 0, n_zdz-1
    dx1(i) = i+1
end do
; print(dy1)
print("ok")
dx2 = dx1
dy2 = dy1

dy2 = -15



files =systemfunc("ls /home/liyuan3970/Typhoon_LQM/valid_data/nc/*.nc")
f = addfiles(files, "r")
;print(f)
u =f[:]->u
v =f[:]->v
;printVarSummary(u)

u10 = doubletofloat(u({time|:},{heigh|0},{lat|29.07},{lon|121.23}))
v10 = doubletofloat(v({time|:},{heigh|0},{lat|29.07},{lon|121.23}))
;doubletofloat(u({time|:},{heigh|0},{lat|28.25},{lon|120}))
printVarSummary(u10)
y = zdz_speed - sqrt(u10*u10+v10*v10)

wks = gsn_open_wks("png","58568")
res = True
res@gsnDraw = False
res@gsnFrame = False
res@vpWidthF = 0.8
res@vpHeightF = 0.5
res@vpXF = 0.1
res@vpYF = 0.9
;res@trYMinF = -5
;res@trYMaxF = 5
res@tiMainString = "Wind Profile"


  rts           = True
  rts@gsnDraw   = False       ; don't draw yet
  rts@gsnFrame  = False       ; don't advance frame yet
  rts@gsnScale  = True        ; force text scaling               

; these four resources allow the user to stretch the plot size, and
; decide exactly where on the page to draw it.

  rts@vpHeightF = 0.40        ; Changes the aspect ratio
  rts@vpWidthF  = 0.85
  rts@vpXF      = 0.10        ; change start locations
  rts@vpYF      = 0.75        ; the plot
  ;rts@trYMinF = -5
  ;rts@trYMaxF = 9


  rts@tiYAxisString = "Pa"                    ; y-axis label      

  rts@gsnYRefLine           = 0.              ; reference line   
  rts@gsnXYBarChart         = True            ; create bar chart 
  rts@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  rts@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue
  rts@gsnXYBarChartBarWidth = 0.5 

; panel plot only resources
  rtsP                      = True            ; modify the panel plot
  rtsP@gsnMaximize          = True            ; large format
  rts@tiMainString = "Wind Profile"

plot = gsn_csm_xy(wks,dx1,y,rts)


wmsetp ("wdf", 1)                 ; meteorological dir
wmsetp("wbs",0.025)
wmsetp ("blw",2.0)
contours = 5 
colors = (/20,20,20,20,20,80,20,20,20/)
     do hh = 0,n_zdz-1
        wmsetp("col", 180) 
        wmbarb(wks, dx1(hh), dy1(hh), uv_zdz(0,hh), uv_zdz(1,hh))
     end do
;wmsetp("col", GetFillColorIndex(contours,colors,u1))
;wmbarb(wks, dx1, dy1, u1, v1)
     do hh = 0,n_zdz-1
        wmsetp("col", 2) 
        wmbarb(wks, dx2(hh), dy2(hh), u10(hh), v10(hh))
     end do
;wmbarb(wks, dx2, dy2, u2, v2)

draw(plot)                        ; draw the plot
frame(wks)                        ; advance the frame
print(n_zdz)
end