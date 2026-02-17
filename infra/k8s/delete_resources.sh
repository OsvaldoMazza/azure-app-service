#!/bin/bash

echo "Deleting Kubernetes resources from AKS..."
kubectl delete -f deployment.yaml

echo "Deleting Terraform resources from Azure..."
terraform destroy -auto-approve

echo " --- Resources deleted successfully --- "
