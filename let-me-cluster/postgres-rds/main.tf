#terraform {
 # backend "gcs" {}
 #}
provider "aws" {
  region = var.region
  profile = "terraform"
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../eks-cluster/terraform.tfstate"
  }
}


resource "aws_security_group" "allow_postgres" {
  name        = "${var.db_name}-postgres-sg"
  description = "Allow postgres inbound traffic"
  vpc_id      = "${length(var.vpc_id) > 0 ? var.vpc_id :  data.terraform_remote_state.vpc.outputs.vpc_id}"

  tags = {
    Name = "${var.db_name}-postgres-sg"
  }
}

resource "aws_security_group_rule" "allow_postgres_rule_inbound" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_postgres.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/2.13.0
module "db" {
  source     = "terraform-aws-modules/rds/aws"
  version    = "~> 3.2.0"
  identifier = "${var.db_name}postgres"

  engine            = "postgres"
  engine_version    = var.postgres_version
  instance_class    = var.instance_class
  allocated_storage = 10
  storage_encrypted = false

  # kms_key_id            = "arm:aws:kms:<region>:<account id>:key/<kms key id>"
  name = "${var.db_name}postgres"

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username               = var.db_username
  password               = var.db_password
  port                   = "5432"
  vpc_security_group_ids = ["${aws_security_group.allow_postgres.id}"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Name = var.db_name
  }

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # DB subnet group
  subnet_ids = "${length(var.private_subnets) > 0 ? var.private_subnets :  data.terraform_remote_state.vpc.outputs.vpc_private_subnets}"

  publicly_accessible = var.public_access == true ? "true" : "false"
  # DB option group
  family               = "postgres${var.postgres_version}"
  major_engine_version = var.postgres_version

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "${var.db_name}-postgres-snapshot"

  # Database Deletion Protection
  deletion_protection = false
}


