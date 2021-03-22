# need to link all archm.????_???_?? files to different file names to run h2nc
for i in archm.????_???_??.a
do
	ln -s ${i:0: -2}.a AGUarchv.${i:6:11}.a
	ln -s ${i:0: -2}.b AGUarchv.${i:6:11}.b
done

for i in AGUarchv*.a
do 
	~/NERSC-HYCOM-CICE/hycom/MSCPROGS/src/ExtractNC3D/h2nc $i
	mv tmp1.nc $(basename $i \.a).nc
done

# list all created nc files and check how much space they use
du -shc *.nc

# archive them
tar -zcvf expt010_h2nc.tar.gz AGUarchv*.nc

# remove all nc files
rm AGUarchv*.nc

# remove all ln -s
rm AGUarchv*

