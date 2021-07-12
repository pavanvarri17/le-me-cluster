**Terraform:**

1. Clone the source code from the Repo.
2. Make Sure you installed Terraform and aws cli in your machine.

   1. **Vpc:**

- Main.tf
- Variables.tf
- Output.tf
- Versions.tf

1. Main.tf:

This is the file in which we are defining all required terraform resources to be created for vpc.

You can Modify the values based on the requirements.

**Note: please update your aws configured profile name in the main.tf to interact with the aws env.**

1. Variables.tf:

- Region: Region of vpc to setup.
- vpc\_name : Name of the vpc to be created.
- You can customize the variables based on your requirements.

1. Output.tf:

- Vpc\_id: the id of the newly created vpc.
- Vpc\_cidr\_ip: the cidr\_block for the vpc.
- Vpc\_public\_subnets: (list)The public subnet id&#39;s the vpc.
- Vpc\_database\_subnets:(list) The db subnets for the vpc .
- Default\_sg: The default security group created by vpc.

1. Versions.tf:

It Includes all the dependencies about providers.

1. terraform {
2.   required\_version = &quot;~\&gt; 1.0.0&quot;
3.   required\_providers {
4.     aws      = >3.40
5.     template = > 2.1;
6.   }

**RDS\_postgress**

1. main.tf

This file contains definition of all the resources and modules that are used.

1. Variables.tf

- Region: (Default= &quot;ap-south-1&quot;) the region of rds to be setup.
- Postgress\_version:(default=&quot;9.6&quot;) postgress version.
- Db\_name: the name of the newly created db instance.
- Db\_username:(don&#39;t use &quot;user&quot; as username) the username for the db.
- Db\_password: password for the db with minimum length is 8 .
- Vpc\_id: vpc id for db (previously created vpc id)
- Subnets: subnets for the rds (db\_subnets of the previous vpc)
- Security group: security group for the rds (default vpc security group)
- Public\_acces: (Default= &quot;True&quot; ) to enable the public access for the db.
- Instance class: (Default= &quot;t2.micro&quot;) instance type of the db.

**Note** : For all the values which are obtained from above VPC module and used for the values for RDS . By default we are set the values by using &quot;terraform.tfstate&quot; file of vpc. The below code are used for fetching values from .tfstate file.

data &quot;terraform\_remote\_state&quot; &quot;vpc&quot; {

  backend = &quot;local&quot;

  config = {

    path = &quot;../vpc/terraform.tfstate&quot;

  }

}

Please observe it.

1. Output.tf

- Db\_endpoint: The endpoint of the db instance.
- Name: Name of the db created.
- Vpc\_database\_subnets: the subnet group id.

1. Versions.tf

- Terraform = &quot;~\&gt; 1.0.0&quot;
- Aws = &quot;~\&gt; 3.40 &quot;

**EKS:**

1. Main.tf

The definition for all the resources which are used to create eks-cluster.

1. Variables.tf

- Cluster\_name : the name of new cluster to be created .
- Subnets: the subnet id&#39;s of vpc for the cluster (public\_submet\_id&#39;s) of the vpc.
- Vpc\_id: id of the vpc.
- Region: (Default= &quot;ap-south-1&quot;) region of the eks-cluster to setup.
- Kubernetes version : kubernates version for the eks cluster.
- Workers: number of worker nodes .
- Instance\_type : EC2 instance type for the worker nodes.
- Instance\_create\_timeout: the timeout time for the instance is created.
- Public\_key\_path: path to the ssh key , which is used to create the keypair for ec2 instence.
- Cluster\_endpoint\_public\_access\_cidr : cluster endpoints.
- **Note** : For all the values which are obtained from above VPC module and used for the values for eks. By default we are set the values by using &quot;terraform.tfstate&quot; file of vpc. The below code are used for fetching values from .tfstate file.
- data &quot;terraform\_remote\_state&quot; &quot;vpc&quot; {
-   backend = &quot;local&quot;
-
-   config = {
-     path = &quot;../vpc/terraform.tfstate&quot;
-   }
- }

Please observe it.

1. Output.tf

- Master\_url : cluster endpoint.

There are so many values which are returning as outputs from the eks cluster.

1. Versions.tf

terraform {

required\_version = &quot;~\&gt; 1.0.0&quot;

required\_providers {

aws => 3.40&quot;

null => 2.1&quot;

random => 2.2&quot;

local => 1.4&quot;

template => 2.1&quot;


http = {

source = &quot;terraform-aws-modules/http&quot;

version =>2.4.1&quot;

}

}

}

**EXECUTION:**

**Please make sure You connected to the vpn incase of synopsys related aws account.**

**1.Please execute vpc before creating rds and eks.**

- Go to source code open vpc folder .
- Terraform init
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
