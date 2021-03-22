module load nco

for i in AGUDAILY_????_???_2009_36?.a
do
   ~/hycom/MSCPROGS/src/Hyc2proj/hyc2proj $i
   fout=AGUDAILY_*.nc
   fdate=$(basename $fout \.nc)
   fdate=${fdate: -8:8}
   # change some global attributes
   ncatted -O -h -a title,global,o,c,"Agulhas HYCOM reanalysis, assimilating along-track SLA and OSTIA SST" $fout
   ncatted -O -h -a institution,global,o,c,"CSIR, Jan Celliers Rd, Stellenbosch, 7600, South Africa" $fout
   ncatted -O -h -a references,global,o,c,"Backeberg et al., 2014. Assimilating along-track SLA data using the EnOI in an eddy resolving model of the Agulhas system, Ocean Dynamics, 64:1121-1136." $fout
   # move to new filename
   mv $fout hycom_agu_$fdate.nc
done

ncrcat hycom_agu_*.nc hycom_agu.nc
