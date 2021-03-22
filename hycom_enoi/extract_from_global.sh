module load nco
cd /work/bjornb/GlobHYCOM/

for year in `seq 1992 1995`
do
   for month in 01 02 03 04 05 06 07 08 09 10 11 12
   do
      wget ftp://ftp.hycom.org/datasets/GLBb0.08/expt_19.0/data/meanstd/190_archMN.${year}_${month}.a
      wget ftp://ftp.hycom.org/datasets/GLBb0.08/expt_19.0/data/meanstd/190_archMN.${year}_${month}.b
      if [ -f 190_archMN.${year}_${month}.a ]
      then
         echo "Data available moving to new file name extracting to netcdf"
         mv 190_archMN.${year}_${month}.a GLBarchv.${year}_${month}.a
         mv 190_archMN.${year}_${month}.b GLBarchv.${year}_${month}.b
         # extract salin temp thknss, place into own files
         for var in salin temp thknss
         do
            cat extract.archv.in | sed "s/varin/${var}/" > extract.archv
            ~/hycom/MSCPROGS/src/ExtractNC3D/h2nc GLBarchv.${year}_${month}.a
            ncks -F -d jdim,561,1443 -d idim,3574,4324 tmp1.nc -o tmp2.nc
            mv tmp2.nc AGUarchMN.${year}_${month}_${var}.nc
            rm tmp1.nc extract.archv
         done
         # extract u-vel., v-vel. place into one file
         cp extract.archv.uv extract.archv
         ~/hycom/MSCPROGS/src/ExtractNC3D/h2nc GLBarchv.${year}_${month}.a
         ncks -F -d jdim,561,1443 -d idim,3574,4324 tmp1.nc -o tmp2.nc
         mv tmp2.nc AGUarchMN.${year}_${month}_uv.nc
         rm tmp1.nc extract.archv
         # extract srfhgt, u_btrop, v_btrop, place into one file
         cp extract.archv.2D extract.archv
         ~/hycom/MSCPROGS/src/ExtractNC3D/h2nc GLBarchv.${year}_${month}.a
         ncks -F -d jdim,561,1443 -d idim,3574,4324 tmp1.nc -o tmp2.nc
         mv tmp2.nc AGUarchMN.${year}_${month}_2D.nc
         rm tmp1.nc extract.archv
         rm GLBarchv.${year}_${month}.*
      else
         echo "Data not available, I QUIT"
      fi
   done
done
