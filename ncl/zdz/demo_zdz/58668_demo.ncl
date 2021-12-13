begin

zdz_speed = asciiread("../zdz/58668_speed.txt", -1,"float")
zdz_dir = asciiread("../zdz/58668_dir.txt", -1,"float")


opt = 0
uv_zdz = wind_component(zdz_speed, zdz_dir, opt)


n_zdz = dimsizes(zdz_speed)

dx1 = new(n_zdz, "float")
dy1 = new(n_zdz, "float")
dy1 = 60
do i = 0, n_zdz-1
    dx1(i) = i+1
end do
; print(dy1)
print("ok")
dx2 = dx1
dy2 = dy1

dy2 = 65



files =systemfunc("ls /home/liyuan3970/Typhoon_LMQ/valid_data/nc/*")
f = addfiles(files, "r")
;print(f)
u =f[:]->u
v =f[:]->v
;printVarSummary(u)

u10 = doubletofloat(u({time|:},{heigh|0},{lat|28.06},{lon|121.31}))
v10 = doubletofloat(v({time|:},{heigh|0},{lat|28.06},{lon|121.31}))
;doubletofloat(u({time|:},{heigh|0},{lat|28.25},{lon|120}))
;printVarSummary(u10)
y = zdz_speed - sqrt(u10*u10+v10*v10)

y_new = new((/6,2/), "float")
y_new(:,0) = zdz_speed
y_new(:,1) = sqrt(u10*u10+v10*v10)
;print(u({time|},{heigh|:},{lat|29.07},{lon|121.23}))
print(sqrt(u10*u10+v10*v10))
wks = gsn_open_wks("png","58668")
sres = True
sres@vpWidthF = 0.7
sres@vpHeightF = 0.5
sres@vpXF = .15
sres@trXMinF = 0.4
sres@trXMaxF = 6.5
sres@trYMinF = 0
sres@trYMaxF = 70
sres@gsnDraw = True
sres@gsnFrame = False
sres@gsnXYBarChart = True
sres@tmXTOn = False
sres@tmYROn = False
sres@gsnXYBarChartBarWidth = 0.2           ; change bar widths
sres@tmXBMode          = "Explicit"         ; explicit labels
sres@tmXBValues        = (/1,2,3,4,5,6/)
sres@tmXBLabels = (/"23:00","00:00","01:00","02:00","03:00","04:00"/)
sres@tmXBLabelFontHeightF = 0.0205
sres@tmXTLabelFontHeightF = 0.0205
sres@tmYLLabelFontHeightF = 0.0225

sres@tiMainString = "station 58668 wind compare" 
sres@gsnRightString = ""
sres@tiYAxisString = "m/s"
sres@tiXAxisString = "time"


sres@gsnXYBarChartColors = (/"red"/)
x1 = (/0.85,1.85,2.85,3.85,4.85,5.85/)
x2 = (/1.15,2.15,3.15,4.15,5.15,6.15/)
plot1 = gsn_csm_xy(wks,x1,y_new(:,0),sres)
sres@gsnXYBarChartColors = (/"blue"/)
plot2 = gsn_csm_xy(wks,x2,y_new(:,1),sres)


wmsetp ("wdf", 1)                 ; meteorological dir
wmsetp("wbs",0.035)
wmsetp ("blw",4.0)
contours = 5 
colors = (/20,20,20,20,20,80,20,20,20/)
     do hh = 0,n_zdz-1
        wmsetp("col", 230) 
        wmbarb(wks, dx1(hh), dy1(hh), uv_zdz(0,hh)*2.5, uv_zdz(1,hh)*2.5)
     end do
;wmsetp("col", GetFillColorIndex(contours,colors,u1))
;wmbarb(wks, dx1, dy1, u1, v1)
     do hh = 0,n_zdz-1
        wmsetp("col", 2) 
        wmbarb(wks, dx2(hh), dy2(hh), u10(hh)*2.5, v10(hh)*2.5)
     end do
;wmbarb(wks, dx2, dy2, u2, v2)

;draw(plot)                        ; draw the plot
frame(wks)                        ; advance the frame
;print(n_zdz)
end