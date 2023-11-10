data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["NAME-VPC"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Network"
    values = ["Private"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Network"
    values = ["Public"]
  }
}