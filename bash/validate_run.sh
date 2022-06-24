# mkdir /work/bjornb/ASSIM_RUN/validate

ln -s ~/REANALYSIS/FILES/regional.* .
ln -s ~/hycom/MSCPROGS/Input/extract.weekly.validate extract.weekly
ln -s ../2*/FORECAST/AGUAVE_2008* .
ln -s ../2*/FORECAST/AGUAVE_2009* .

for i in AGUAVE*.a
do
   ~/hycom/MSCPROGS/src/ExtractNC3D/h2nc $i
   mv tmp1.nc $(basename $i \.a)_validate.nc
done

ln -s ~/matlab/mFiles/plot_validate.m .
matlab -nodesktop -nosplash -r "plot_validate; exit"

rm *validate.nc 
