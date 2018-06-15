timeout="600"
size="4096"
key="s3-put-4GB-1job-1chunk"

dd if=/dev/urandom of=/opt/test/rand bs=1M count=$size

aws configure set default.s3.multipart_threshold ${size}MB
aws configure set default.s3.multipart_chunksize ${size}MB

t0=$(date +%s%N)
timeout $timeout aws s3 cp /opt/test/rand s3://chipster-rahti-benchmark --endpoint-url https://object.pouta.csc.fi 2>&1
exit_val=$?

if [ $exit_val -eq 0 ] ; then 
  t1=$(date +%s%N)
  
  time=$(echo "($t1 - $t0) / 10^9" | bc -l)
  bytes=$(echo "$size * 10^6" | bc -l)
  value=$(echo "$bytes / $time" | bc -l)
else  
  echo "Timeout"
  value=0
fi

echo $bytes $time $value

curl -i -XPOST http://influxdb:8086/write?db=db --data-binary "$key value=$value $t0"