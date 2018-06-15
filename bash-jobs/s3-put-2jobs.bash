
set -x

timeout="1800"
size="4096"
jobs=2
key="s3-put-4GB-2jobs-2chunks"

rm -f /.aws/$key
touch /.aws/$key

dd if=/dev/urandom of=/opt/test/rand bs=1M count=$size

aws configure set default.s3.multipart_threshold 2048MB
aws configure set default.s3.multipart_chunksize 2048MB

for i in $(seq 1 $jobs); do 

  if [ $i == "$jobs" ]; then
    rm /.aws/replica_${jobs}_*
  fi

  if [ ! -f /.aws/replica_${jobs}_$i ]; then
    replica=$i
    break
  fi  
done

touch /.aws/replica_${jobs}_${replica}

t0=$(date +%s%N)
timeout $timeout aws s3 cp /opt/test/rand s3://chipster-rahti-benchmark/rand_${replica} --endpoint-url https://object.pouta.csc.fi 2>&1
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

echo key: $key bytes: $bytes time: $time value: $value

echo $value >> /.aws/$key

rows=$(cat /.aws/$key | wc -l)

if [ $rows == $jobs ]; then
  echo "get results"
  results="$(cat /.aws/$key | tr -d "\r")"

  i=1
  while read value; do    
    echo "result: $key $value $t0 $i"
    curl -s -XPOST http://influxdb:8086/write?db=db --data-binary "$key,job=$i value=$value $t0"
    i=$(echo "$i + 1" | bc)
  done < <(echo "$results")

  slowest=$(cat /.aws/$key | tail -n 1 | tr -d "\r")
  total=$(echo "$slowest * $jobs" | bc -l)
  echo "total: $key-total $total $t0"
  curl -s -XPOST http://influxdb:8086/write?db=db --data-binary "$key-total value=$total $t0"
fi