#terraform {
 # backend "gcs" {}
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
  subnets                        = module.vpc.public_subnets
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  vpc_id                         = module.vpc.vpc_id
  cluster_endpoint_public_access = "true"
  cluster_endpoint_private_access= "true"
  write_kubeconfig               = "true"
  enable_irsa                    = true
  kubeconfig_output_path             = "../"
  map_users                      ="${var.map_users}"
  manage_aws_auth                = true
  cluster_create_timeout         = "${var.instance_create_timeout}m"
  tags = {
    Name = "${var.cluster_name}"
  }
  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }

  node_groups = {
    jobfarm = {
      desired_capacity = 1
      max_capacity     = 10
      min_capacity     = 1

      instance_types = ["c5d.2xlarge"]
      capacity_type  = "SPOT"
      k8s_labels = {
        
      }
      additional_tags = {
        
      }
      taints = [
        {
          key    = "NodeType"
          value  = "ScannerNode"
          effect = "NO_SCHEDULE"
        }
      ]
    }
  }
  worker_create_cluster_primary_security_group_rules = true
  worker_groups = [
    {
      worker_group_count   = 1
      instance_type        = "${var.instance_type}"
      asg_desired_capacity = "${length(var.workers) > 0 ? var.workers : 4}"
      asg_min_size         = "${length(var.workers) > 0 ? var.workers : 4}"
      asg_max_size         = 6
      root_volume_size     = "100"
      root_volume_type     = "gp2"
      public_ip            = "false"
      subnets           =    module.vpc.private_subnets
      key_name             = "${var.cluster_name}"
    }
  ]
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    token                  = data.aws_eks_cluster_auth.cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  }
}


module "eks-cluster-autoscaler" {
  source  = "lablabs/eks-cluster-autoscaler/aws"
  version = "1.3.0"
  # insert the 4 required variables here
  cluster_name                     = "${var.cluster_name}"
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn

   
}