# make SSH std

# concatenate all 2008 & 2009 files into a single one
echo 'concatenating 2008-2009 daily files into one file'
ncrcat AGUDAILY_*_*_2008_*_ssh.nc AGUDAILY_*_*_2009_*_ssh.nc daily_2008_2009.nc

# construct the temporal mean of 2008_2009.nc
echo 'making 2008-2009 mean'
ncwa -O -v ssh00 -a rdim daily_2008_2009.nc mean_2008_2009.nc

# constract the anomaly (deviation from the mean)
echo 'making 2008-2009 anomalies'
ncbo -O -v ssh00 daily_2008_2009.nc mean_2008_2009.nc anom_2008_2009.nc

# construct the root-mean-square from the anomaly
# Note the use of ‘-y rmssdn’ (rather than ‘-y rms’) in the final step. 
# This ensures the standard deviation is correctly normalized by one fewer than the number of time samples. 
# The procedure to compute the variance is identical except for the use of ‘-y var’ instead of ‘-y rmssdn’ in the final step.
echo 'making 2008-2009 standard devation'
ncra -O -y rmssdn anom_2008_2009.nc std_2008_2009.nc


