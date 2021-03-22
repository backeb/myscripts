# run hyc2proj on multiple files and rename on the fly
ulimit -s unlimited
export OMP_NUM_THREADS=1

# need to link all archm.????_???_?? files to different file names to run hyc2proj
for i in archm.????_???_??.a
do
	ln -s ${i:0: -2}.a AGUarchv.${i:6:11}.a
	ln -s ${i:0: -2}.b AGUarchv.${i:6:11}.b
done

for i in AGUarchv*.a
do 
	~/Progs/Hyc2proj_wtot/hyc2proj $i
done

# list all created nc files and check how much space they use
du -shc *.nc

# archive them
tar -zcvf expt010_ssh.tar.gz AGU*.nc

# remove all nc files
rm AGU*.nc

# remove all ln -s
rm AGUarchv*

