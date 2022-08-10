load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
begin
    
    file_path="/mnt/c/users/hong/desktop/1.txt"
    data=asciiread(file_path, (/4216,13/), "float")
    station=data(:,0)       ;读入站点号
    lat=data(:,1)           ;读入纬度
    lon=data(:,2)           ;读入经度
    day=data(:,6)           ;由于我选的就是1951年1月的，所以只有日期存在区别。
    temp=data(:,7)          ;NCL是从0开始计数，因此第8列索引是7。
    temp@_FillValue=32766   ;在数据说明里说了气温的缺测值是32766
     ;由于在资料里是整数性，需要对其进行一下转换，其中经纬度要从60进制转为100进制
    lat_a=round(lat*0.01,0)+(lat*0.01-round(lat*0.01,3))/60*100
    lon_a=round(lon*0.01,0)+(lat*0.01-round(lat*0.01,3))/60*100
    temp_a=temp*0.1
    temp_av=new(136,"float")
    lon_av=new(136,"float")
    lat_av=new(136,"float")
    do i=0,135
        temp_av(i)=dim_avg_n(temp_a(31*i:31*i+30),0)
        lon_av(i)=lon_a(31*i)
        lat_av(i)=lat_a(31*i)
    end do
    R=temp_av
    temp_max=max(temp_av)
    temp_min=min(temp_av)
    itv=(temp_max-temp_min)/5
    arr=(/temp_min+itv,temp_min+2*itv,temp_min+3*itv,temp_min+4*itv/);我把所有温度均匀地用4个节点分配为5份
    colors = (/10,38,56,66,94/);5个水平需要5个颜色来代表
    num_markers=dimsizes(arr)+1;
    lat_new = new((/num_markers,dimsizes(R)/),float,-999);
    lon_new = new((/num_markers,dimsizes(R)/),float,-999);
    labels = new(dimsizes(arr)+1,string);最后出现在图下方的标签
    do i =0,num_markers-1
        if(i.eq.0);第一个水平即低于0的水平
            indexes=ind(R.lt.arr(0))
            labels(i)="R<"+arr(0)
        end if
        if(i.eq.(num_markers-1))then;最大的一个水平即为大于26的
            indexes=ind(R.ge.max(arr))
            labels(i)="R>="+max(arr)
        end if
        if(i.gt.0.and.i.lt.(num_markers-1))then;中间的水平
            indexes=ind(R.ge.arr(i-1).and.R.lt.arr(i))
            labels(i)=arr(i-1)+"<=R<"+arr(i)
        end if
        if(.not.any(ismissing(indexes)))then;如果index里有数，而不全是-999，那么把lat、lon_new的前N个（在这一水平里有N个点）换成这N个点的经纬度。
            npts_range=dimsizes(indexes)
            lat_new(i,0:(npts_range-1))=lat_av(indexes)
            lon_new(i,0:(npts_range-1))=lon_av(indexes)
        end if
        delete(indexes)
    end do
    wks=gsn_open_wks("png", "scatter_example")
    gsn_define_colormap(wks, "WhViBlGrYeOrRe")
    mpres=True
    mpres@gsnFrame=False
    mpres@pmTickMarkDisplayMode="Always"
    mpres@mpMinLatF=15.0
    mpres@mpMaxLatF=55.0
    mpres@mpMinLonF=72
    mpres@mpMaxLonF=135.0
    mpres@tiMainString="1951 January China average temperature"
    mpres@mpDataBaseVersion = "Ncarg4_1";这一步和下一步必须要，否则加载中国地图的时候会出错（找不到地图库）
    mpres@mpDataSetName="Earth..4";这步加上步再加下面那个China:state和Taiwan就可以画出中国轮廓边界了
    mpres@mpOutlineOn=True
    mpres@mpOutlineSpecifiers=(/"China:states","Taiwan"/);在这个地图库里我们绘制中国和台湾的区域边界，China:state里居然没有台湾！不能忍，要包括进来！
    mpres@mpGeophysicalLineThicknessF=2.0 ;这两行是为了加粗边界和国界线
    mpres@mpNationalLineThicknessF=2.0
    ;我看网上那个最多人转载的那个站点画气温分布等值线图，它用的兰伯特投影，我画了一下，左右纬度不对称，很奇怪，就放弃使用了。
    map=gsn_csm_map(wks,mpres)
    gsres=True
    gsres@gsMarkerIndex=16
    do i=0,num_markers-1
        if (.not.ismissing(lat_new(i,0))) then
            gsres@gsMarkerColor=colors(i)
            gsres@gsMarkerThicknessF=i+1
            gsn_polymarker(wks,map,lon_new(i,:),lat_new(i,:),gsres)
        end if
    end do
    frame(wks);
end
————————————————
版权声明：本文为CSDN博主「IAP_Honghx」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_42762673/article/details/81164566