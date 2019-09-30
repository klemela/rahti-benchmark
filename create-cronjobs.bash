#!/bin/bash

set -e

bash create-cronjob.bash bash-jobs/s3-put.bash '12 * * * *'
bash create-cronjob.bash bash-jobs/s3-put-2chunks.bash '22 * * * *'
bash create-cronjob.bash bash-jobs/s3-put-4chunks.bash '32 * * * *'
bash create-cronjob.bash bash-jobs/s3-put-2jobs.bash '28 * * * *' 2
bash create-cronjob.bash bash-jobs/s3-put-4k-1thread.bash '2 * * * *'
bash create-cronjob.bash bash-jobs/s3-put-4k-4threads.bash '3 * * * *'
bash create-cronjob.bash bash-jobs/s3-get-4k-1thread.bash '5 * * * *'
bash create-cronjob.bash bash-jobs/s3-get-4k-4threads.bash '6 * * * *'


bash create-cronjob.bash bash-jobs/net-send-1s.bash '4/10 * * * *'
bash create-cronjob.bash bash-jobs/net-send-10s.bash '52 * * * *'
bash create-cronjob.bash bash-jobs/net-send-30s.bash '53 6 * * *'

bash create-cronjob.bash bash-jobs/net-receive-1s.bash '5/10 * * * *'
bash create-cronjob.bash bash-jobs/net-receive-10s.bash '54 * * * *'
bash create-cronjob.bash bash-jobs/net-receive-30s.bash '55 6 * * *'

bash create-cronjob.bash bash-jobs/pvc-write.bash '56 * * * *'
