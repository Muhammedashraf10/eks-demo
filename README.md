# pwc-demo

This repo contains a deployment for flask app onto AWS EKS cluster, The repo contains the below

1. Terraform code for creating Cluster
2. flask python app with Dockerfile to containrize the flask app
3. github action workflow to automate the deployment of this container into the EKS

we will go through the details of each step but we will start listing the prerequisites 

## Pre-requisites

1. A machine contains terraform & configured to access AWS resources,  I used EC2 with ubuntu ( to install these tools please follow references link ).
2. github cli configured on your machine.
3. IAM User with Access & Secret keys with least privilage access to access ECR & EKS
4. an ECR/docker reposiotry 

## Repository Structore

### terraform/aws-eks 

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

## flask-app
This directory contains the flask app and the Dockerfile which used to dockerize this app

```
FROM python:3.9-slim # this will use a lighweight python image as a base image
WORKDIR /app # This will set the working directory inside the container as /app, any commands will be executed inside this directory
COPY . . # this will copy the files from the local directory where the Dockerfile exists into you container /app directory 
RUN pip install -r requirements.txt # this will install the requirements exist in this file
EXPOSE 5000 # will expose port 5000 and will allow the container to listen to port 5000
CMD ["python", "app.py"] # this is the commands will executed after the container starts

```
## kubernetes-deployment
This directory contains the actual kubernetes deployment and the service used to expose this deployment externally

**deployment.yaml**: used to create the deployment, it's labled with app-flask with replicas 3 and selector app-flask to group the pods with this label to the deployment and pods label is app-flask, container will use an image from ECR which built and uploaded with github workflow and exposing port 5000

**service.yaml**: this configuration contains the service used to explose the deployment externally, it uses selector app-flask to select the deployment, and forward traffic from port 80 to port 5000 which the container listens to, it uses service type loadbalancer which creates a classic loadbalancer on AWS.

## .github/workflows
**main.yaml** this contains the workflow which will be used to automate the deployment of our application into the cluster, it contains these steps:
1. Fetching the latest code from repo to workflow.
2. Authenticating to AWS ( we have created secrets on github to store AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_REGION ) to store AWS credentials.
3. Setting up docker and kubectl on the agent.
4. Login into the ECR repo through aws ecr get-login-password & getting the account ID to store it into $ACCOUNT_ID
5. Account ID and region will stored into ECR_URL
6. Repo will be cloned throuth git clone `https://github.com/Muhammedashraf10/pwc-demo.git` then we will change directory to `flask-app` which contains our application
7. We will build our application with `sudo docker build -t my-flask-app .`
8. We will tag the image with this command `docker tag my-flask-app:latest $ECR_URL/$REPOSITORY_NAME:latest` to be later pushed into our ECR
9. Now we are going to push the docker image `docker push $ECR_URL/$REPOSITORY_NAME:latest`
10. Now we need to authneticate the github agent to interact with the EKS cluster through ` aws eks update-kubeconfig --name demo-cluster --region ${{ secrets.AWS_REGION }}` where demo-cluster is the name of cluster we used to create in terraform
11. It's time now to deploy our application deployment and expose it through service, we will use `kubectl apply -f deployment.yaml` to deploy the application and `kubectl apply -f service.yaml` to deploy the service which used to expose the deployment externally
12. Now the service exposed on AWS CLB which can be accessed through CLB DNS

## Steps
1. Login into your machine ( if you are using your own laptop then you need to configure aws credentials through AWS Config, if EC2 then you need to attach IAM role with required permissions ).
2. Clone reposiotry into your machine `https://github.com/Muhammedashraf10/pwc-demo.git`
3. cd into `cd aws-eks`
4. use `terraform fmt` to format your terraform configuration into a style terraform format
5. `terraform validate` to validate runs checks that verify whether a configuration is syntactically valid and internally consistent, 
6. use `terraform init` to inialize the  terraform configuration files
7. `terraform plan` to preview the configration before applying it, this done through creating an exection plan to review it, you can use the optional -out=FILE option to save the generated plan to a file on disk, which you can later execute by passing the file to
8. the last is step is executing the actual code throuth `terraform apply`

*Note: Creating K8S will take up to 20mins to be created*
