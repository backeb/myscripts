# link .[ab] to directory
for i in ../AGUa0.10/expt_01.6/SCRATCH/archm.1985_???_??.a
do
   ln -s $i AGUarchv.${i:36:11}.a
done

for i in ../AGUa0.10/expt_01.6/SCRATCH/archm.1985_???_??.b
do
   ln -s $i AGUarchv.${i:36:11}.b
done

module load nco
# do hyc2proj
for i in AGUarchv*.a
do
   ~knutali/Repos/Svn/hycom/MSCPROGS/bin/hyc2proj $i
   fout=AGUarchv*.nc
   fout=$(basename $fout \.nc)
   # remove some variables
   ncks -x -v x,y,model_depth,mercator $fout.nc -O $fout.nc
   # rename some variables
   ncrename -h -O -v depth,z-level $fout.nc
   ncrename -h -O -d depth,z-level $fout.nc
   ncrename -h -O -v ubaroclin,u_mean $fout.nc
   ncrename -h -O -v vbaroclin,v_mean $fout.nc
   # rename some attributes
   ncatted -O -a standard_name,z-level,o,c,z-level $fout.nc
   ncatted -O -a standard_name,z-level,o,c,z-level $fout.nc
   ncatted -O -a long_name,time,o,c,"model output time" $fout.nc
   ncatted -O -a standard_name,u_mean,o,c,"mean u-vel." $fout.nc
   ncatted -O -a standard_name,v_mean,o,c,"mean v-vel." $fout.nc
   # remove some attributes
   ncatted -O -a long_name,z-level,d,, $fout.nc
   ncatted -O -a cell_methods,u_mean,d,, $fout.nc
   ncatted -O -a cell_methods,v_mean,d,, $fout.nc
   ncatted -O -a cell_methods,u_max.,d,, $fout.nc
   ncatted -O -a cell_methods,v_max.,d,, $fout.nc
   # sort out attributes for u_max. & v_max.
   ncatted -O -a units,u_max.,c,c,"m s-1" $fout.nc
   ncatted -O -a units,v_max.,c,c,"m s-1" $fout.nc
   ncatted -O -a standard_name,u_max.,c,c,"max u-vel." $fout.nc
   ncatted -O -a standard_name,v_max.,c,c,"max v-vel." $fout.nc
   ncatted -O -a _FillValue,u_max.,o,s,-32767 $fout.nc
   ncatted -O -a _FillValue,v_max.,o,s,-32767 $fout.nc
   ncatted -O -a missing_value,u_max.,o,s,-32767 $fout.nc
   ncatted -O -a missing_value,v_max.,o,s,-32767 $fout.nc
   # change global attributes
   ncatted -O -h -a title,global,o,c,"Agulhas HYCOM hindcast (1980-2010)" $fout.nc
   ncatted -O -h -a institution,global,o,c,"CSIR, Jan Celliers Rd, Stellenbosch, 7600, South Africa" $fout.nc
   ncatted -O -h -a history,global,o,c,"Created by program hyc2proj, version V0.3" $fout.nc
   ncatted -O -h -a references,global,o,c,"Backeberg et al., 2014. Assimilating along-track SLA data using the EnOI in an eddy resolving model of the Agulhas system, Ocean Dynamics, 64:1121-1136." $fout.nc

   mv $fout.nc AGUhourly_${fout:9:11}.nc
done

rm AGUarchv.*
