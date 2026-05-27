variable "s3_bucket_name" {
    description = "This variabl holds s3 bucket name"
    default = "s3-bucket-aws-main"
    type = string
}

variable "env"{
    description = "This holds the environment name"
    type = string
    # default = "dev"
}
variable "s3_bucket_count" {
  description = "This value holds s3 bucket count"
  type = number
}