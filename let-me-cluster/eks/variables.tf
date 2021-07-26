

variable "cluster_name" {
  type        = string
  description = "Name for of EKS cluster"
}

variable "public_subnets" {
  type        = list
  description = " Subnets for EKS to setup"
  default = []
  

}

variable "private_subnets" {
  type        = list
  description = " Subnets for EKS to setup"
  default = []
  

}

variable "vpc_id" {
  type        = string
  description = "Vpc for EKS to setup"
  default = ""
}

variable "kubernetes_version" {
  type        = string
  description = "The version of EKS to setup"
  default     = "1.19"
}

variable "region" {
  type        = string
  description = "Region of EKS to setup"
  default     = "ap-south-1"
}

variable "workers" {
  type        = string
  description = "The number of worker nodes create in the cluster"
  default     = "4"
}

variable "instance_type" {
  type        = string
  description = "Worker node instance type"
  default     = "c5d.2xlarge"
}

variable "instance_create_timeout" {
  type        = string
  description = "The timeout to use when creating instances"
  default     = "60"
}

variable "public_key_path" {
  type        = string
  description = "The path to a local public key file that will be injected to the instances"
  default     = "~/.ssh/id_rsa.pub"
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        =  list
  default     = [                        # Synopssys external-facing IPs:
                  "149.117.0.0/16",      # snps-1
                  "198.182.32.0/19",     # snps-2
                  "216.85.161.194/32",   # snps-4
                  "50.21.174.162/32",    # Hitakshi Office IP
                  "198.182.56.5/32",     # Hitakshi VPN IP
                  "192.231.134.1/32",    # DC2
                  "193.240.221.236/32",  # Theale and Belfast
                  "58.76.201.220/32",    # South Korea
                  "80.75.109.253/32",    # fuzztds office
                  "35.202.29.179/32",
                  "64.128.208.115/32",
                  "35.237.252.153/32",
                  "149.117.75.11/32",
                ]
}

variable "map_users" {
  type =list
  default = [{"groups":["system:masters"],"userarn":"arn:aws:iam::806067863659:user/ram-poc","username":"ram-poc"},{"groups":["system:masters"],"userarn":"arn:aws:iam::806067863659:user/rpramod-poc","username":"rpramod-poc"},{"groups":["system:masters"],"userarn":"arn:aws:iam::806067863659:user/nharinar-poc","username":"nharinar-poc"}]
}