#!/bin/bash

# Exit on any error
set -e

# Variables
SRC_DIR="$(dirname "$0")/../../src"
ROOT_DIR="$(cd "$(dirname "$0")/../../" && pwd)"
ZIP_FILE="$ROOT_DIR/src.zip"


# Load environment variables from .env file
if [ -f "$(dirname "$0")/.env" ]; then
  export $(grep -v '^#' "$(dirname "$0")/.env" | xargs)
fi

# Check if AZURE_SUBSCRIPTION_ID is set
# if [ -z "$AZURE_SUBSCRIPTION_ID" ]; then
#   echo "AZURE_SUBSCRIPTION_ID is not set in the .env file. Exiting."
#   exit 1
# fi

# Create ZIP file
if [ -d "$SRC_DIR" ]; then
  echo "Creating ZIP file from $SRC_DIR..."
  pushd "$SRC_DIR" > /dev/null
  zip -r "$ZIP_FILE" main.py requirements.txt
  popd > /dev/null
  echo "ZIP file created at $ZIP_FILE"

  # Move ZIP file to the same directory as the script
  mv "$ZIP_FILE" "$(dirname "$0")/src.zip"
  echo "ZIP file moved to $(dirname "$0")/src.zip"
else
  echo "Source directory $SRC_DIR does not exist. Exiting."
  exit 1
fi

# Set Azure subscription
# if [ -n "$AZURE_SUBSCRIPTION_ID" ]; then
#   echo "Setting Azure subscription to $AZURE_SUBSCRIPTION_ID..."
#   az account set --subscription "$AZURE_SUBSCRIPTION_ID"
# else
#   echo "Azure subscription ID is not set. Exiting."
#   exit 1
# fi

# Run Terraform
pushd "$(dirname "$0")" > /dev/null
terraform init
terraform apply -auto-approve
popd > /dev/null

echo "Deployment completed successfully."