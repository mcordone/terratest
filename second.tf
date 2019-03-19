terraform {
 backend "s3" {
  bucket="table1-mc-terraform"
  key = "terra/state"
  region = "us-east-1"
 }
}

provider "aws" {
 region = "us-east-1"
}

provider "aws" {
 alias="sa-east-1"
 region="sa-east-1"
}

resource "aws_instance" "table1_mc_frontend" {
 depends_on = ["aws_instance.table1_mc_backend"]
 ami = "ami-0565af6e282977273"
 instance_type = "t2.micro"
 key_name = "miguel-class-key"
 tags = { 
  Name = "table1mc_frontend_inst"
 }
 lifecycle {
  create_before_destroy = true
 }
}

resource "aws_instance" "table1_mc_backend" {
 count = 1
 provider="aws.sa-east-1" 
 ami = "ami-05eaf9b21ed6dee3c"
 instance_type = "t2.micro"
 key_name = "miguel-class-key"
 tags = {
  Name = "table1mc_backend_inst"
 }
 timeouts {
  create = "60m"
  delete = "2h"
 }
}
