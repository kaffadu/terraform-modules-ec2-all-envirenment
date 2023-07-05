output "vpc_id" {
  value = aws_vpc.TP2-vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.TP2-vpc.cidr_block
}

output "web_public_subnets_id" {
  value = aws_subnet.web_public_subnets[*]
}



output "app_private_subnets_id" {
  value = aws_subnet.app_private_subnets[*]
}


output "security-group_id" {
  value = aws_security_group.TP2-sg.id
}


