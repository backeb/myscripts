#Download and subset global HYCOM data...

module load nco

# expt_90.8: 2009_127 -> 2011_002
# expt_90.9: 2011_003 -> 2013_232
# 1-Dec-2009 is day 335
# 31-Jan-2013 is day 31
expt=`echo expt_90.8`

for year in `seq 2009 2013`
do
	for doy in `seq 1 365` 
	do

		boolean=0

		if ( [ ${year} -eq 2009 ] && [ ${doy} -lt 335 ] ) ; then
			continue
		elif  ( [ ${year} -eq 2013 ] && [ ${doy} -gt 31 ] ) ; then
			break
		else
			boolean=1
		fi

		if [ $boolean -eq 1 ] ; then

			if ( [ ${year} -eq 2011 ] && [ ${doy} -eq 3 ] ) ; then
				expt=`echo expt_90.9`
			fi

			if ( [ ${doy} -lt 10 ] ) ; then
				daystr=`echo 00${doy}`
			elif ( [ ${doy} -lt 100 ] ) ; then
				daystr=`echo 0${doy}`
			else
				daystr=`echo ${doy}`
			fi

			echo $boolean $expt $year $daystr
         
			echo "Downloading ftp://ftp.hycom.org/datasets/GLBa0.08/$expt/data/uvel/archv.${year}_${daystr}_00_3zu.nc"
			wget -nv ftp://ftp.hycom.org/datasets/GLBa0.08/$expt/data/uvel/archv.${year}_${daystr}_00_3zu.nc
			echo "Downloading ftp://ftp.hycom.org/datasets/GLBa0.08/$expt/data/vvel/archv.${year}_${daystr}_00_3zv.nc"
			wget -nv ftp://ftp.hycom.org/datasets/GLBa0.08/$expt/data/vvel/archv.${year}_${daystr}_00_3zv.nc

			if ( [ -f archv.${year}_${daystr}_00_3zu.nc ] && [ -f archv.${year}_${daystr}_00_3zv.nc ] ) ; then
				echo "Subsetting: archv.${year}_${daystr}_00_3zu.nc -> archv.subset.${year}_${daystr}_00_3zu.nc"
				ncks -F -d Y,1023,1181 -d X,3887,4011 archv.${year}_${daystr}_00_3zu.nc -o archv.subset.${year}_${daystr}_00_3zu.nc
				echo "Subsetting: archv.${year}_${daystr}_00_3zv.nc -> archv.subset.${year}_${daystr}_00_3zv.nc"
				ncks -F -d Y,1023,1181 -d X,3887,4011 archv.${year}_${daystr}_00_3zv.nc -o archv.subset.${year}_${daystr}_00_3zv.nc
            echo "Removing global data file"
				rm archv.${year}_${daystr}_00_3zu.nc archv.${year}_${daystr}_00_3zv.nc
			else	
				echo "Something went wrong with the data download. I QUIT!"
				break
			fi
		fi

	done
done
