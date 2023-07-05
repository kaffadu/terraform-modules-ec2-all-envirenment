
module "myinfra" {
  source                      = "./child-modules/vpc_sg_ec2_dbsg_rds"
  project_name                = var.project_name
  region                      = var.region
  vpc_cidr                    = var.vpc_cidr
  enable_dns_hostnames        = var.enable_dns_hostnames
  enable_dns_support          = var.enable_dns_support
  identifier1                 = var.identifier1
  identifier2                 = var.identifier2
  web_public_subnets_cidr     = var.web_public_subnets_cidr
  app_private_subnets_cidr    = var.app_private_subnets_cidr
  availability_zone           = var.availability_zone
  map_public_ip_on_launch     = var.map_public_ip_on_launch
  instance_tenancy            = var.instance_tenancy
  instance_type               = var.instance_type
  public-server1              = var.public-server1
  public-server2              = var.public-server2
  private-server1             = var.private-server1
  private-server2             = var.private-server2
  associate_public_ip_address = var.associate_public_ip_address
  allocated_storage           = var.allocated_storage
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  db_name                     = var.db_name
  username                    = var.username
  password                    = var.password
  parameter_group_name        = var.parameter_group_name
  skip_final_snapshot         = var.skip_final_snapshot
  db_subnet_group_name        = var.db_subnet_group_name
  ingressrules                = var.ingressrules
  egressrules                 = var.egressrules
  name                        = var.name
}

module "key-pair" {
  source       = "./child-modules/key-pair"
  project_name = var.project_name
}

module "iam-profile" {
  source       = "./child-modules/iam-profile"
  project_name = var.project_name
  role         = var.role

}

