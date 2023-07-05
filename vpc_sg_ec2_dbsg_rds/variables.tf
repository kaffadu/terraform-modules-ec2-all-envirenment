variable "region" {}

variable "vpc_cidr" {}

variable "instance_tenancy" {}

variable "enable_dns_hostnames" {}

variable "enable_dns_support" {}

variable "project_name" {}

variable "identifier1" {}

variable "identifier2" {}

variable "map_public_ip_on_launch" {}

variable "availability_zone" {}

variable "web_public_subnets_cidr" {}

variable "app_private_subnets_cidr" {}

variable "instance_type" {}

variable "public-server1" {}

variable "public-server2" {}

variable "private-server1" {}

variable "private-server2" {}

variable "associate_public_ip_address" {}

variable "allocated_storage" {}

variable "engine" {}

variable "engine_version" {}

variable "instance_class" {}

variable "db_name" {}

variable "username" {}

variable "password" {}

variable "parameter_group_name" {}

variable "skip_final_snapshot" {}

variable "db_subnet_group_name" {}

variable "name" {}

variable "ingressrules" {
    type        = list(number)
    default     = []
    description = "List of port numbers for ingress rules"
}

variable "egressrules" {
    type        = list(number)
    default     = []
    description = "List of port numbers for egress rules"
}
