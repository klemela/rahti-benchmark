timeout="600"
threads="1"
key="s3-get-4k-1thread"

mkdir -p /opt/test/4k

rm -rf /opt/test/4k_get

aws configure set default.s3.max_concurrent_requests $threads

t0=$(date +%s%N)
timeout $timeout aws s3 sync --exclude="*" --include="4k_1*" s3://chipster-rahti-benchmark /opt/test/4k_get --endpoint-url https://object.pouta.csc.fi 2>&1
exit_val=$?

count=$(ls /opt/test/4k_get | wc -l)

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