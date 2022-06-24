cnt=1
cd /work/bjornb/Assim_AGU
for i in /work/bjornb/RESTART/AGUrestart????_???_??.a
 do
    cnt2=`echo 00$cnt | tail -4c`
    echo ln -sf $i forecast${cnt2}.a
    ln -sf $i forecast${cnt2}.a
    ln -sf /work/bjornb/RESTART/$(basename $i \.a).b forecast${cnt2}.b
    ~/hycom/MSCPROGS/src/SSHFromState/ssh_from_restart forecast${cnt2}.a $cnt
    let cnt=cnt+1
done
