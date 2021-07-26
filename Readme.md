# le-me-cluster

# Terraform:
1.	Clone the source code from the Repo.
2.	Make Sure you installed Terraform and aws cli  in your machine.
**Vpc:**
  1.	Main.tf
  2.	Variables.tf
  3.	Output.tf
  4.	Versions.tf
  
**Main.tf:**

This is the file in which we are defining all required terraform resources to be created for vpc.
You can Modify the values based on the requirements.
Note: please update your aws configured profile name in the main.tf to interact with the aws env.

**Variables.tf:**
- Region: Region of vpc to setup.
-	vpc_name : Name of the vpc to be created.
-	You can customize the variables based on your requirements.

**Output.tf: **
-	Vpc_id: the id of the newly created vpc.
-	Vpc_cidr_ip: the cidr_block for the vpc.
-	Vpc_public_subnets: (list)The public subnet id’s the vpc.
-	Vpc_private_subnets:(list) The db subnets for the vpc .
-	Default_sg: The default security group created by vpc.

`        `**RDS\_postgress**

**main.tf**

`                                   `This file contains definition of all the resources and modules that are used.

** Variables.tf **
- Region: (Default= “ap-south-1”) the region of rds to be setup.
- Postgress\_version:(default=”9.6”) postgress version.
- Db\_name: the name of the newly created db instance.
- Db\_username:(don’t use “user” as username) the username for the db.
- Db\_password: password for the db with minimum length is 8 .
- Vpc\_id: vpc id for db (previously created vpc id)
- Subnets:  private subnets for the rds (db\_subnets of the previous vpc)
- Security group: security group for the rds (default vpc security group)
- Public\_acces: (Default= “false” ) to enable the public access for the db.
- Instance class: (Default= “t2.micro”)  instance type of the db.

**Note**: For all the values which are obtained from  above VPC module and used for the values for RDS . By default we are set the values by using “terraform.tfstate” file of vpc. The below code are used for fetching values from .tfstate file.

`  `data "terraform\_remote\_state" "vpc" {

`  `backend = "local"

`  `config = {

`    `path = "../vpc/terraform.tfstate"

`  `}

}

` `Please observe it.
**Output.tf**
 - Db\_endpoint: The endpoint of the db instance.
 - Name: Name of the db created.
 - Vpc\_database\_subnets: the subnet group id.
** Versions.tf**
 - Terraform = “~> 1.0.0”
 - Aws = “~> 3.40 “

**EKS:**

**Main.tf**

`    `The definition for all the resources which are used to create eks-cluster.
  **Variables.tf **
 - Cluster\_name :  the name of new cluster to be created .
 - Subnets: the subnet id’s of vpc for the cluster (public\_submet\_id’s) of the vpc.
 - Vpc\_id: id of the  vpc.
 - Region: (Default= “ap-south-1”) region of the eks-cluster to setup.
 - Kubernetes version : kubernates version for the eks cluster.
 - Workers: number of worker nodes .
 - Instance\_type : EC2 instance type for the worker nodes.
 - Instance\_create\_timeout: the timeout time for the instance is created.
- Public\_key\_path: path to the ssh key , which is used to create the keypair for ec2 instence.
- Cluster\_endpoint\_public\_access\_cidr : cluster endpoints.(synopsys IP list)
- **Note**: For all the values which are obtained from  above VPC module and used for the values for eks. By default we are set the values by using “terraform.tfstate” file of vpc. The below code are used for fetching values from .tfstate file.
 - `  `data "terraform\_remote\_state" "vpc" {
  `  `backend = "local"

  `  `config = {
 `    `path = "../vpc/terraform.tfstate"
  `  `}
  }

` `Please observe it.

**Output.tf**
- Master\_url : cluster endpoint.

`     `There are so many values which are returning as outputs from the eks cluster.

**Versions.tf**

`         `terraform {

`  `required\_version = "~> 1.0.0"

`  `required\_providers {

`    `aws      = "~> 3.40"

`    `null     = "~> 2.1"

`    `random   = "~> 2.2"

`    `local    = "~> 1.4"

`    `template = "~> 2.1"

`   ` kubernetes = "~>1.11"

`    `http = {

`      `source = "terraform-aws-modules/http"

`      `version = "2.4.1"

`    `}

`  `}

}

**EXECUTION:**

**Please make sure You connected to the vpn incase of synopsys related aws account.**

` `**1.Please  execute vpc before creating rds and eks.**

- Go to source code open vpc folder .
- ` `Terraform init
- Terraform plan
- Terraform apply
- Then give the all the required values.

Please note that we are using .tfstate file created by executing vpc module.

**RDS:**

- **Go to the rds folder**
- **Terraform init**
- **Terraform plan** 
- **Terraform apply**

**Eks:**

- **Go to the eks folder.**
- **Terraform init**
- **Terraform plan** 
- **Terraform apply**



