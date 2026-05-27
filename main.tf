locals {
  env={
  dev={
    instance_count=2
    bucket_count=1
    dynamo_count=1
  }
  stg={
    instance_count=3
    bucket_count=1
    dynamo_count=1
  }
  prd={
    instance_count=4
    bucket_count=1
    dynamo_count=2
  }
  }
  current= lookup(local.env, terraform.workspace, local.env["dev"])
}

module "ec2" {
  source = "./modules/ec2"
  env = terraform.workspace
  ec2_instance_count= local.current.instance_count

}

module "s3" {
  source = "./modules/s3"
  env = terraform.workspace # Assigned during runtime
  s3_bucket_count = local.current.bucket_count
  s3_bucket_name  = "my-test-bucket-${terraform.workspace}"
}

module "dynamodb" {
  source = "./modules/dynamoDB"
  env = terraform.workspace
  dynamodb_table_count= local.current.dynamo_count
}