module load nco

for i in analysis_*.nc
do
   # delete variables
   echo "calculating innovation for julday ${i:9:5}"
   # remove unwanted variables
   ncks -O -x -v depth,meanssh,ficem,ticem,hicem,hsnwm,salt,dp,p,temp_z,salt_z,u_z,v_z $i $i
   ncks -O -x -v depth,meanssh,ficem,ticem,hicem,hsnwm,salt,dp,p,temp_z,salt_z,u_z,v_z forecast_${i:9:5}.nc forecast_${i:9:5}.nc
   # calculate innocation: analysis minus forecast
   ncdiff -O $i forecast_${i:9:5}.nc innovation_${i:9:5}.nc
   # remove lon/lat which were set zero
   ncks -O -x -v lon,lat innovation_${i:9:5}.nc innovation_${i:9:5}.nc
   # add lon/lat back in from analysis file
   ncks -A -v lat,lon $i innovation_${i:9:5}.nc

done


