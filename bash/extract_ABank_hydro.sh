for i in STATION_FILES/stations.in.*
do
   cp $i stations.in
   stnyrdoy="${i##*in.}"
   stn="${stnyrdoy%.*}"
   yrdoy="${stnyrdoy##*.}"
   cp DEPTHLEVEL_FILES/depthlevels.in.${stn}.${yrdoy} depthlevels.in
   ~/hycom/MSCPROGS/src/Hyc2proj/hyc2stations AGUDAILY_????_???_${yrdoy}.a
   mv AGUDAILY_start????????_dump????????_group${stn}.nc HYCOM_EnOI_SLAonly_${stn}_${yrdoy}.nc
done
