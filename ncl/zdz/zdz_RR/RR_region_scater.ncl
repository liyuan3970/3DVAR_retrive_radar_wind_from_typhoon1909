begin
    
file_path="/home/liyuan3970/Typhoon_LMQ/notebooks/RR_region.csv"
data=asciiread(file_path, (/3051,4/), "float")
station=data(:,0)       ;读入站点号
lat=data(:,1)           ;读入纬度
lon=data(:,2)           ;读入经度
RR=data(:,3)
RR@_FillValue=-9999   ;在数据说明里说了气温的缺测值是32766
;print(max(lat))
;print(max(lon))
;print(min(lat))
;print(min(lon))

RR_max=max(RR)
RR_min=min(RR)

print(RR_max)
print(RR_min)
itv=(RR_max-RR_min)/5
arr=(/RR_min+itv,RR_min+2*itv,RR_min+3*itv,RR_min+4*itv/);我把所有温度均匀地用4个节点分配为5份
colors = (/10,38,130,180,244/);5个水平需要5个颜色来代表
num_markers=dimsizes(arr)+1;
print(num_markers)
lat_new = new((/num_markers,dimsizes(RR)/),float,-999);
lon_new = new((/num_markers,dimsizes(RR)/),float,-999);
labels = new(dimsizes(arr)+1,string);最后出现在图下方的标签
    do i =0,num_markers-1
        if(i.eq.0);第一个水平即低于0的水平
            indexes=ind(RR.lt.arr(0))
            labels(i)="R<"+arr(0)
        end if
        if(i.eq.(num_markers-1))then;最大的一个水平即为大于26的
            indexes=ind(RR.ge.max(arr))
            labels(i)="R>="+max(arr)
        end if
        if(i.gt.0.and.i.lt.(num_markers-1))then;中间的水平
            indexes=ind(RR.ge.arr(i-1).and.RR.lt.arr(i))
            labels(i)=arr(i-1)+"<=R<"+arr(i)
        end if
        if(.not.any(ismissing(indexes)))then;如果index里有数，而不全是-999，那么把lat、lon_new的前N个（在这一水平里有N个点）换成这N个点的经纬度。
            npts_range=dimsizes(indexes)
            lat_new(i,0:(npts_range-1))=lat(indexes)
            lon_new(i,0:(npts_range-1))=lon(indexes)
        end if
        delete(indexes)
    end do
    wks=gsn_open_wks("png", "scatter_example")
    ;gsn_define_colormap(wks, "WhViBlGrYeOrRe")
    mpres=True
    mpres@gsnFrame=False
    mpres@gsnDraw =False
    mpres@pmTickMarkDisplayMode="Always"
    mpres@mpMinLatF=27
    mpres@mpMaxLatF=32
    mpres@mpMinLonF=118
    mpres@mpMaxLonF=124
    mpres@tiMainString="1951 January China average temperature"
    mpres@mpDataBaseVersion = "Ncarg4_1";这一步和下一步必须要，否则加载中国地图的时候会出错（找不到地图库）
    mpres@mpDataSetName="Earth..4";这步加上步再加下面那个China:state和Taiwan就可以画出中国轮廓边界了
    mpres@mpOutlineOn=True
    mpres@mpOutlineSpecifiers=(/"China:states","Taiwan"/);在这个地图库里我们绘制中国和台湾的区域边界，China:state里居然没有台湾！不能忍，要包括进来！
    mpres@mpGeophysicalLineThicknessF=2.0 ;这两行是为了加粗边界和国界线
    mpres@mpNationalLineThicknessF=2.0
    mpres@mpLandFillColor = "white"
    ;我看网上那个最多人转载的那个站点画气温分布等值线图，它用的兰伯特投影，我画了一下，左右纬度不对称，很奇怪，就放弃使用了。
    map=gsn_csm_map(wks,mpres)
    gsres=True

    gsres@gsMarkerIndex=3
    gsres@gsMarkerThicknessF = 1.5
    gsres@gsMarkerSizeF = 5

  lnres                  = True
  lnres@gsLineColor      = "navyblue"
  lnres@gsFillColor      = "navyblue"
  lnres@gsLineThicknessF = 1.5
  lnres@minlat           = 27.1
  lnres@maxlat           = 31.1
  lnres@minlon           = 118.4
  lnres@maxlon           = 122.9
   dum = gsn_add_shapefile_polylines(wks,map,"/home/liyuan3970/Typhoon_LMQ/data/ncl/shp_demo/zhejiang.shp",lnres)
   draw(map)
    do i=0,num_markers-1
        if (.not.ismissing(lat_new(i,0))) then
            gsres@gsMarkerColor=colors(i)
            gsres@gsMarkerThicknessF=i+1
            gsn_polymarker(wks,map,lon_new(i,:),lat_new(i,:),gsres)
        end if
    end do
    ;---Setting lat/lon limits helps drawing go faster

   ;
   frame(wks)

end