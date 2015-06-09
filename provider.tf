# Configure the AWS Provider
provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

# Create a new instance on AWS using ubuntu AMI and Tag the new instance as "redis-backup"
resource "aws_instance" "web" {
    ami = "ami-d05e75b8"
    availability_zone = "${var.availability_zone}"
    instance_type = "${var.instance_type}"
    key_name  = "${var.key_name}"
    subnet_id = "${var.subnet_id}"
    security_groups = [ "${var.security_id}" ]
    tags {
        Name = "redis-backup"
    }
    connection {
        user = "ubuntu"
        key_file = "${var.key_file}"
    }
    provisioner "file" {
        source = "redis.sh"
        destination = "/tmp/redis.sh"
    }
    provisioner "remote-exec" {
        inline = [
           "sudo apt-get update && sudo apt-get install -y python-pip && sudo pip install awscli",
           "sh /tmp/redis.sh -H ${var.redis_endpoint} -p ${var.redis_port} -b ${var.aws_bucket} -a ${var.access_key} -s ${var.secret_key}"
        ] 
    }
}
