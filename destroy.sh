#!/usr/bin/bash -e

region='eu-west-2'
cluster_name='chillipharm'

# Delete the namespace where the application is deployed. Terraform will not delete the Load Balancer.
aws eks --region $region update-kubeconfig --name $cluster_name
kubectl delete ns app

# Delete the EKS cluster and VPC.
terraform destroy --auto-approve