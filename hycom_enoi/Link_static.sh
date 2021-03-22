tday=$1
dayrange=30
cnt=1
cd /work/bjornb/Assim_AGU
for i in /work/bjornb/RESTART/AGUrestart????_???_??.a
 do
    boolean=0
    day=`echo $i | cut -c39-41`
    let daymax=day+dayrange
    let daymin=day-dayrange
    if (( ${daymax} -ge 364 ) && (( ${day} -le 365 ) | ( ${day} -le ${daymax} % 364 )) && ( ${day} -ge ${daymin})) boolean=1
    elif (( ${daymin} -le  0  ) && (( ${day} -ge 0   ) | ( ${day} -ge ${daymin}+364   )) && ( $day -le $daymax)) boolean=1
    elif (( day  -le $daymax ) && ( $day -ge $daymin ))  boolean=1

    if [ boolean -eq 1 ]
    then
       cnt2=`echo 00$cnt | tail -4c`
       echo ln -sf $i forecast${cnt2}.a
       ln -sf $i forecast${cnt2}.a
       ln -sf /work/bjornb/RESTART/$(basename $i \.a).b forecast${cnt2}.b
       ~/hycom/MSCPROGS/src/SSHFromState/ssh_from_restart forecast${cnt2}.a $cnt
       let cnt=cnt+1
    fi
 done
