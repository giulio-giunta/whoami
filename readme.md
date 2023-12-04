# SRE Tech Test

This repository contains the application source code and all the configuration files needed to carry-out the assigned task. 

## Prerequisites

In order to run this project, an account with the following vendors is needed:
* AWS Cloud
* GitHub (or any Git like repository)
* Terraform Cloud
* Circleci 

The following command line tools are needed as well:
* awscli
* terraform cli
* docker
* kubectl

Moreover, to integrate a cicd pipeline (in this case Circleci) into the project, various environment variables need to be set in the cicd backend:
* `AWS_REGION` 
* `AWS_ACCESS_KEY_ID`	
* `AWS_SECRET_ACCESS_KEY`
* `DOCKER_USERNAME`
* `DOCKER_PASSWORD`
* `TERRAFORM_TOKEN`

Similarly, to allow Terraform to create the infrastructure in the AWS cloud, the following environment variables need to be configured in Terraform Cloud:
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`

## Folder layout

The project has the following sections:
* `app` - it contains the application source code, which was forked from https://github.com/traefik/whoami. 
* `.circleci` - it hosts the cicd configuration file.
* `kubernetes`: it contains the Kubernetes manifests to deploy the application in any k8s cluster.
* `terraform` - it contains IaC templates to create the infrastructure in the AWS cloud, which consists of a VPC with related network configuration and an EKS cluster with a managed node group.

## Getting started

The application can be run locally, by compiling the binary and executing it, or in a Docker container or even in a local K8s cluster, such as Kind or Minikube.

Whether locally or remotely, the use of the provided Makefile allows to easily build, test and lint the application code. This can be done manually, by running the Makefile targets in sequence, or automatically by adding them as steps of the ci pipeline, which is triggered when pushing any commit (even empty!) to the remote repository.

##### Compile the image
```sh
make build
```

##### Run tests
```sh
make test
```

##### Lint the code
```sh
make check
```

##### Build the Docker image
```sh
make image
```

The `deploy_infra` job in the Circleci pipeline takes care of deploying an EKS cluster, where the `deploy_application` job deploys the Docker image. 
A final step in the pipeline tests the new deployed application to make sure it runs as expected.

Each pipeline builds a new image, with a tag that references the pipeline number.

To tear down the whole infrastructure and k8s cluster, manually run the `destroy.sh` script in the root folder.  

## Choice of tools

For this project I chose to use a cloud environment, as it can be easily accessed from anywhere. 

To be able to consistently and predictably deploy the same infrastructure, I used Terraform and chose Terraform Cloud as a remote backend to store its state file. This ensures a unique source of truth and allows multiple engineers and the cicd pipeline to work concurrently on the same project.
On top of this, Terraform Cloud can be integrated with the remote Git repository to automatically detect and deploy changes to the underlining infrastructure.

Circleci allows to automate the deployment of the whole project. Any changes either to the infrastructure or the application would be automatically implemented.

## Further improvements
The image tagging mechanism can be improved to reflect real world use cases, however the current one illustrates how to manage application versioning.

A Load Balancer was used to expose the application to the internet, by creating a kubernetes service of type LoadBalancer. 
If various microservices were running in the cluster, a better alternative would have been using an Ingress Controller, which makes it a lot easier to route traffic (encrypted or not) from the public internet to the microservices. 

This and other improvements might be implemented, but is out of the scope to discuss them here.

