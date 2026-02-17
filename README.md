# Azure Web App Deployment Guide

This guide explains three different ways to deploy a web application to Azure, along with the scripts provided to automate each process:
1. Using Bicep templates.
2. Using Terraform.
3. Using Kubernetes with containers.

## 1. Deploying with Bicep

### Configuration
- Ensure you have the Azure CLI installed and logged in.
- Navigate to the `infra/bicep` directory.
- Update the `parameters.json` file with your desired configuration values.

### Commands
1. Run the deployment script:
   ```bash
   ./deploy_bicep.sh
   ```
   This script automates the deployment by running the Azure CLI commands to deploy the Bicep templates.

2. Verify the deployment in the Azure Portal.

---

## 2. Deploying with Terraform

### Configuration
- Ensure Terraform is installed.
- Navigate to the `infra/k8s` or `infra/terraform` directory.
- Update the `terraform.tfvars` file with your desired configuration values.

### Commands
1. Run the deployment script:
   ```bash
   ./deploy.sh
   ```
   This script automates the Terraform deployment process, including initializing Terraform, applying the configuration, and pushing the Docker image to Azure Container Registry (ACR).

2. Verify the deployment in the Azure Portal.

### Note
If you encounter an issue with `gunicorn` not being found during the App Service deployment, ensure that:
- `gunicorn` is listed in the `requirements.txt` file.
- The App Service is configured to use the correct startup command.

---

## 3. Deploying with Kubernetes (AKS)

### Configuration
- Ensure `kubectl` is installed and configured to point to your AKS cluster.
- Navigate to the `infra/k8s` directory.
- Update the `deployment.yaml` file with the correct container image URL.

### Commands
1. Run the deployment script:
   ```bash
   ./deploy.sh
   ```
   This script deploy the AKS, ACR, and ROLES resources with Terraform files. 
   Then call the `push_code_to_azure.sh` that build and push the Docker to ACR.
   Finally call the `config_k8s.sh` that updates the `deployment.yaml` kubernet file and configure the containers. This script shows the **External ID** to use to access to the Web App.

---

## Summary
Choose the deployment method that best fits your requirements. Bicep and Terraform are ideal for infrastructure as code, while Kubernetes is suitable for containerized applications. The provided scripts simplify the deployment process for each method.