timeout="600"
count="10"
threads="1"
key="s3-put-4k-1thread"

mkdir -p /opt/test/4k

for i in $(seq $count); do
  dd if=/dev/urandom of=/opt/test/4k/4k_$i bs=4k count=1
done

aws configure set default.s3.max_concurrent_requests $threads

t0=$(date +%s%N)
timeout $timeout aws s3 sync /opt/test/4k s3://chipster-rahti-benchmark --endpoint-url https://object.pouta.csc.fi 2>&1
exit_val=$?

if [ $exit_val -eq 0 ] ; then 
  t1=$(date +%s%N)
  
  time=$(echo "($t1 - $t0) / 10^9" | bc -l)
  value=$(echo "$count / $time" | bc -l)
else  
  echo "Timeout"
  value=0
fi

echo $bytes $time $value

curl -i -XPOST http://influxdb:8086/write?db=db --data-binary "$key value=$value $t0"