# Region
provider aws{
    region= "ap-south-1"
}

# key-value pair
resource aws_key_pair ec2{
    key_name= "$(var.env)-demo-iac-key"
    public_key = file("demo-iac-key.pub")
}


# Default vpc
resource aws_default_vpc default{

}

# Security group
resource aws_security_group security_group{
    name= "$(var.env)-my_security_group"
    vpc_id= aws_default_vpc.default.id   # This is called interpolation
}

# Inbound and outbound rules of security_group
resource aws_vpc_security_group_ingress_rule allow_http {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = aws_default_vpc.default.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource  aws_vpc_security_group_egress_rule allow_all_traffic {
  security_group_id = aws_security_group.security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# EC2 instance
resource aws_instance my_instance{
    tags={
    Name= "$(var.env)-$(var.ec2_instance_name)"
    }
    count = var.ec2_instance_count
    ami= var.ec2_ami_id
    instance_type= var.ec2_instance_type
    key_name= aws_key_pair.ec2.key_name

   # vpc_id= aws_default_vpc.default.id
    vpc_security_group_ids=  [aws_security_group.security_group.id]

    # EBS storage
    root_block_device{
        volume_size= var.ec2_volume_size
        volume_type= "gp3"
    }

}
resource "aws_ec2_instance_state" "instance_state" {
    count= var.ec2_instance_count
    instance_id = aws_instance.my_instance[count.index].id
    # state = var.ec2_instance_name
    state = "running"
  
}

  
