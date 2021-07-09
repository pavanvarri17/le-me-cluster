#terraform {
  #backend "gcs" {}
#}
provider "aws" {
  region = var.region
  profile = "terraform"
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

// ssh keypair
resource "aws_key_pair" "keypair" {
  key_name   = var.cluster_name
  public_key = file(var.public_key_path)
}

# https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/8.1.0

provider "kubernetes" {
  host                   = element(concat(data.aws_eks_cluster.cluster[*].endpoint, tolist([""])), 0)
  cluster_ca_certificate = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, tolist([""])), 0))
  token                  = element(concat(data.aws_eks_cluster_auth.cluster[*].token, tolist([""])), 0)
  #load_config_file       = false
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  cluster_name                   = "${var.cluster_name}"
  cluster_version                = "${var.kubernetes_version}"
  subnets                        = var.subnets
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  vpc_id                         = var.vpc_id
  cluster_endpoint_public_access = "true"
  cluster_endpoint_private_access= "true"
  write_kubeconfig               = "true"
  kubeconfig_output_path             = "../"
  manage_aws_auth                = true
  cluster_create_timeout         = "${var.instance_create_timeout}m"
  tags = {
    Name = "${var.cluster_name}"
  }
  worker_groups = [
    {
      worker_group_count   = 1
      instance_type        = "${var.instance_type}"
      asg_desired_capacity = "${length(var.workers) > 0 ? var.workers : 4}"
      asg_min_size         = "${length(var.workers) > 0 ? var.workers : 4}"
      asg_max_size         = 6
      root_volume_size     = "100"
      root_volume_type     = "gp2"
      public_ip            = "true"
      subnets              = "${var.subnets}"
      key_name             = "${var.cluster_name}"
    }
  ]
}

