timeout=180
key=pvc-read

file="/mnt/data/disk-write"
size=$(stat -c %s $file)

date
echo "Measuring $key"

t0=$(date +%s%N)
timeout $timeout cat $file > /dev/null
exit_val=$?

if [ $exit_val -eq 0 ] ; then 
  t1=$(date +%s%N)
  
  time=$(echo "($t1 - $t0) / 10^9" | bc -l)
  bytes=$size
  value=$(echo "$bytes / $time" | bc -l)
else  
  echo "Timeout"
  value=0
fi

time=$(echo "($t1 - $t0) / 10^9" | bc -l)
bytes=$size
value=$(echo "$bytes / $time" | bc -l)

echo $key $t0 $bytes bytes, $time seconds, $value B/s

curl -i -XPOST 'http://influxdb:8086/write?db=db' --data-binary "$key value=$value $t0"