# pwc-demo

This repo contains a deployment for flask app onto AWS EKS cluster, The repo contains the below

1- Terraform code for creating Cluster
2- flask python app with Dockerfile to containrize the flask app
3- github action workflow to automate the deployment of this container into the EKS

we will go through the details of each step but we will start listing the prerequisites 

## Pre-requisites

1- A machine contains terraform & configured to access AWS resources,  I used EC2 with ubuntu ( to install these tools please follow references link ).
2- github cli configured on your machine.

## Repository Structore

### Terraform 

**eks-demo.tf**
This file contains the EKS vpc configuration and the allow policy to assume the AWSEKSWorkerNodePolicy, This policy allow the EKS to interact with the WorkerNodes 

**vpc.tf**
This creates a vpc which the cluster will be created

**subnets.tf**
This TF file contains 4 subnets, 2 private subnets and 2 public subnets

**igw-demo.tf**
this will create the internet gateway for our VPC, the internet gateway will allow the VPC to access the internet 

**nat-eks.tf**
for the creation of NAT gateway, The NAT gateway will be used to allow the worker nodes to access the internet since they will be deployed in private subnet

**nodes.tf**
A configuration for the workers of the EKS, it contains policy to assume AWSEKSWorkerNodePolicy, AmazonEC2ContainerRegistryReadOnly, AmazonEKS_CNI_Policy:
- *AmazonEKS_CNI_Policy* This policy provides the Amazon VPC CNI Plugin the permissions it requires to modify the IP address configuration on your EKS worker nodes.
- *AmazonEC2ContainerRegistryReadOnly* It allows the worker nodes to list & retrieve the images from AWS ECR
- *AWSEKSWorkerNodePolicy* already mentioned above

**route-table.tf**
A configuration for the route tables that will be attached to the subnets, we will have two route tables, one route table will be attached to private subnets and will route the internet traffic to NAT gateway, another one will be connecting the route table 

Another configuration for attaching these route tables to the subnets.

**provier.tf**
this contains the region which will be used by terraform to deploy the AWS resources

## Steps
1. Login into your machine ( if you are using your own laptop then you need to configure aws credentials through AWS Config, if EC2 then you need to attach IAM role with required permissions ).
2. Clone reposiotry into your machine `https://github.com/Muhammedashraf10/pwc-demo.git`
3. cd into `cd aws-eks`

