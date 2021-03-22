#!/bin/bash
# subset MODIS data using python and nco
#
# REQUIREMENTS
# 1. netcdf operators installed
# 2. python including numpy libraries 
#
# USAGE
# 1. create base-directory to work in
# 2. copy subset_modis.sh and get_region_indexes.py to base-directory
# 3. create directory called 'global', i.e. base-directory/global/
# 4. create symbolic link of all global netcdf data in directory 'global' or simply move all global netcdf data into the 'global' directory
# 5. run routine from the base-directoryby typing './subset_modis.sh' from the base-directory

clear

# check for directory with global data...
if [ -d `pwd`/global ] 
then
    echo "Directory `pwd`/global exists."
else
    echo "ERROR: Directory `pwd`/global does not exists."
    echo "Create a directory called 'global' which contains the global data you want to subset"
    exit
fi

# get lon and lat indexes for subsetting and write to infile.ij
python get_region_indexes.py

# read in indexes from infile.ij
ij=(`cat infile.ij`)

# check for and create subset directory
if [ -d `pwd`/subset ] 
then
    echo "Directory `pwd`/subset exists."
else
    echo "Directory `pwd`/subset does not exists. Creating it........"
    mkdir `pwd`/subset
fi


for i in global/*.nc
do
   echo "subsetting global file $i to defined subset `pwd`/subset/$(basename $i \.nc)_subset.nc"
   ncks -F -d lat,${ij[2]},${ij[3]} -d lon,${ij[0]},${ij[1]} $i -o subset/$(basename $i \.nc)_subset.nc
   # add year,month variables
   ncap2 -s 'defdim("year",1);year[year]='${i:15:4}';year@long_name="Year";' -O subset/$(basename $i \.nc)_subset.nc subset/$(basename $i \.nc)_subset.nc
   ncap2 -s 'defdim("day",1);day[day]='${i:19:3}';day@long_name="Day in year representing time of monthly average";' -O subset/$(basename $i \.nc)_subset.nc subset/$(basename $i \.nc)_subset.nc
   ncks -O --mk_rec year subset/$(basename $i \.nc)_subset.nc subset/$(basename $i \.nc)_subset.nc   
   ncks -O --mk_rec day subset/$(basename $i \.nc)_subset.nc subset/$(basename $i \.nc)_subset.nc   
done

# concatenate to single netcdf file
echo "enter netcdf filename to save subset data as (e.g. region_monthly_sst4_4km.nc): "
read fname
ncrcat subset/*subset.nc $fname

rm -r subset
