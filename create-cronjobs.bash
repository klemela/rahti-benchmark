#!/bin/bash

set -e

bash create-cronjob.bash bash-jobs/s3-put.bash '12 * * * *'
bash create-cronjob.bash bash-jobs/s3-put-2chunks.bash '22 * * * *'
bash create-cronjob.bash bash-jobs/s3-put-4chunks.bash '32 * * * *'
bash create-cronjob.bash bash-jobs/s3-put-2jobs.bash '42 * * * *' 2
