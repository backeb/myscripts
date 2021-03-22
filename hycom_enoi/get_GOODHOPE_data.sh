for tday in `seq 38 84`
do
   ~fanf/hycom/MSCPROGS/src/Section/m2section AGUDAILY_*_*_2008_0$tday.a
   mv section001.nc GOODHOPE_UNASSIMRUN_2008_0$tday.nc
done
rm extract1 tst*.nc transport001.dat section001.dat tmp1.tec

ncrcat GOODHOPE_UNASSIMRUN*.nc section001.nc
