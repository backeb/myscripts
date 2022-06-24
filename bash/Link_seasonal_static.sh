[ $# -ne 1 ] &&  { echo "Must be called with 1 arg -  the day in year of the assim  "; exit 1 ; }
tday=$1
dayrange=30
cnt=1
cd /work/bjornb/Assim_AGU
rm -f forecast???.[a,b]  Static_SLA.uf
for i in /work/bjornb/RESTART/AGUrestart????_???_??.a
 do
    boolean=0
    day=`echo $i | cut -c37-39`
    bday=`expr $day`
    let daymax=tday+dayrange
    let daymax_s=daymax%364
    let daymin=tday-dayrange
    let daymin_m=daymin+364
    # This would not work for case where drange is tooo large
    if   ( (( ${daymax} > 364 )) && (( [ ${day} -le 365 ] && [ ${day} -ge ${daymin} ] ) ||  [ ${day} -le ${daymax_s} ] )); then
       boolean=1
    elif ( (( ${daymin} <= 0  )) && (( [ ${day} -ge 0   ] && [ ${day} -le ${daymax} ] ) || [ ${day}  -ge ${daymin_m} ] )); then 
       boolean=1
   elif ( [ ${day}  -le ${daymax} ] && [ ${day} -ge ${daymin} ] ) ; then
      boolean=1
   fi
    echo $boolean $day  $daymax $daymin

    if [ $boolean -eq 1 ]; then
       cnt2=`echo 00$cnt | tail -4c`
       echo ln -sf $i forecast${cnt2}.a
       ln -sf $i forecast${cnt2}.a
       ln -sf /work/bjornb/RESTART/$(basename $i \.a).b forecast${cnt2}.b
       ~/hycom/MSCPROGS/src/SSHFromState/ssh_from_restart forecast${cnt2}.a $cnt
       let cnt=cnt+1
    fi
    mv model_SLA.uf Static_SLA.uf
 done
