module load nco

for i in AGUAVE*benguela.nc
do 
   echo "subsetting $i to $(basename $i \benguela.nc)sthelenabay.nc"
   ncks -F -d jdim,174,205 -d idim,105,136 $i -o $(basename $i \benguela.nc)sthelenabay.nc
done
