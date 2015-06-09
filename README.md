# redisbackup-to-s3
Taking the db dump from the AWS Elasticache (Redis) and copying it to AWS S3

Here we are using [Terraform] (https://www.terraform.io/) inorder to do the Automation.

#REQUIREMENTS
* Install Terraform
* You need to give the below values
```
AWS ACCESS KEY
AWS SECRET KEY
AWS REGION
AWS AVAILABILITY ZONE
AWS INSTANCE TYPE
KEY PAIR
KEY PAIR NAME on AWS
SUBNET ID
SECURITY GROUP ID
AWS ELASTICACHE ENDPOINT (REDIS)
AWS ELASTICACHE PORT	 

```
#HOW TO RUN THE COMMAND

```
vishnudxb@server:~# ./terraform apply -var 'access_key=<provide access key>' -var 'secret_key=<provide secret key>' -var 'key_file=<provide your pem file>' \
                                      -var 'key_name=<give the keypair name on AWS>' -var 'region=<aws region>' -var '<availability_zone>' \
                                      -var 'instance_type=<your instance type>' -var 'subnet_id=<your subnetid>'  -var 'security_id=<your security id>' \
                                      -var 'redis_endpoint=<your aws elasticache endpoint>' -var 'redis_port=<your elasticache port>' -var 'aws_bucket=<your s3 bucketname>'

```
#For example

```
vishnudxb@server:~# ./terraform apply -var 'access_key=PUTMYACCESSKEY' -var 'secret_key=PUTMYSECRETKEY' -var 'key_file=/home/redis.pem' -var 'key_name=redis' \
                                      -var 'instance_type=m3.large' -var 'region=us-east-1' -var 'availability_zone=us-east-1a' -var 'subnet_id=subnet-e94xxxx' \
                                      -var 'security_id=sg-7xxxx1d' -var 'redis_endpoint=redis.myidxxxx.ng.0001.use1.cache.amazonaws.com' \
                                      -var 'redis_port=6379' -var 'aws_bucket=redis-db-backup'

```
