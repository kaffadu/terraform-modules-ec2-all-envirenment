project_name                = "Terraform-project2"
region                      = "eu-west-2"
vpc_cidr                    = "10.0.0.0/16"
enable_dns_hostnames        = true
enable_dns_support          = true
identifier1                 = "TP2-prod"
identifier2                 = "TP2-prod"
web_public_subnets_cidr     = ["10.0.22.0/24", "10.0.23.0/24"]
app_private_subnets_cidr    = ["10.0.24.0/24", "10.0.25.0/24"]
availability_zone           = ["eu-west-2a", "eu-west-2b"]
map_public_ip_on_launch     = true
instance_tenancy            = "default"
instance_type               = "t2.micro"
public-server1              = "Prod-Web-Server1"
public-server2              = "Prod-Web-Server2"
private-server1             = "Prod-App-Server1"
private-server2             = "Prod-App-Server2"
associate_public_ip_address = true
allocated_storage           = 20
engine                      = "mysql"
engine_version              = "8.0"
instance_class              = "db.t2.micro"
db_name                     = "tp2database"
username                    = "principal"
password                    = "password"
parameter_group_name        = "default.mysql8.0"
skip_final_snapshot         = true
db_subnet_group_name        = "dbsg"
role                        = "Terrafrom-ec2-rds"
egressrules                 = [0]
ingressrules                = [80, 22, 3306]
name                        = "TP2sg"



