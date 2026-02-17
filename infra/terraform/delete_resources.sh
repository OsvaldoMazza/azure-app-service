#!/bin/bash

echo "Deleting Terraform resources from Azure..."
terraform destroy -auto-approve

echo " --- Resources deleted successfully --- "
