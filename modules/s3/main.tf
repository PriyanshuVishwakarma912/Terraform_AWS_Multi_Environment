# # this is resource block
# resource "aws_s3_bucket" "my_bucket"{
# #     count = var.s3_bucket_count
# # bucket= "${var.s3_bucket_name}-${count.index +1}"
#     count= var.s3_bucket_count
#     tags = {
#       Name = "${var.s3_bucket_name}-${count.index + 1}"
#       tags = {
#       Environment=var.env
#     }  
#     }
# }




resource "aws_s3_bucket" "my_bucket" {
  count = var.s3_bucket_count

  bucket = "${var.s3_bucket_name}-${count.index + 1}"
  
  tags = {
    Name        = "${var.s3_bucket_name}-${count.index + 1}"
    Environment = var.env
  }
}