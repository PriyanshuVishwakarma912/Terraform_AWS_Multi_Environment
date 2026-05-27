variable "dynamodb_table_name" {
    description = "This variable holds the database table name"
    default = "practice_remote_table"
    type = string
  
}

variable "env"{
    description = "This holds the environment name"
    type = string
    # default = "dev"
}
variable "dynamodb_table_count" {
  description = "This value holds dynamodb table count"
  type = number
}