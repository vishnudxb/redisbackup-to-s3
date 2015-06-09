#!/bin/bash
REDISHOST=""
REDISPORT=""
S3BUCKET=""
ACCESS_KEY=""
SECRET_KEY=""

printhelp() {

echo "

Usage: sh redis.sh [OPTION]...

example: ./redis.sh -H redis.live.ng.0001.use1.cache.amazonaws.com -p 6379 -b redis-db-backup -a myaccesskey -s mysecretkey
  
  -H,    --redishost       Enter the AWS Redis Endpoint

  -p,    --redisport       Enter the redis port

  -b,    --bucket          Enter the bucket

  -a,    --access_key      Enter the AWS access key

  -s,    --secret_key      Enter the AWS secret key
		       
  -h,    --help            Display help file

"

}
while [ "$1" != "" ]; do
  case "$1" in
    -H    | --redishost )       REDISHOST=$2; shift 2 ;;
    -p    | --redisport )       REDISPORT=$2; shift 2 ;;
    -b    | --bucket )          S3BUCKET=$2;  shift 2 ;;
    -a    | --access_key )      ACCESS_KEY=$2;  shift 2 ;;
    -s    | --secret_key )      SECRET_KEY=$2;  shift 2 ;;
    -h    | --help )	        echo "$(printhelp)"; exit; shift; break ;;
  esac
done


mkdir -p .aws && echo "[default]\nregion = ap-southeast-1\naws_access_key_id = $ACCESS_KEY\naws_secret_access_key = $SECRET_KEY" > .aws/config
sudo apt-get install -y make gcc build-essential
cd ~/ && wget https://github.com/antirez/redis/archive/2.8.4.tar.gz && tar -xvf 2.8.4.tar.gz
cd ~/redis-2.8.4 && make 
cd ~/redis-2.8.4/src && ./redis-server &
sleep 15
cd ~/redis-2.8.4/src/ && ./redis-cli SLAVEOF $REDISHOST $REDISPORT 
echo "Wait for 2mins to sync redis replica with master"
sleep 120
cd ~/redis-2.8.4/src/ && ./redis-cli info | grep  '# Replication' -A 10 > /tmp/replication.txt
cd ~/redis-2.8.4/src/ && ./redis-cli BGSAVE
echo "Wait for 2mins to save redis dump"
sleep 120
cd ~/redis-2.8.4/src/ && sudo aws s3 cp dump.rdb s3://$S3BUCKET/
